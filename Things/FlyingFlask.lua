local DIRX, DIRY = const.DIRX, const.DIRY

local FlyingFlask = class("FlyingFlask", things.Thing)

local THROW_SPEED = 160
local GRAVITY = 200
local MAX_DIST = 12
local ROT_SPEED = 20

local function get_zvel(distance)
	return distance/THROW_SPEED*GRAVITY/2
end

function FlyingFlask:initialize(x, y, dir, item)
	local z = 0
	self.item = item

	self.sx = x * 8 + 4
	self.sy = y * 8 + 4
	self.sz = 0
	self.rot = 0

	local target_x, target_y, distance = gMap.ray_cast(x, y, dir, MAX_DIST)

	self.x_vel = DIRX[dir] * THROW_SPEED
	self.y_vel = DIRY[dir] * THROW_SPEED
	self.z_vel = get_zvel(distance * 8)

	things.Thing.initialize(self, target_x, target_y)
end

function FlyingFlask:update(dt)
	self.rot = self.rot + ROT_SPEED * dt

	self.sx = self.sx + self.x_vel * dt
	self.sy = self.sy + self.y_vel * dt
	self.sz = self.sz + self.z_vel * dt

	self.z_vel = self.z_vel - GRAVITY * dt
	
	if self.sz <= 0 then
		self.item:smash(self.x, self.y)
		self:remove()
	end
end

function FlyingFlask:draw()
	pushMatrix()
	cam("translate", self.sx, self.sy - self.sz)
	cam("rotate", self.rot)
	Sprite(219, -4, -4)

	popMatrix()
end

return FlyingFlask