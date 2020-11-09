local options = setmetatable({}, items.item_base)
options.__index = options

options.category = "system"
options.item_name = "Options"

function options:draw(x, y)
	Sprite(316, x, y)
end

function options:select()
end

return options