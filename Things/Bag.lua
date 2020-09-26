local Bag = class("Bag", objects.Thing)

local BAG_GRAVITY = 300
local BAG_JUMP = -60

function Bag:initialize(x, y, contains)
	game_map.setSquare(x, y, self)

	self.z = 0
	self.z_vel = BAG_JUMP

	local item = items.types[contains]

	components.searchable(self, item)

	objects.Thing.initialize(self, x, y)
end

function Bag:on_searched()
	self:remove()
end

function Bag:update(dt)
	if self.z_vel < 0 or self.z < 0 then
		self.z_vel = self.z_vel + BAG_GRAVITY * dt
		self.z = self.z + self.z_vel * dt
	else
		self.z = 0
	end
end

function Bag:draw()
	Sprite(147, self.x * 8, self.y * 8 + self.z)
end

function Bag:remove()
	game_map.setSquare(self.x, self.y, nil)
	objects.Thing.remove(self)
end

return Bag