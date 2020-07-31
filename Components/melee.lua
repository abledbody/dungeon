	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY
local rand = math.random

local function attack(self,dir)
	local melee = self.melee

	if self.t_disable:check() then
		local xM,yM = DIRX[dir],DIRY[dir]
		local x = self.x + xM
		local y = self.y + yM

		local other = gMap.getSquare(x,y)

		if other then
			if other.hit then
				other:hit(dir,melee.damage)
				SFX(melee.attack_sound)
			else
				for i = 1, 3 do
					particleSys.newParticle(
						x*8+4, y*8+4, 0,
						rand()*30-15-xM*70, rand()*30-15-yM*70, rand()*16-8,
						7, 0.8, rand()*0.1+0.2)
				end
				SFX(melee.wall_sound)
			end
		else
			SFX(melee.attack_sound)
		end

		self.animator:setState("attack")
		self:flipCheck(xM)

		self.t_disable:trigger(melee.delay)
	end
end

local function attach(object, delay, damage)
	object.melee = {
		attack_sound = 0,
		wall_sound = 6,
		delay = delay or 0.4,
		damage = damage or 1,
	}
	object.melee_attack = attack
	object.animator.endCalls.attack = function() object.animator:setState("idle") end
end

return attach