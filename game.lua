--Localization--
local sin,abs,round,min = math.sin,math.abs,math.round,math.min
local HSW,HSH,DIRX,DIRY = const.HSW,const.HSH,const.DIRX,const.DIRY

--Parameters--
local camSmooth = 0.16

--Variables--
local time = 0
local pl = nil --Player mob

--The center of the camera in pixelspace
local xCam,yCam = 480,48
--The center of the room in gridspace
local xCamTarget,yCamTarget = 0,0

--The last Examable looked at
local lastLook = nil
local lookCount = 1

--Available game loops
local updates = {}
local draws = {}

--Functions--
--Returns the first position, but slightly closer to the
--second position. Used repeatedly, slowly decelerates until
--the position is within half a pixel of the destination.
local function smoove(x1,y1,x2,y2,s)
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

local function examine(o,datLen)
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

local function getTime()
	return time
end

local function setCamTarget(x,y)
	xCamTarget,yCamTarget = x,y
end

local function spawnPlayer(x,y)
	pl = mobs.Mob:new(x,y,aData.player)

	function pl:onMove()
		gMap.plMoved(self.x,self.y)
	end
end

--State--
local function update(dt)
	time = time+dt
	things.indicatorY = sin(time*7)+0.5
	
	--Camera--
	local _roomX,_roomY =
		xCamTarget*8,yCamTarget*8
	xCam,yCam =
		smoove(xCam,yCam,_roomX,_roomY,camSmooth/dt)
		
	--Player control--
	local attack = btn(5)
	local interact = btn(6)
	
	local vMove = (btn(3) and -1 or 0) + (btn(4) and 1 or 0)
	local hMove = (btn(1) and -1 or 0) + (btn(2) and 1 or 0)
	
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

local function draw()
	clear()
	
	pushMatrix()
	cam("translate",
		round(-xCam+HSW),
		round(-yCam+HSH))
	
	gMap.draw()
	mobs.doAll("draw")
	things.doAll("draw")
	
	local xCheck,yCheck
	
	for i = 1, 4 do
		xCheck = pl.x + DIRX[i]
		yCheck = pl.y + DIRY[i]
		local iact = gMap.isIact(xCheck, yCheck)
		if iact then
			iact:drawIndicator()
		end
	end
	
	popMatrix()
end   

--Loop calls--
main.updates.game = update
main.draws.game = draw

--Module--
local game = {}

game.smoove = smoove
game.examine = examine
game.time = getTime
game.setCamTarget = setCamTarget
game.spawnPlayer = spawnPlayer

game.Timer = dofile("D:/dungeon/classes/Timer.lua")

return game