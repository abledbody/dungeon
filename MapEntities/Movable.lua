local Movable = class("Movable")

function Movable:initialize(obj)
	self.obj = obj
end

function Movable:move(x,y)
	local obj = self.obj
	local x,y = obj.x+x,obj.y+y
	
	local couldMove = false
	
	if not gMap.isBlocked(x,y) then
		obj.x,obj.y = x,y
		couldMove = true
	end
	
	return couldMove
end

return Movable