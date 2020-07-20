	--Localization--
local clamp = math.clamp

local function damage(self, dmg)
	local health = self.health
	local hp = clamp(health.hp-dmg,0,health.maxHP)
	
	for _,call in pairs(health.damage_calls) do
		call(self, dmg)
	end

	if hp <= 0 then
		self:kill()
	end

	health.hp = hp
end

	--Class--
local function attach(object,maxHP,damage_calls)
	object.health = {
		maxHP = maxHP or 5,
		hp = maxHP,
		damage_calls = damage_calls or {},
	}
	object.damage = damage
end





return attach