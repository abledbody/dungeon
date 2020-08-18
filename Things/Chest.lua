local Chest = class("Chest", things.Thing)

function Chest:initialize(x, y, contains)
	gMap.setSquare(x, y, self)

	local item = items.types[contains]

	components.searchable(self, item)

	things.Thing.initialize(self, x, y)
end

function Chest:on_searched()
	self.opened = true
	self.interact = nil
end

function Chest:draw()
	local sprite
	if self.opened then
		sprite = 170
	else
		sprite = 169
	end

	palt(0, false)
	palt(1, true)
	Sprite(sprite, self.x * 8, self.y * 8)
	palt()
end

function Chest:remove()
	gMap.setSquare(self.x, self.y, nil)
	things.Thing.remove(self)
end



return Chest