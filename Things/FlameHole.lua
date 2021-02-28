local FlameHole = class("FlameHole", objects.Thing)

FlameHole.layer = 1 --[1] Floor Things

function FlameHole:initialize(x, y)
	game_map.setSquare(x, y, self)
	
	objects.Thing.initialize(self, x, y)
end

function FlameHole:set_activated(value)
	if value then
		if not self.fire_thing then
			self.fire_thing = objects.spawn("Fire", self.x, self.y, nil, self.room)
		end
	else
		if self.fire_thing then
			self.fire_thing:remove()
			self.fire_thing = nil
		end
	end
end

function FlameHole:draw()
	palt(1, true)
	palt(0, false)
	Sprite(124, self.x * 8, self.y * 8)
	palt()
end

function FlameHole:remove()
	game_map.setSquare(self.x, self.y, nil)
	objects.Thing.remove(self)
end

return FlameHole