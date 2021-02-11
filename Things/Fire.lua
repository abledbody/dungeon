local Fire = class("Fire", objects.Thing)

local anim_set = {
	fire = {
		spr =		{104,	105,	106},
		timing =	{0.15,	0.15,	0.15},
	}
}

function Fire:initialize(x, y)
	self.animator = game.Animator:new(anim_set, "fire")
	
	objects.Thing.initialize(self, x, y)
end

function Fire:update(dt)
	self.animator:update(dt)
end

function Fire:draw()
	local spr = self.animator:fetch("spr")
	Sprite(spr, self.x * 8, self.y * 8)
end

return Fire