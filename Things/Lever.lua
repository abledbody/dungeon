local Lever = class("Lever", objects.Thing)

Lever.animating = true

local anim_set = {
	switch_on = {
		spr =		{102},
		timing =	{0.1},
	},
	
	switch_off = {
		spr =		{102},
		timing =	{0.1},
	},
}

function Lever:initialize(x, y, target_x, target_y)
	game_map.setSquare(x, y, self)
	
	local function endCall() self.animating = false end
	
	self.animator = game.Animator:new(anim_set, "switch_off")
	self.animator.endCalls.switch_on = endCall
	self.animator.endCalls.switch_off = endCall

	self.target_x, self.target_y = target_x, target_y

	objects.Thing.initialize(self, x, y)
end

function Lever:update(dt)
	if self.animating then
		self.animator:update(dt)
	end
end

function Lever:draw()
	local sprite
	if self.animating then
		sprite = self.animator:fetch("spr")
	else
		sprite = self.animator.state == "switch_on" and 103 or 101
	end

	Sprite(sprite, self.x * 8, self.y * 8)
end

function Lever:remove()
	game_map.setSquare(self.x, self.y, nil)
	objects.Thing.remove(self)
end

function Lever:interact()
	local on = self.animator.state == "switch_on"
	
	self.animating = true
	SFX(14, 0)
	
	if on then self.animator:setState("switch_off")
	else self.animator:setState("switch_on") end
	
	if self.target_x and self.target_y then
		local target = game_map.getSquare(self.target_x, self.target_y)
		if target.set_activated then
			target.set_activated()
		end
	end
end

return Lever