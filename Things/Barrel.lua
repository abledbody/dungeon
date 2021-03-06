local rand = math.random

local Barrel = class("Barrel", objects.Thing)

function Barrel:initialize(x, y, contains)
	game_map.setSquare(x, y, self)

	components.bag_dropper(self, contains)

	objects.Thing.initialize(self, x, y)
end

function Barrel:hit()
	SFX(21,2)
	for i = 1, 18 do
		local particle_color = 4
		if rand() > 0.5 then
			particle_color = 15
		end
		particle_sys.newParticle(self.x*8 + 4, self.y*8 + 4, 4, rand()*40 - 20, rand()*40 - 20, rand()*40, particle_color, 0.6, rand() + 3)
	end
	self:remove()
	self:drop_bag()
end

function Barrel:draw()
	Sprite(123, self.x * 8, self.y * 8)
end

function Barrel:remove()
	game_map.setSquare(self.x, self.y, nil)
	objects.Thing.remove(self)
end

return Barrel