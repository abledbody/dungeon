local function interact(self, other)
	if self.on_searched then self:on_searched(other) end
	self.searchable.contains:add()
	SFX(3, 2)
end

local function attach(object, item)
	local searchable = {
		contains = item
	}

	object.searchable = searchable
	object.interact = interact
end

return attach