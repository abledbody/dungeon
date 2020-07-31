local Item = class("Item")

Item.category = "other"
Item.item_name = "INVALID_ITEM_TYPE"
Item.count = 0

function Item:add(count)
	local category = game_menu.categories[self.category]
	local slot = category[self.item_name]

	if not slot then
		category[self.item_name] = self
	end
	
	self.count = self.count + count
end

function Item:remove(count)
	local category = game_menu.categories[self.category]
	local slot = category[self.item_name]

	if slot then
		if slot.count - count <= 0 then
			category[self.item_name] = nil
		end
	end
end

return Item