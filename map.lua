local LAVA_SPRITE = 25

local gMap = {}

local mdat = dofile(PATH.."mdat.lua")

	--Localization--
local band = bit.band
local DIRX, DIRY = const.DIRX, const.DIRY
local abs = math.abs

	--Variables--
local sheetImage = SpriteMap:image()
local bg = sheetImage:batch()

local special_tiles = {
	[LAVA_SPRITE] = {
		animator = game.Animator:new(aData.lava, "anim"),
		update = function(self, dt)
			self.animator:update(dt)
			for i = 1, #self do
				bg:set(self[i].id, SpriteMap:quad(self.animator:fetch("spr")), self[i].x, self[i].y)
			end
		end
	}
}

local current_room = nil
local loaded_rooms = {}
local loading_room = nil

--This table is for checking grid positions for certain kinds of occupants.
--Their position indeces are written as [x.." "..y]
local gridData = {}


	--Functions--
function gMap.dist(x1,y1,x2,y2)
	local dx = abs(x2-x1)
	local dy = abs(y2-y1)

	return dx+dy
end

function gMap.ray_cast(x, y, dir, max_dist)
	local delta_x = DIRX[dir]
	local delta_y = DIRY[dir]

	for dist = 1, max_dist do
		local target_x =  x + delta_x * dist
		local target_y =  y + delta_y * dist

		if dist == max_dist or gMap.getSquare(target_x, target_y) then
			return target_x, target_y, dist
		end
	end
end

local function checkBit(flag,n)
	n = (n==0) and 1 or (2^n)
	return band(flag,n) == n
end

local function load_room_contents(room)
	local x, y = room.x, room.y

	local room_contents = loaded_rooms[loading_room]

	for i = 1, #room.mobs do
		local item = room.mobs[i]
		
		local name, xT, yT, meta = unpack(item)
		if not (name and xT and yT and meta) then error("Room data requires the name of the class, the x and y positions, and a table with spawning metadata.") end
		
		local new_mob = mobs.spawn(name, x+xT, y+yT, meta)
		table.insert(room_contents.mobs, new_mob)
	end

	for i = 1, #room.things do
		local item = room.things[i]
		
		local name,xT,yT,meta = unpack(item)
		if not (name and xT and yT and meta) then error("Room data requires the name of the class, the x and y positions, and a table with spawning metadata.") end
		
		local new_thing = things.spawn(name, x+xT, y+yT, meta)
		table.insert(room_contents.things, new_thing)
	end
end

local function tileIter(x,y,spr)
	if spr ~= 0 then
		--Rendering--
		local q = SpriteMap:quad(spr)
		
		local newTile = bg:add(q,x*8,y*8)
		table.insert(loaded_rooms[loading_room].tiles, newTile)

		if special_tiles[spr] then
			table.insert(special_tiles[spr], {id = newTile, x = x*8, y = y*8})
		end
		
		
		--Collision--
		local flags = fget(spr)
		
		if checkBit(flags,0) then
			gMap.setSquare(x,y,gridData)
		end
	end
end

local function load_room(room_index)
	local room = mdat.rooms[room_index]

	local rx, ry = room.rx, room.ry
	local rw, rh = room.rw, room.rh
	
	room.loaded = true

	loading_room = room_index
	loaded_rooms[loading_room] = {
		tiles = {},
		mobs = {},
		things = {},
	}

	TileMap:map(tileIter,rx,ry,rw,rh)
	
	load_room_contents(room)
end

local function unload_room(room_index)
	local room = loaded_rooms[room_index]

	for _, v in pairs(room.tiles) do
		bg:remove(v)
	end

	for _, v in pairs(room.things) do
		v:remove()
	end

	for _, v in pairs(room.mobs) do
		v:remove()
	end

	loaded_rooms[room_index] = nil
end

local function inBounds(xT, yT, room_index)
	local room = mdat.rooms[room_index]

	local x, y = room.x, room.y
	local w, h = room.w, room.h
	
	return yT>=y and xT>=x and yT<y+h and xT<x+w
end

function gMap.setSquare(x,y,value)
	gridData[x.." "..y] = value
end

function gMap.getSquare(x, y)
	return gridData[x.." "..y]
end

function gMap.bulk(obj,x,y,w,h,action)
	for i = x, x+w-1 do
		for j = y, y+h-1 do
			action(i,j,obj)
		end
	end
end

function gMap.switchRoom(new_room)
	current_room = new_room
	
	local room = mdat.rooms[current_room]

	if not room then
		error("switchRoom: No such room "..new_room)
	end
	
	local x, y = room.x, room.y
	
	if not room.loaded then
		load_room(current_room)
	end

	for _, v in pairs(room.con) do
		local connected_room = mdat.rooms[v]
		if not connected_room.loaded then
			load_room(v)
		end
	end

	for k in pairs(loaded_rooms) do
		local is_connected = false

		for _, v in pairs(mdat.rooms[k]) do
			local connected_room = mdat.rooms[v]
			
			if connected_room == current_room then
				is_connected = true
				break
			end
		end

		if not is_connected then
			unload_room(k)
		end
	end
	
	game.setCamTarget(x + room.cx, y + room.cy)
end

function gMap.find_room(current, x, y)
	if inBounds(x, y, current) then
		return false
	else
		local room = mdat.rooms[current]
		local connected = room.con
		
		--Searching through connected rooms to figure out which one the coordinate is in.
		for i = 1, #connected do
			local other_room_index = connected[i]
			local other_room = mdat.rooms[other_room_index]
			
			if not other_room then
				error("Could not find room index "..other_room_index)
			end
			
			if inBounds(x,y,other_room_index) then
				return other_room_index
			end
		end

		error("Could not find any rooms connected to "..current.." in coordinates "..x..", "..y)
	end
end

function gMap.plMoved(x,y)
	local new_room = gMap.find_room(current_room, x, y)
	if new_room then
		gMap.switchRoom(new_room)
	end
end

function gMap.draw()
	bg:draw()
end

function gMap.update(dt)
	for _,v in pairs(special_tiles) do
		if v.update then
			v:update(dt)
		end
	end
end

return gMap