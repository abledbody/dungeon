local speed_flask = setmetatable({}, items.item_base)
speed_flask.__index = speed_flask

speed_flask.category = "flasks"
speed_flask.item_name = "Speed Flask"

function speed_flask:draw(x, y)
	pal(1, 2)
	pal(5, 9)
	pal(6, 10)
	SpriteGroup(313, x, y, 2, 2)
	pal()
end

function speed_flask:select()
	self:remove()
	game_menu.close()
	--Give the player a temporary movement speed boost
end

return speed_flask