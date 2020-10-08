NO_SPRITE = 384

object_data = {}

function object_data.draw_object(object_name, x, y)
	local object = object_data.objects[object_name]
	
	if object then
		if object.draw then
			object:draw(x * 8, y * 8)
		else
			f.Sprite(object.sprite or NO_SPRITE, x * 8, y * 8)
		end
	else
		f.Sprite(NO_SPRITE, x * 8, y * 8)
	end
end

function object_data.get_object_bounds(object_name, x, y)
	local object = object_data.objects[object_name]
	
	if object and object.get_bounds then
		return object.get_bounds(x, y)
	else
		return x, y, 8, 8
	end
end

function object_data.test_occupancy(object_name, test_x, test_y, object_x, object_y)
	local object = object_data.objects[object_name]
	
	if object and object.test_occupancy then
		return object.test_occupancy(test_x, test_y, object_x, object_y)
	else
		return test_x == object_x and test_y == object_y
	end
end

function object_data.get_object_layer(object_name)
	local object = object_data.objects[object_name]
	
	if object then
		return object.layer or 3
	else
		return 3
	end
end

object_data.objects = {}

--Mobs
object_data.objects.Slime = {
	sprite = 202,
	layer = 2,
}

--Things
object_data.objects.RobeStat = {
	sprite = 97,
	draw = function(self, x, y) f.SpriteGroup(self.sprite, 2, 3, x, y) end,
	get_bounds = function(x, y) return x, y, 16, 24 end,
	test_occupancy = function(test_x, test_y, object_x, object_y) return (test_x >= object_x and test_x < object_x + 2) and (test_y >= object_y + 1 and test_y < object_y + 3) end
}
object_data.objects.Chest = {
	sprite = 169,
	draw = function(self, x, y) palt(0, false) palt(1, true) f.Sprite(self.sprite, x, y) palt() end,
}
object_data.objects.Barrel = {
	sprite = 123,
}
object_data.objects.Bag = {
	sprite = 147,
}
object_data.objects.ExTile = {}