local rand = math.random

	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY

	--Class--
local Mob = class("Mob")

Mob.smooveRate = 0.06
Mob.updates = {}

function Mob:initialize(x,y,aSet)
	self.x,self.y = x,y
	self.sx,self.sy = x*8,y*8

	self.t_move = game.Timer:new(0.22)

	local function attackEndWrapper() Mob.attackAnimEnd(self) end
	self.animator = game.Animator:new(aSet,"idle",{attack = attackEndWrapper})

	table.insert(mobs.all,self)
end

function Mob:attackAnimEnd()
	self.animator:setState("idle")
end

function Mob:update(dt)
	self.sx,self.sy = game.smoove(
		self.sx,self.sy,
		self.x*8,self.y*8,
		self.smooveRate/dt)

	for k,v in pairs(self.updates) do
		v(self,dt)
	end

	self.t_move:update(dt)
	self.animator:update(dt)
end

function Mob:flipCheck(xM)
	if xM ~= 0 then
		self.flip = xM < 0
	end
end

function Mob:move(dir)
	local t_move = self.t_move
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	local couldMove = false

	if t_move:check() then

		local x,y = self.x,self.y
		local xNew,yNew = x+xM,y+yM
		
		if not gMap.getSquare(xNew,yNew,"blocked") then
			gMap.setSquare(x,y,"blocked",nil)
			gMap.setSquare(x,y,"mobs",nil)
			self.x,self.y = xNew,yNew
			gMap.setSquare(xNew,yNew,"blocked",true)
			gMap.setSquare(xNew,yNew,"mobs",self)
			couldMove = true
		end

		if couldMove then
			SFX(7)
			t_move:trigger()
		end
		
		self:flipCheck(xM)
	end

	return couldMove
end

function Mob:hit(dir)
	for i = 1, 4 do
		particleSys.newParticle(self.x*8,self.y*8,4,rand()*4-2,rand()*4-2,10,8,0)
	end
end

function Mob:interact(dir)
	local x,y = self.x,self.y
	
	local xM,yM = DIRX[dir],DIRY[dir]
	x,y = x+xM,y+yM
	
	self:flipCheck(xM)
	
	local iact = gMap.getSquare(x,y,"interactable")
	
	if iact then
		iact:interact(self)
	end
end

function Mob:draw()
	local animator,x,y,flip = self.animator,self.sx,self.sy,self.flip

	local xScale = flip and -1 or 1

	local spr = animator:fetch("spr")
	local offX = animator:fetch("offX")
	if offX then
		--Apply to sprite x offset.
		x = x+offX*xScale
	end
	
	--If the sprite is flipped, we need to account for the fact that the origin is on the upper left corner.
	x = flip and x+8 or x
	
	Sprite(spr,x,y,0,xScale)
end

return Mob