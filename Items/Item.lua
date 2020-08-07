local item = {}
item.__index = item

item.category = "other"
item.item_name = "INVALID_ITEM_TYPE"

function item:draw()
	error("No draw function for item "..self.item_name)
end

function item:select()
	error("No select function for item "..self.item_name)
end

function item:add(count)
	game_menu.add_item(self, count)
end

function item:remove(count)
	count = count or 1
	local current_count = game_menu.peek_item_count(self)

	if current_count >= count then
		game_menu.remove_item(self, count)
		return true
	else
		return false
	end
end

return item