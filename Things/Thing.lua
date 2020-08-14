local Thing = class("Thing")

Thing.interactable = false
Thing.indicator_point_x = 0
Thing.indicator_point_y = -5

function Thing:initialize(x, y)
	self.x, self.y = x, y
end


function Thing:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8 + self.indicator_point_x
	y = y*8 + self.indicator_point_y + things.indicatorY
	
	Sprite(361,x,y)
end

function Thing:remove()
	gMap.setSquare(self.x, self.y, nil)
	self.remove_me = true
end

return Thing