local BuffSparkles = class("BuffSparkles", objects.Thing)

local anim_set = {
	sparkles = {
		spr =		{205,	206,	207,	208,	209,	210,	211},
		timing =	{0.07,	0.07,	0.07,	0.07,	0.07,	0.07,	0.07},
	}
}

local palettes = {
	{8, 14, 2}, --[1] Health Red
	{1, 3, 11}, --[2] Poison Green
	{2, 5, 13}, --[3] Magic Purple
	{5, 6, 7}, --[4] Plain grey
}

function BuffSparkles:initialize(x, y, palette)
	local anim_end
	
	self.animator = game.Animator:new(anim_set, "sparkles")
	self.animator.endCalls.sparkles = function() self:remove() end
	self.palette = palettes[palette]
	
	objects.Thing.initialize(self, x, y)
end

function BuffSparkles:update(dt)
	self.animator:update(dt)
end

function BuffSparkles:draw()
	local palette = self.palette
	
	pal(5, palette[1])
	pal(6, palette[2])
	pal(7, palette[3])
	
	local spr = self.animator:fetch("spr")
	Sprite(spr, self.x * 8, self.y * 8)
	
	pal()
end

return BuffSparkles