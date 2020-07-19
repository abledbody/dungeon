	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY

local function attack(self,dir)
	local melee_data = self.melee
	local timer = melee_data.timer

	if timer:check() then
		local xM,yM = DIRX[dir],DIRY[dir]
		local x = self.x + xM
		local y = self.y + yM

		local other = gMap.getSquare(x,y,"mobs")

		if not other and gMap.getSquare(x,y,"blocked") then
			SFX(melee_data.wall_sound)
		else
			SFX(melee_data.attack_sound)
		end

		self.animator:setState("attack")
		self:flipCheck(xM)

		timer:trigger()
	end
end

local function update(object, dt)
	object.melee.timer:update(dt)
end

local function attach(object)
	object.melee = {
		attack_sound = 0,
		wall_sound = 6,
		timer = game.Timer:new(0.4),
	}
	object.melee_attack = attack
	table.insert(object.updates, update)
end

return attach