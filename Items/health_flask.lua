local health_flask = setmetatable({}, items.item_base)
health_flask.__index = health_flask

health_flask.category = "flasks"
health_flask.item_name = "Health Flask"

function health_flask:draw(x, y)
	pal(1, 2)
	pal(5, 8)
	pal(6, 14)
	SpriteGroup(313, x, y, 2, 2)
	pal()
end

function health_flask:select()
	self:remove()
	game_menu.close()
	game.player:heal(5)
end

return health_flask