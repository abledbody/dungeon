--Dungeon game by abledbody

--Apply the custom Rayleigh palette
dofile("D:/dungeon/Rayleigh.lua")

--== Load third-party libraries ==--

--Middleclass library
local class = Library("class")

--== Load external libraries ==--

--Animation system
local anim = dofile("D:/dungeon/anim.lua")
--Extended math library
dofile("D:/dungeon/amath.lua")


--== Load external files ==--

--Animation data
local aData = dofile("D:/dungeon/adat.lua")
--Game constants
const = dofile("D:/dungeon/gameConsts.lua")


--== Localize some variables ==--

--math
local min, max, abs, sin = math.min, math.max, math.abs, math.sin
--amath extensions
local round = math.round

--Constants
local HSW,HSH = const.HSW,const.HSH
local DIRX,DIRY = const.DIRX,const.DIRY

---------------General----------------


--Modules--
--These are all forward declarations of modules defined later,
--so Lua can refer to these tables without needing to know what's in them.
diBox = {} --Dialogue box
gMap = {} --Game map
mobs = {} --Enemies, player, ect.
things = {} --Non-map objects within the game

--Parameters--
local camSmooth = 0.16

--Variables--
time = 0
pl = nil --Player mob

--The center of the camera in pixelspace
camX,camY = 480,48
--The center of the room in gridspace
roomX,roomY = 0,0

--Interaction indicated vertical position
local indicatorY = 0

--The last Examable looked at
lastLook = nil
lookCount = 1

--Available game loops
updates = {}
draws = {}

--Functions--
--Returns the first position, but slightly closer to the
--second position. Used repeatedly, slowly decelerates until
--the position is within half a pixel of the destination.
function smoove(x1,y1,x2,y2,s)
	local rate = 1/(s+1)
	
	local x,y =
		(x2-x1)*rate+x1,
		(y2-y1)*rate+y1
	
	--Snaps to destination when within half a pixel
	if abs(x-x2) < 0.5 and abs(y-y2) < 0.5 then
		x,y = x2,y2
	end
	
	return x,y
end

function examine(o,datLen)
	if o ~= lastLook then
		lastLook = o
		lookCount = 1
	end
	
	--We only want to increment lookCount after we have our data index,
	--so we save it here before modifying it.
	local index = lookCount
	--We use datLen to determine when to stop incrementing lookCount
	lookCount = min(lookCount+1,datLen)
	
	return index
end

--Just to change _update and _draw in the same line
function setState(state)
	_update = updates[state]
	_draw = draws[state]
end

--Classes--
--For whenever you need to wait for something.
local Timer = class("Timer")

function Timer:initialize(l)
	self.length = l
	self.timer = 0
	self.flag = true
end

function Timer:trigger(l)
	local timer,len = self.timer,self.length
	if l then
		self.length = l
	end
	
	--Just in case this timer gets triggered multiple times in a single frame.
	if timer <= 0 then
		self.timer = timer+len
	else
		self.timer = len
	end

	self.flag = false
end

function Timer:update(dt)
	local timer = self.timer
	
	if timer > 0 then
		timer = timer-dt
	end
	
	self.flag = timer <= 0
	
	self.timer = timer
end

function Timer:check()
	return self.flag
end


------------Dialogue Box--------------


diBox = dofile("D:/dungeon/diBox.lua")


-----------------Map------------------


do
local mdat = dofile("D:/dungeon/mdat.lua")

--Variables--
local sheetImage = SpriteMap:image()
local bg = sheetImage:batch()

local rooms = {}
local room = nil

--These tables are for checking grid positions for certain kinds of occupants.
--Their indeces are written as [x.." "..y]
local blocked = {}
local iacts = {}


--Functions--
local function checkBit(flag,n)
	n = (n==0) and 1 or (2^n)
	return bit.band(flag,n) == n
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
	
	roomX,roomY = x+room.cx,y+room.cy
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
gMap = {}
gMap.switchRoom = switchRoom
gMap.plMoved = plMoved

gMap.draw = draw

gMap.block = block
gMap.addIact = addIact
gMap.isBlocked = isBlocked    
gMap.isIact = isIact
end


----------------Mobs------------------


do
local all = {}
local types = {}

local function doAll(method,...)
	for i = 1, #all do
		local mob = all[i]
		mob[method](mob,...)
	end
end

local Mob = class("Mob")

function Mob:initialize(x,y,aSet)
	self.x,self.y = x,y
	self.sx,self.sy = x*8,y*8
	self.anim_i = 1
	self.anim_o = 0 
	self.states = aSet
	self:setState("idle")
	self.t_move = Timer:new(0.22)
	self.t_attack = Timer:new(0.4)
	self.smooveRate = 0.06
	
	table.insert(all,self)
end

function Mob:setState(state)
	self.anim_state = state
	local a = self.states[state]
	if not a then
		error("No such animation state "..state)
	end
	
	self.anim_o = a.timing[1]
	self.a,self.anim_i = a,1
end

function Mob:update(dt)
	local anim_i,anim_o,a,x,y,sx,sy,t_move,t_attack,anim_state,smooveRate = self.anim_i,self.anim_o,self.a,self.x,self.y,self.sx,self.sy,self.t_move,self.t_attack,self.anim_state,self.smooveRate
	
	--Animation--
	anim_i,anim_o,aEnd =
		anim.fetch(anim_i,anim_o,a.timing)
	anim_o = anim_o-dt
	
	self.anim_i,self.anim_o = anim_i,anim_o
	
	if aEnd and anim_state == "attack" then
		self:setState("idle")
	end
	
	--Other--
	sx,sy = smoove(sx,sy,x*8,y*8,smooveRate/dt)
	
	t_move:update(dt)
	t_attack:update(dt)
	
	self.sx,self.sy = sx,sy
end

function Mob:flipCheck(xM)
	if xM ~= 0 then
		self.flip = xM < 0
	end
end

function Mob:move(dir)
	local x,y,t_move = self.x,self.y,self.t_move
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	if t_move:check() then
		--Even if x and y are never modified, we still need the position for the block check.
		--If it passes, then we'll delocalize it.
		x,y = x+xM,y+yM
		
		if not gMap.isBlocked(x,y) then
			t_move:trigger()
			self.x,self.y = x,y
			SFX(7)
			if self.onMove then
				self:onMove()
			end
		end
		
		self:flipCheck(xM)
	end
end

function Mob:attack(dir)
	local x,y,t_attack = self.x,self.y,self.t_attack
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	if t_attack:check() then
		x,y = x+xM,y+yM
		
		self:setState("attack")
		
		if gMap.isBlocked(x,y) then
			SFX(6)
		else
			SFX(0)
		end
		
		self:flipCheck(xM)  
		
		t_attack:trigger()                
	end
end

function Mob:interact(dir)
	local x,y = self.x,self.y
	
	local xM,yM = DIRX[dir],DIRY[dir]
	x,y = x+xM,y+yM
	
	self:flipCheck(xM)
	
	local iact = gMap.isIact(x,y)
	
	if iact then
		iact:interact(self)
	end
end

function Mob:draw()
	local a,anim_i,sx,sy,f = self.a,self.anim_i,self.sx,self.sy,self.flip
	local spr = a.spr[anim_i]
	
	local sxScale = f and -1 or 1
	
	--Checking to see if our animation data has a sprite x offset.
	if a.offX then
		local offX = a.offX[anim_i]
		--Apply to sprite x offset.
		sx = sx+offX*sxScale
	end   
	
	--If the sprite is flipped, we need to account for the fact that the origin is on the upper left corner.
	sx = f and sx+8 or sx
	
	Sprite(spr,sx,sy,0,sxScale)
end

local Slime = class("Slime")

function Slime:initialize(x,y)
	local mob = Mob:new(x,y,aData.slime)
	
	mob.x,mob.y = x,y
	
	self.mob = mob
end

types.Slime = Slime

--Module--
mobs.Mob = Mob
mobs.doAll = doAll
mobs.types = types
end


---------------Things-----------------

do

--Variables--
local all = {}
local types = {}

--Functions--
local function doAll(method,...)
	for i = 1, #all do
		all[i][method](all[i],...)
	end
end

--Classes--
local Examable = class("Examinable")

Examable.dat = {
	"You have stumbled upon something\nthat was broken by a developer.\n\nGo away."
}

function Examable:trigger()
	local dat = self.dat
	local datLen = #dat
	
	local count = examine(self,datLen)
	diBox.show(dat[count])
end


local ExTile = class("ExTile")

function ExTile:initialize(x,y,dat)
	gMap.addIact(self,x,y)
	
	local examable = Examable:new()
	examable.dat = dat
	
	self.x,self.y,self.examable = x,y,examable
	table.insert(all,self)
end

function ExTile:draw()
end

function ExTile:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8
	y = y*8-5+indicatorY
	
	Sprite(361,x,y)
end

function ExTile:interact()
	self.examable:trigger()
end

types.ExTile = ExTile


local RobeStat = class("RobeStat")

RobeStat.dat = {
	"It's a statue of a robed figure.",
	"I don't recognize the face.",
	"It could be a saint.",
	"It's probably not a saint.",
	"It's very ominous.",
	"I don't really want to\nlook at it anymore.",
	"It's a statue of a robed figure."
}

function RobeStat:initialize(x,y)
	for i = x, x+1 do
		for j = y+1, y+2 do
			gMap.block(i,j)
			gMap.addIact(self,i,j)
		end
	end
	
	local examable = Examable:new()
	
	examable.dat = self.dat
	
	self.x,self.y,self.examable = x,y,examable
	table.insert(all,self)
end

function RobeStat:draw()
	local x,y = self.x,self.y

	SpriteGroup(97,x*8,y*8,2,3)
end

function RobeStat:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8+4
	y = y*8-5+indicatorY
	
	Sprite(361,x,y)
end

function RobeStat:interact()
	self.examable:trigger()
end

types.RobeStat = RobeStat

--Module--
things.RobeStat = RobeStat
things.types = types
things.doAll = doAll

end


---------------Program----------------


--Game start--
gMap.switchRoom(1)
pl = mobs.Mob:new(59,1,aData.player)

function pl:onMove()
	gMap.plMoved(self.x,self.y)
end

--Gameplay--

updates.game = function(dt)
	time = time+dt
	indicatorY = sin(time*7)+0.5
	
	--Camera--
	local _roomX,_roomY =
		roomX*8,roomY*8
	camX,camY =
		smoove(camX,camY,_roomX,_roomY,camSmooth/dt)
		
	--Player control--
	local attack = btn(5)
	local interact = btn(6)
	
	local vMove = (btn(3) and -1 or 0)+(btn(4) and 1 or 0)
	local hMove = (btn(1) and -1 or 0)+(btn(2) and 1 or 0)
	
	for i = 1, 4 do
		if btn(i) then
			if attack then
				pl:attack(i)
			elseif interact then
				pl:interact(i)
			else
				pl:move(i)
			end
			break
		end
	end
	--Mobs--
	mobs.doAll("update",dt)
end

draws.game = function()
	clear()
	
	pushMatrix()
	cam("translate",
		round(-camX+HSW),
		round(-camY+HSH))
	
	gMap.draw()
	mobs.doAll("draw")
	things.doAll("draw")
	
	local xCheck,yCheck
	
	for i = 1, 4 do
		xCheck = pl.x+DIRX[i]
		yCheck = pl.y+DIRY[i]
		local iact = gMap.isIact(xCheck,yCheck)
		if iact then
			iact:drawIndicator()
		end
	end
	
	popMatrix()
end   

--Dialogue Box--

updates.diBox = function(dt)
	diBox.update(dt)

	if btn(5) then
		setState("game")
	end
end

draws.diBox = function(dt)
	clear()
	diBox.draw()
end

_update = updates.game
_draw = draws.game