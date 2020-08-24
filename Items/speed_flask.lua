local DURATION = 3
local SPEED = 0.1

local speed_flask = setmetatable({}, items.item_base)
speed_flask.__index = speed_flask

speed_flask.category = "flasks"
speed_flask.item_name = "Speed Flask"

function speed_flask:draw(x, y)
	pal(1, 2)
	pal(5, 9)
	pal(6, 10)
	Sprite(317, x, y)
	pal()
end

local function effect_update(mob, dt)
	local effect = mob.status_effects.speed

	if effect.timer:check() then
		mob.status_effects.speed = nil
		mob.move_speed = effect.original_speed
		mob.updates.speed_effect = nil
	end
	
	effect.timer:update(dt)
end

function speed_flask:apply_effect(mob)
	local existing_effect = mob.status_effects.speed
	if existing_effect then
		if existing_effect.timer.timer < DURATION then
			existing_effect.timer:trigger(DURATION)
		end
	else
		mob.move_speed = SPEED
		mob.status_effects.speed = {
			timer = game.Timer:new(DURATION),
			original_speed = mob.speed,
		}
		mob.status_effects.speed.timer:trigger()
		mob.updates.speed_effect = effect_update
	end
end

function speed_flask:select()
	self:remove()
	game_menu.close()

	self:apply_effect(game.player)
end

return speed_flask