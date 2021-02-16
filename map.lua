local LAVA_SPRITE = 25

game_map = {}

local mdat = dofile(PATH.."mdat.lua")

	--Localization--
local band = bit.band
local DIR_X, DIR_Y = const.DIR_X, const.DIR_Y
local abs = math.abs

	--Variables--
local sheetImage = SpriteMap:image()
local bg = sheetImage:batch()

local special_tiles = {
	[LAVA_SPRITE] = {
		animator = game.Animator:new(a_data.lava, "anim"),
		update = function(self, dt)
			self.animator:update(dt)
			for i = 1, #self.tiles do
				local tile = self.tiles[i]
				bg:set(tile.id, SpriteMap:quad(self.animator:fetch("spr")), tile.x, tile.y)
			end
		end,
		tiles = {}
	}
}

local current_room = nil
local loaded_rooms = {}
local loading_room = nil

--This table is for checking grid positions for their occupants.
--Their position indeces are written as [x.." "..y]
local gridData

	--Functions--
function game_map.dist(x1,y1,x2,y2)
	local dx = abs(x2-x1)
	local dy = abs(y2-y1)

	return dx+dy
end

function game_map.ray_cast(x, y, dir, max_dist)
	local delta_x = DIR_X[dir]
	local delta_y = DIR_Y[dir]

	for dist = 1, max_dist do
		local target_x =  x + delta_x * dist
		local target_y =  y + delta_y * dist

		if dist == max_dist or game_map.getSquare(target_x, target_y) then
			return target_x, target_y, dist
		end
	end
end

local function checkBit(flag,n)
	n = (n==0) and 1 or (2^n)
	return band(flag,n) == n
end

local function load_room_contents(room_index)
	local room = mdat.rooms[room_index]

	for i = 1, #room.objects do
		local item = room.objects[i]
		
		local name, x, y, meta = unpack(item)
		if not (name and x and y and meta) then error("Room data requires the name of the class, the x and y positions, and a table with spawning metadata.") end
		
		local object = objects.spawn(name, x, y, meta, room_index)
		if object.static_object then
			table.insert(loaded_rooms[room_index].static_objects, object)
		end
	end
end

local function tileIter(x,y,spr)
	if spr ~= 0 then
		--Rendering--
		local q = SpriteMap:quad(spr)
		
		local newTile = bg:add(q,x*8,y*8)
		table.insert(loaded_rooms[loading_room].tiles, newTile)

		if special_tiles[spr] then
			table.insert(special_tiles[spr].tiles, {id = newTile, x = x*8, y = y*8})
		end
		
		
		--Collision--
		local flags = fget(spr)
		
		if checkBit(flags,0) then
			if not game_map.getSquare(x, y) then
				game_map.setSquare(x, y, gridData)
			end
		end
	end
end

local function reload_batch()
	bg = sheetImage:batch()
	for _, v in pairs(special_tiles) do
		v.tiles = {}
	end

	for k in pairs(loaded_rooms) do
		loading_room = k
		local room = mdat.rooms[k]

		local rx, ry = room.rx1,	room.ry1
		local rw, rh = room.rx2-rx,	room.ry2-ry

		TileMap:map(tileIter,rx,ry,rw,rh)
	end
end

local function load_room(room_index)
	loaded_rooms[room_index] = {
		tiles = {},
		static_objects = {},
	}
	
	load_room_contents(room_index)
end

local function unload_room(room_index)
	local room = loaded_rooms[room_index]

	for _, v in pairs(room.static_objects) do
		v:remove()
	end

	loaded_rooms[room_index] = nil
end

local function inBounds(test_x, test_y, room_index)
	local room = mdat.rooms[room_index]

	local x1, y1 = room.x1, room.y1
	local x2, y2 = room.x2, room.y2
	
	return test_y >= y1 and test_x >= x1 and test_y < y2 and test_x < x2
end

function game_map.setSquare(x, y, value, layer)
	layer = layer or 1
	gridData[layer][x.." "..y] = value
end

function game_map.getSquare(x, y, layer)
	layer = layer or 1
	return gridData[layer][x.." "..y]
end

function game_map.bulk(obj,x,y,w,h,action)
	for i = x, x+w-1 do
		for j = y, y+h-1 do
			action(i,j,obj)
		end
	end
end

function game_map.switchRoom(new_room)
	current_room = new_room
	
	local room = mdat.rooms[current_room]

	if not room then
		error("switchRoom: No such room "..new_room)
	end
	
	if not loaded_rooms[current_room] then
		load_room(current_room)
	end

	for _, v in pairs(room.con) do
		if not loaded_rooms[v] then
			load_room(v)
		end
	end

	for k in pairs(loaded_rooms) do
		if k ~= current_room then
			local is_connected = false

			for _, v in pairs(mdat.rooms[k].con) do
				if v == current_room then
					is_connected = true
					break
				end
			end

			if not is_connected then
				unload_room(k)
			end
		end
	end

	reload_batch()
	
	game.setCamTarget(room.cx, room.cy)
end

function game_map.find_room(current, x, y)
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

function game_map.plMoved(x,y)
	local new_room = game_map.find_room(current_room, x, y)
	if new_room then
		game_map.switchRoom(new_room)
	end
end

function game_map.is_loaded(room_index)
	return loaded_rooms[room_index]
end

function game_map.reset(room)
	for _, st in pairs(special_tiles) do
		st.tiles = {}
	end
	
	for k in pairs(loaded_rooms) do
		unload_room(k)
	end
	
	gridData = {
		{}, --[1] Colliders
		{},	--[2] Triggers
	}
	
	game_map.switchRoom(room)
	game.steady_camera()
end

function game_map.cell(x, y, index)
	TileMap:cell(x, y, index)
	reload_batch()
end

function game_map.draw()
	bg:draw()
end

function game_map.update(dt)
	for _,v in pairs(special_tiles) do
		if v.update then
			v:update(dt)
		end
	end
end