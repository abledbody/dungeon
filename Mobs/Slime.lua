	--Localization--
local rand = math.random

local Mob = mobs.Mob
local melee = components.melee
local health = components.health
local ai = dofile(MOBS_PATH.."AI/SlimeAI.lua")

local anim_set = {
	idle = {
		spr =		{202,	203},
		timing =	{0.5,	0.5}
    },
    
	attack = {
		spr = 		{203,	202,	204,	203},
		offX = 		{0,		1,		2,		1},
		timing = 	{0.08,	0.06,	0.11,	0.06}
	},
}

local Slime = class("Slime", Mob)

function Slime:initialize(x, y)
	self.move_speed = 1
	self.smoove_rate = 0.2

	Mob.initialize(self, x, y, anim_set)

	melee(self, 0.6)
	health(self, 3)
	ai(self)

	self.hit_sound = 13
	self.blood_color = 11
end

function Slime:kill()
	for i = 1, 10 do
		particleSys.newParticle(self.sx+4,self.sy+8,4,rand()*20-10,rand()*20-10,28,11,0,rand()+3)
	end

	Mob.kill(self)
end

return Slime