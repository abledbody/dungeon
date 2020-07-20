local rand = math.random
local DIRX,DIRY = const.DIRX,const.DIRY

local Mob = dofile(MOBS_PATH.."Mob.lua")
local melee = dofile(COMPONENT_PATH.."melee.lua")
local health = dofile(COMPONENT_PATH.."health.lua")

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
	Mob.initialize(self, x, y, anim_set)
	melee(self, 0.6)
	health(self, 3)

	self.hit_sound = 13
end

function Slime:update(dt)
	local other = gMap.getSquare(self.x+1,self.y,"mobs")
	if other == game.pl() then
		self:melee_attack(2)
	end

	Mob.update(self, dt)
end

function Slime:hit(dir, damage)
	local xM,yM = DIRX[dir],DIRY[dir]

	for i = 1, 3 do
		particleSys.newParticle(self.x*8+4,self.y*8+8,4,rand()*12-6+xM*20,rand()*12-6+yM*20,17,11,0,rand()+3)
	end

	Mob.hit(self, dir, damage)
end

function Slime:kill()
	for i = 1, 10 do
		particleSys.newParticle(self.x*8+4,self.y*8+8,4,rand()*20-10,rand()*20-10,28,11,0,rand()+3)
	end

	Mob.kill(self)
end

return Slime