	--Localization--
	local rand = math.random

	local Mob = objects.Mob
	local melee = components.melee
	local health = components.health
	local ai = dofile(MOBS_PATH.."AI/Slime_AI.lua")
	
	local anim_set = {
		idle = {
			spr =		{201,	201,	201,	201},
			offY =		{0,		-1,		-2,		-1,},
			timing =	{0.7,	0.4,	0.7,	0.4,},
		},
		attack = {
			spr =		{201,	201,	201,	201,	201},
			offX =		{-1,	0,		1,		2,		1},
			offY =		{-1,	0,		1,		0,		0},
			timing =	{0.05,	0.02,	0.02,	0.2,	0.1},
		}
	}
	
	local Skull = class("Slime", Mob)
	Skull.move_speed = 0.8
	Skull.smoove_rate = 0.7
	Skull.hit_sound = 13
	Skull.blood_color = 7
	Skull.walk_sound = 24
	
	function Skull:initialize(x, y)
		Mob.initialize(self, x, y, anim_set)
	
		melee(self, 1.2, 3)
		health(self, 3)
		ai(self)
	end
	
	function Skull:draw()
		palt(0, false)
		palt(1, true)
		Mob.draw(self)
		palt()
	end
	
	function Skull:kill()
		for i = 1, 10 do
			particle_sys.newParticle(self.sx+4,self.sy+8,4,rand()*20-10,rand()*20-10,28,self.blood_color,0,rand()+3)
		end
	
		Mob.kill(self)
	end
	
	return Skull