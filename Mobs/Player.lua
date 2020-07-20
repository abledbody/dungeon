local Mob = dofile(MOBS_PATH.."Mob.lua")
local melee = dofile(COMPONENT_PATH.."melee.lua")
local health = dofile(COMPONENT_PATH.."health.lua")

local anim_set = {
    --Default player state
    idle = {
        spr = 		{193,	194,	195,	196},
        timing = 	{0.6,	0.06,	0.6,	0.06}
    },
    
    --Attack state, when the spear is used
    attack = {
        spr =		{197,	198,	199},
        offX =		{-1,	2,		0},
        timing =	{0.07,	0.08,	0.2}
    },
}

local Player = class("Player", Mob)

function Player:initialize(x, y)
	Mob.initialize(self, x, y, anim_set)
	melee(self, 0.4)

	self.move = function(self,dir)
		if Mob.move(self,dir) then gMap.plMoved(self.x,self.y) end
	end

	self.hit_sound = 8
end

function Player:kill()
	
end

return Player