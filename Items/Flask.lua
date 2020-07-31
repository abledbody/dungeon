local Flask = class("Flask", items.Item)

Flask.category = "flasks"
Flask.item_name = "Flask"

function Flask:draw(x, y)
	SpriteGroup(313, x, y, 2, 2)
end

function Flask:select()
	self:remove(1)
	game_menu.close()
end

return Flask