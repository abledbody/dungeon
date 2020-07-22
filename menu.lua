local menu = {}

local cursor_animator = game.Animator:new(aData.cursor, "anim")

function menu.update_cursor(dt)
	cursor_animator:update(dt)
end

function menu.draw_cursor(x, y)
	local cursor_sprite = cursor_animator:fetch("spr")
	
	Sprite(cursor_sprite, x - 10, y)
end

return menu