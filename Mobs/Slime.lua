local Slime = class("Slime")

function Slime:initialize(x,y)
	local mob = mobs.Mob:new(x,y,aData.slime)
	
	mob.x,mob.y = x,y
	
	self.mob = mob
end

return Slime