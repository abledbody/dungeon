	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY

local function attack(self,dir)
	local melee = self.melee
	local timer = melee.timer

	if timer:check() then
		local xM,yM = DIRX[dir],DIRY[dir]
		local x = self.x + xM
		local y = self.y + yM

		local other = gMap.getSquare(x,y,"mobs")

		if other then
			other:hit(dir,1)
			SFX(melee.attack_sound)
		elseif gMap.getSquare(x,y,"blocked") then
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
	}
	object.melee_attack = attack
	table.insert(object.updates, update)
	object.animator.endCalls.attack = function() object.animator:setState("idle") end
end

return attach