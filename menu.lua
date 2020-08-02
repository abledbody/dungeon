local menu = {}

local cursor_animator = game.Animator:new(aData.cursor, "anim")

function menu.update_cursor(dt)
	cursor_animator:update(dt)
end

function menu.draw_cursor(x, y)
	local cursor_sprite = cursor_animator:fetch("spr")
	
	Sprite(cursor_sprite, x - 10, y)
end

function menu.cycle_next(list, selected)
	return selected % #list + 1
end

function menu.cycle_previous(list, selected)
	return (selected - 2) % #list + 1
end

return menu