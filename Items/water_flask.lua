local rand = math.random

local water_flask = setmetatable({}, items.item_base)
water_flask.__index = water_flask

water_flask.category = "flasks"
water_flask.item_name = "Water Flask"

function water_flask:draw(x, y)
	pal(5, 13)
	pal(6, 12)
	Sprite(317, x, y)
	pal()
end

function water_flask:select()
	game_menu.close()
	main.setState("throw_select")
	throw_select.item = self
end

function water_flask:throw(object, dir)
	self:remove()
	things.spawn("FlyingFlask", object.x, object.y, {dir, self})
end

function water_flask:smash(x, y)
	SFX(11, 1)
	for i = 1, 18 do
		particleSys.newParticle(x*8 + 4, y*8 + 4, 4, rand()*60 - 30, rand()*60 - 30, rand()*10, 7, 0.7, rand() + 3)
	end
	for i = 1, 18 do
		particleSys.newParticle(x*8 + 4, y*8 + 4, 0, rand()*40 - 20, rand()*40 - 20, rand()*40, 13, 0.1, rand() + 3)
	end
end

return water_flask