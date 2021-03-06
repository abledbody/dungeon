local FlitterSpike = class("FlitterSpike", objects.Thing)


FlitterSpike.layer = 1 --[1] Floor Things

local anim_set = {
	flitter_spike = {
		spr =		{109,	107,	108,	109},
		timing =	{0.15,	0.1,	1,	0.2},
	}
}

function FlitterSpike:initialize(x, y)
	self.animator = game.Animator:new(anim_set, "flitter_spike", {})
	
	objects.Thing.initialize(self, x, y)
end

function FlitterSpike:update(dt)
	self.animator:update(dt)
end

function FlitterSpike:draw()
	local spr = self.animator:fetch("spr")
	Sprite(spr, self.x * 8, self.y * 8)
end

return FlitterSpike