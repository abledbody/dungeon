local function drop_bag(self)
	things.spawn("Bag", self.x, self.y, {self.bag_dropper.contains})
end

local function attach(object, item)
	local bag_dropper = {
		contains = item
	}

	object.bag_dropper = bag_dropper
	object.drop_bag = drop_bag
end

return attach