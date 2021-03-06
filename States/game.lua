	--Localization--
local sin,abs,round,min = math.sin,math.abs,math.round,math.min
local HSW,HSH,DIR_X,DIR_Y = const.HSW,const.HSH,const.DIR_X,const.DIR_Y

	--Constants--
local CLASSPATH = PATH.."Game/"


game = {}

	--Parameters--

	--Variables--
local time

--The center of the camera in pixelspace
local xCam,yCam
--The center of the room in gridspace
local xCamTarget,yCamTarget

--The last Examable looked at
local lastLook
local lookCount

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

function game.steady_camera()
	xCam, yCam = xCamTarget * 8, yCamTarget * 8
end

function game.camera_smoove(dt)
	local _roomX, _roomY =
		xCamTarget*8, yCamTarget*8
	xCam, yCam = smoove(xCam, yCam, _roomX, _roomY, game.camSmooth/dt)
end

function game.camera_transform()
	cam("translate",
		round(-xCam + HSW),
		round(-yCam + HSH))
end

function game.screenshot()
	local imgDat = screenshot()
	game.scrImage = imgDat:image()
end

function game.reset()
	game.camSmooth = 0.16
	game.darkness = 3.99
	game.fade_speed = 10
	game.player = nil
	game.scrImage = nil
	
	time = 0
	xCam,yCam = 480,48
	xCamTarget,yCamTarget = 0,0
	lastLook = nil
	lookCount = 1
end

	--States--
function game.update(dt)
	time = time+dt
	objects.indicatorY = sin(time*7)+0.5
	
	--Camera--
	game.camera_smoove(dt)
		
	--Player control--
	local open_menu = btn_down(7)

	if open_menu then
		game_menu.open()
	end

	local attack = btn(5)
	local interact = btn(6)

	for i = 1, 4 do
		if btn_down(i) then
			if interact then
				game.player:trigger_interact(i)
			end
		elseif btn(i) and not interact then
			if attack then
					game.player:melee_attack(i)
			else
				game.player:move(i)
			end
			break
		end
	end
	
	objects.update(dt)

	game_map.update(dt)

	particle_sys.update(dt)

	game.darkness = math.max(game.darkness - game.fade_speed * dt, 0)
end

function game.draw()
	clear()

	brightness(game.darkness)
	
	pushMatrix()
	game.camera_transform()
	
	game_map.draw()
	particle_sys.draw()
	objects.doAll("draw")
	
	local xCheck,yCheck
	
	for i = 1, 4 do
		xCheck = game.player.x + DIR_X[i]
		yCheck = game.player.y + DIR_Y[i]
		local occupant = game_map.getSquare(xCheck,yCheck)
		if occupant and occupant.interact then
			occupant:drawIndicator()
		end
	end
	
	popMatrix()
end

	--Module--

game.smoove = smoove
game.examine = examine
game.time = getTime
game.setCamTarget = setCamTarget

game.Timer = dofile(CLASSPATH.."Timer.lua")
game.Animator = dofile(CLASSPATH.."Animator.lua")