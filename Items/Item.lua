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

function item:add()

end

function item:remove()

end

return item