--FIXME
local SlimeAI = dofile(MOBS_PATH.."/AI/SlimeAI.lua")

local Slime = class("Slime")

function Slime:initialize(x,y)
	local ai = SlimeAI:new()
	local mob = mobs.Mob:new(x,y,aData.slime,ai)
	ai.mob = mob
	
	mob.x,mob.y = x,y
	mob.t_move.length = 1
	mob.t_attack.length = 0.7
	
	self.mob = mob
end

return Slime