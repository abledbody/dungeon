	--Localization--
local rand = math.random

local Mob = objects.Mob
local melee = components.melee
local health = components.health
local ai = dofile(MOBS_PATH.."AI/Slime_AI.lua")

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
Slime.move_speed = 1
Slime.smoove_rate = 0.2
Slime.hit_sound = 13
Slime.blood_color = 11
Slime.walk_sound = 24

function Slime:initialize(x, y)
	Mob.initialize(self, x, y, anim_set)

	melee(self, 0.6)
	health(self, 3)
	ai(self)
end

function Slime:kill()
	for i = 1, 10 do
		particle_sys.newParticle(self.sx+4,self.sy+8,4,rand()*20-10,rand()*20-10,28,11,0,rand()+3)
	end

	Mob.kill(self)
end

return Slime