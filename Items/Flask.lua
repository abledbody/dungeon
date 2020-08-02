local flask = setmetatable(items.item_base, {})

flask.category = "flasks"
flask.item_name = "Flask"

function flask:draw(x, y)
	SpriteGroup(313, x, y, 2, 2)
end

function flask:select()
	self:remove(1)
	game_menu.close()
end

return flask