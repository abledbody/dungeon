local rand = math.random

local DTile = class("DTile", objects.Thing)

DTile.sprite = 61
DTile.particle_color = 6

function DTile:initialize(x, y, sprite, particle_color)
	game_map.setSquare(x, y, self)
	game_map.setSquare(x+1, y, self)

	components.health(self, 2)
	
	self.sprite = sprite
	self.particle_color = particle_color

	objects.Thing.initialize(self, x, y)
end

function DTile:hit(_, damage)
	SFX(13, 1)
	self:damage(damage)
end

function DTile:kill()
	SFX(21,2)
	for i = 1, 18 do
		particle_sys.newParticle(self.x*8 + 4, self.y*8 + 6, 4, rand()*40 - 20, rand()*40 - 20, rand()*40, self.particle_color, 0.6, rand() + 3)
	end
	self:remove()
end

function DTile:draw()
	palt(0, false)
	Sprite(self.sprite, self.x * 8, self.y * 8)
	palt()
end

function DTile:remove()
	game_map.setSquare(self.x, self.y, nil)
	game_map.setSquare(self.x + 1, self.y, nil)
	
	objects.Thing.remove(self)
end

return DTile