local mdat = dofile(PATH.."mdat.lua")

	--Map data verification--
for i = 1, #mdat.rooms do
	local con = mdat.rooms[i].con
	--In each of the connected rooms of this room
	for j = 1, #con do
		local otherIndex = con[j]
		local otherRoom = mdat.rooms[otherIndex]
		local otherCon = otherRoom.con
		
		local isConnected = false
		--We look for this room in the connections of the connected room
		for k = 1, #otherCon do
			local checkIndex = otherCon[k]

			if checkIndex == i then
				isConnected = true
				break
			end
		end

		if not isConnected then
			error("Room ["..otherIndex.."] is not connected to room ["..i.."]")
		end
	end
end

	--Localization--
local band = bit.band

	--Variables--
local sheetImage = SpriteMap:image()
local bg = sheetImage:batch()

local room = nil

--These tables are for checking grid positions for certain kinds of occupants.
--Their indeces are written as [x.." "..y]
local blocked = {}
local iacts = {}


	--Functions--
local function checkBit(flag,n)
	n = (n==0) and 1 or (2^n)
	return band(flag,n) == n
end

local function block(x,y)
	blocked[x.." "..y] = true
end

local function addIact(o,x,y)
	iacts[x.." "..y] = o
end

local function isBlocked(x,y)
	return blocked[x.." "..y]
end

local function isIact(x,y)
	return iacts[x.." "..y]
end

local function spawnInRoom(datTab,classTab,x,y)
	for i = 1, #datTab do
		local item = datTab[i]
		
		local name,xT,yT,meta = unpack(item)
		if not (name and xT and yT and meta) then error("Room data requires the name of the class, the x and y positions, and a table with spawning metadata.") end
		
		local itemCl = classTab[name]
		if not itemCl then error("Could not find item \""..name.."\"") end
		itemCl:new(x+xT,y+yT,unpack(meta))
	end
end

local function tileIter(x,y,spr)
	if spr ~= 0 then
		--Rendering--
		local q = SpriteMap:quad(spr)
		bg:add(q,x*8,y*8)
		
		--Collision--
		local flags = fget(spr)
		
		if checkBit(flags,0) then
			block(x,y)
		end
	end
end

local function reveal()
	local x,y,rx,ry,rw,rh = room.x,room.y,room.rx,room.ry,room.rw,room.rh
	
	room.rev = true
	TileMap:map(tileIter,rx,ry,rw,rh)
	
	spawnInRoom(room.things,things.types,x,y)
	spawnInRoom(room.mobs,mobs.types,x,y)
end

local function switchRoom(r)
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

local function inBounds(xT,yT,room)
	local x,y,w,h = room.x,room.y,room.w,room.h
	
	return yT>=y and xT>=x and yT<y+h and xT<x+w
end

local function plMoved(x,y)
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
				switchRoom(cri)
				break
			end
		end
		
	end
end

local function draw()
	bg:draw()
end

	--Module--
local gMap = {}

gMap.switchRoom = switchRoom
gMap.plMoved = plMoved

gMap.draw = draw

gMap.block = block
gMap.addIact = addIact
gMap.isBlocked = isBlocked    
gMap.isIact = isIact

return gMap