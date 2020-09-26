local Thing = class("Thing")

Thing.layer = 3 --[3] Things
Thing.static_object = true

Thing.interactable = false
Thing.indicator_point_x = 0
Thing.indicator_point_y = -5

function Thing:initialize(x, y)
	self.x, self.y = x, y
end


function Thing:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8 + self.indicator_point_x
	y = y*8 + self.indicator_point_y + objects.indicatorY
	
	Sprite(361,x,y)
end

function Thing:remove()
	self.remove_me = true
end

return Thing