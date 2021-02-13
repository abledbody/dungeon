local health_flask = setmetatable({}, items.item_base)
health_flask.__index = health_flask

health_flask.category = "flasks"
health_flask.item_name = "Health Flask"

function health_flask:draw(x, y)
	pal(1, 2)
	pal(5, 8)
	pal(6, 14)
	Sprite(317, x, y)
	pal()
end

function health_flask:select()
	self:remove()
	game_menu.close()
	game.player:heal(5)
	objects.spawn("BuffSparkles", game.player.x, game.player.y, {1}, game.player.room)
end

return health_flask