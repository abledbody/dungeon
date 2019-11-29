local Movable = class("Movable")

function Movable:initialize(entity)
	self.entity = entity
	gMap.setSquare(entity.x,entity.y,"blocked",true)
end

function Movable:move(xM,yM)
	local entity = self.entity
	local x,y = entity.x,entity.y
	xM,yM = x+xM,y+yM
	
	local couldMove = false
	
	if not gMap.getSquare(xM,yM,"blocked") then
		gMap.setSquare(x,y,"blocked",nil)
		entity.x,entity.y = xM,yM
		gMap.setSquare(xM,yM,"blocked",true)
		couldMove = true
	end
	
	return couldMove
end

return Movable