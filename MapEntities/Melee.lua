local Melee = class("Melee")

Melee.swingSound = 0
Melee.wallSound = 6

function Melee:trigger(x,y)
	if gMap.getSquare(x,y,"blocked") then
		SFX(self.wallSound)
	else
		SFX(self.swingSound)
	end
end

return Melee