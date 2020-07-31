local ExTile = class("ExTile", things.Thing)

function ExTile:initialize(x,y,dat)
	gMap.setSquare(x, y, self)
	
	components.examable(self, dat)
	
	things.Thing.initialize(self, x, y)
end

function ExTile:draw()
end

return ExTile