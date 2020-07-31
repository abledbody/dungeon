local mdat = dofile(PATH.."mdat.lua")

local LAVA_SPRITE = 25

local gMap = {}

	--Localization--
local band = bit.band
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

local room = nil

--This table is for checking grid positions for certain kinds of occupants.
--Their position indeces are written as [x.." "..y]
local gridData = {
}


	--Functions--
function gMap.dist(x1,y1,x2,y2)
	local dx = abs(x2-x1)
	local dy = abs(y2-y1)

	return dx+dy
end

local function checkBit(flag,n)
	n = (n==0) and 1 or (2^n)
	return band(flag,n) == n
end

local function spawnInRoom(datTab,classTab,x,y)
	for i = 1, #datTab do
		local item = datTab[i]
		
		local name,xT,yT,meta = unpack(item)
		if not (name and xT and yT and meta) then error("Room data requires the name of the class, the x and y positions, and a table with spawning metadata.") end
		
		classTab.spawn(name, x+xT, y+yT, meta)
	end
end

local function tileIter(x,y,spr)
	if spr ~= 0 then
		--Rendering--
		local q = SpriteMap:quad(spr)
		
		local newTile = bg:add(q,x*8,y*8)

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

local function reveal()
	local x,y,rx,ry,rw,rh = room.x,room.y,room.rx,room.ry,room.rw,room.rh
	
	room.rev = true
	TileMap:map(tileIter,rx,ry,rw,rh)
	
	spawnInRoom(room.things,things,x,y)
	spawnInRoom(room.mobs,mobs,x,y)
end

local function inBounds(xT,yT,room)
	local x,y,w,h = room.x,room.y,room.w,room.h
	
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

function gMap.switchRoom(r)
	room = mdat.rooms[r]
	
	if not room then
		error("switchRoom: No such room "..r)
	end
	
	local x,y = room.x,room.y
	
	if not room.rev then
		reveal()
	end
	
	game.setCamTarget(x + room.cx, y + room.cy)
end

function gMap.plMoved(x,y)
	if not inBounds(x,y,room) then
		local connected = room.con
		
		--Searching through connected rooms to figure out which one the player is in.
		for i = 1, #connected do
			local cri = connected[i]
			local cRoom = mdat.rooms[cri]
			
			if not cRoom then
				error("Could not find room index "..cri)
			end
			
			if inBounds(x,y,cRoom) then
				gMap.switchRoom(cri)
				break
			end
		end
		
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