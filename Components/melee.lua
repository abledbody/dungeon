	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY
local rand = math.random

local function attack(self,dir)
	local melee = self.melee
	local timer = melee.timer

	if timer:check() then
		local xM,yM = DIRX[dir],DIRY[dir]
		local x = self.x + xM
		local y = self.y + yM

		local other = gMap.getSquare(x,y,"mobs")

		if other then
			other:hit(dir,melee.damage)
			SFX(melee.attack_sound)
		elseif gMap.getSquare(x,y,"blocked") then
			for i = 1, 3 do
				particleSys.newParticle(
					x*8+4, y*8+4, 0,
					rand()*30-15-xM*70, rand()*30-15-yM*70, rand()*16-8,
					7, 0.8, rand()*0.1+0.2)
			end
			SFX(melee.wall_sound)
		else
			SFX(melee.attack_sound)
		end

		self.animator:setState("attack")
		self:flipCheck(xM)

		timer:trigger()
	end
end

local function update(object, dt)
	object.melee.timer:update(dt)
end

local function attach(object,delay)
	object.melee = {
		attack_sound = 0,
		wall_sound = 6,
		timer = game.Timer:new(delay or 0.4),
		damage = 1,
	}
	object.melee_attack = attack
	table.insert(object.updates, update)
	object.animator.endCalls.attack = function() object.animator:setState("idle") end
end

return attach