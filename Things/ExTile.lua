local ExTile = class("ExTile", things.Thing)

function ExTile:initialize(x,y,dat)
	game_map.setSquare(x, y, self)
	
	components.examable(self, dat)
	
	things.Thing.initialize(self, x, y)
end

function ExTile:draw()
end

function ExTile:remove()
	game_map.setSquare(self.x, self.y, nil)
	things.Thing.remove(self)
end

return ExTile