local ItemPreview = class("ItemPreview", objects.Thing)

local RISE_HEIGHT = 10
local RISE_SMOOVE = 0.25
local FLASH_COUNT = 3
local FLASH_RATE = 0.1
local FLASH_TIME = 0.45

function ItemPreview:initialize(x, y, item)
	self.item = item

	self.target_z = RISE_HEIGHT
	self.z = 0
	self.visible = true
	self.flash_count = 0

	self.flash = game.Timer:new()
	self.flash:trigger(FLASH_TIME)

	objects.Thing.initialize(self, x, y)
end

function ItemPreview:update(dt)
	local _
	_, self.z = game.smoove(0, self.z, 0, self.target_z, RISE_SMOOVE/dt)

	self.flash:update(dt)

	if self.flash:check() then
		if self.flash_count >= FLASH_COUNT * 2 then
			self:remove()
		else
			self.visible = not self.visible
			self.flash:trigger(FLASH_RATE)
			self.flash_count = self.flash_count + 1
		end
	end
end

function ItemPreview:draw()
	if self.visible then
		self.item:draw(self.x*8, self.y*8 - self.z)
	end
end

return ItemPreview