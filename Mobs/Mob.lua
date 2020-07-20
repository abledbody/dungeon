	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY
local rand = math.random

	--Class--
local Mob = class("Mob")

Mob.smoove_rate = 0.06
Mob.blood_color = 8
Mob.move_speed = 0.22

function Mob:initialize(x,y,aSet)
	self.x,self.y = x,y
	self.sx,self.sy = x*8,y*8

	self.t_move = game.Timer:new(self.move_speed)

	self.updates = {}
	self.draws = {}
	
	self.animator = game.Animator:new(aSet,"idle",{})

	gMap.setSquare(x,y,"blocked",self)
	gMap.setSquare(x,y,"mobs",self)

	table.insert(mobs.all,self)
end

function Mob:update(dt)
	self.sx,self.sy = game.smoove(
		self.sx,self.sy,
		self.x*8,self.y*8,
		self.smoove_rate/dt)

	for _,v in pairs(self.updates) do
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
			t_move:trigger(self.move_speed)
		end
		
		self:flipCheck(xM)
	end

	return couldMove
end

function Mob:hit(dir,damage)
	local xM,yM = DIRX[dir],DIRY[dir]

	for i = 1, 3 do
		particleSys.newParticle(
			self.x*8+4, self.y*8+4, 4,
			rand()*12-6+xM*20, rand()*12-6+yM*20, 17,
			self.blood_color, 0, rand()+3)
	end

	if self.hit_sound then
		SFX(self.hit_sound,1)
	end

	if self.damage then
		self:damage(damage)
	end
end

function Mob:kill()
	self:remove()
end

function Mob:remove()
	gMap.setSquare(self.x, self.y, "mobs", nil)
	gMap.setSquare(self.x, self.y, "blocked", nil)
	self.remove_me = true
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

	for _,v in pairs(self.draws) do
		v(self)
	end
end

return Mob