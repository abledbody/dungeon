	--Localization--
local clamp = math.clamp

	--Class--
local Health = class("Health")

function Health:initialize(maxHP, damageCalls, killCalls)
	maxHP = maxHP or 5
	self.maxHP = maxHP
	self.hp = maxHP
	self.damageCalls = damageCalls or {}
	self.killCalls = killCalls or {}
end

function Health:damage(dmg)
	local hp = self.hp-dmg
	
	for _,call in self.damageCalls do
		call(dmg)
	end

	if hp <= 0 then
		self:kill()
	end

	self.hp = clamp(hp,0,maxHP)
end

function Health:kill()
	for _,call in self.killCalls do
		call()
	end
end

return Health