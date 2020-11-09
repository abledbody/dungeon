local rand = math.random

local Table = class("Table", objects.Thing)

function Table:initialize(x, y)
	game_map.setSquare(x, y, self)
	game_map.setSquare(x+1, y, self)

	components.health(self, 2)

	objects.Thing.initialize(self, x, y)
end

function Table:hit(_, damage)
	SFX(13, 1)
	self:damage(damage)
end

function Table:kill()
	SFX(21,2)
	for i = 1, 18 do
		local particle_color = 4
		if rand() > 0.5 then
			particle_color = 15
		end
		particle_sys.newParticle(self.x*8 + 8, self.y*8 + 4, 4, rand()*40 - 20, rand()*40 - 20, rand()*40, particle_color, 0.6, rand() + 3)
	end
	self:remove()
end

function Table:draw()
	SpriteGroup(99, self.x * 8, self.y * 8, 2, 1)
end

function Table:remove()
	game_map.setSquare(self.x, self.y, nil)
	game_map.setSquare(self.x + 1, self.y, nil)
	objects.Thing.remove(self)
end

return Table