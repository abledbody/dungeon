local water_flask = setmetatable({}, items.item_base)
water_flask.__index = water_flask

water_flask.category = "flasks"
water_flask.item_name = "Speed Flask"

function water_flask:draw(x, y)
	pal(5, 13)
	pal(6, 12)
	Sprite(317, x, y)
	pal()
end

function water_flask:select()
	self:remove()
	game_menu.close()
	main.setState("throw_select")
	throw_select.item = self
end

return water_flask