	--Localization--
local DIR_X,DIR_Y = const.DIR_X,const.DIR_Y
local rand = math.random

	--Class--
local Mob = class("Mob")

Mob.layer = 2 --[2] Mobs

Mob.smoove_rate = 0.06
Mob.blood_color = 8
Mob.move_speed = 0.22
Mob.walk_sound = 7

function Mob:initialize(x,y,aSet)
	self.x,self.y = x,y
	self.sx,self.sy = x*8,y*8

	self.t_disable = game.Timer:new(self.move_speed)
	self.t_disable:trigger()

	self.updates = {}
	self.draws = {}
	self.status_effects = {}
	
	self.animator = game.Animator:new(aSet,"idle",{})

	game_map.setSquare(x,y,self)
end

function Mob:update(dt)
	self.sx,self.sy = game.smoove(
		self.sx,self.sy,
		self.x*8,self.y*8,
		self.smoove_rate/dt)

	for _,v in pairs(self.updates) do
		v(self,dt)
	end

	self.t_disable:update(dt)
	self.animator:update(dt)

	if not game_map.is_loaded(self.room) then
		self:remove()
	end
end

function Mob:flipCheck(xM)
	if xM ~= 0 then
		self.flip = xM < 0
	end
end

function Mob:move(dir)
	local t_disable = self.t_disable
	
	local xM,yM = DIR_X[dir],DIR_Y[dir]
	
	local couldMove = false

	if t_disable:check() then

		local x,y = self.x,self.y
		local xNew,yNew = x+xM,y+yM
		
		if not game_map.getSquare(xNew,yNew) then
			game_map.setSquare(x, y, nil)
			self.x, self.y = xNew, yNew
			game_map.setSquare(xNew, yNew, self)
			couldMove = true
		end

		if couldMove then
			SFX(self.walk_sound)
			t_disable:trigger(self.move_speed)
		end
		
		self:flipCheck(xM)
	end

	local new_room = game_map.find_room(self.room, self.x, self.y)
	if new_room then
		self.room = new_room
	end
	

	return couldMove
end

function Mob:out_of_bounds()
	self:remove()
end

function Mob:hit(dir,damage)
	local xM,yM = DIR_X[dir],DIR_Y[dir]

	for i = 1, 3 do
		particle_sys.newParticle(
			self.sx+4, self.sy+4, 4,
			rand()*30-15+xM*rand()*40, rand()*30-15+yM*rand()*40, 17,
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
	game_map.setSquare(self.x, self.y, nil)
	self.remove_me = true
end

function Mob:trigger_interact(dir)
	local x,y = self.x,self.y
	
	local xM,yM = DIR_X[dir],DIR_Y[dir]
	x,y = x+xM,y+yM
	
	self:flipCheck(xM)
	
	local occupant = game_map.getSquare(x,y)
	
	if occupant and occupant.interact then
		occupant:interact(self)
	end
end

function Mob:draw()
	local animator,x,y,flip = self.animator,self.sx,self.sy,self.flip

	local xScale = flip and -1 or 1

	local spr = animator:fetch("spr")
	local offX = animator:fetch("offX")
	local offY = animator:fetch("offY")
	if offX then
		--Apply to sprite x offset.
		x = x + offX * xScale
	end
	if offY then
		y = y + offY
	end
	
	--If the sprite is flipped, we need to account for the fact that the origin is on the upper left corner.
	x = flip and x+8 or x
	
	Sprite(spr, x, y, 0, xScale)

	for _, v in pairs(self.draws) do
		v(self)
	end
end

return Mob