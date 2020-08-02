local item = {}
item.__index = item

item.category = "other"
item.item_name = "INVALID_ITEM_TYPE"
item.count = 0

function item:add(count)
	local category = game_menu.categories[self.category]
	local slot = category[self.item_name]

	if not slot then
		game_menu.add_item(self)
	end
	
	self.count = self.count + count
end

function item:remove(count)
	if count > self.count then
		return false
	else
		self.count = self.count - count
	end

	local category = game_menu.categories[self.category]
	local slot = category[self.item_name]

	if slot then
		if self.count == 0 then
			game_menu.remove_item(self)
		end
	end
end

return item