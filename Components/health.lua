	--Localization--
local clamp = math.clamp

local function damage(self, dmg)
	local health = self.health
	local hp = clamp(health.hp-dmg,0,health.max_hp)
	
	for _,call in pairs(health.damage_calls) do
		call(self, dmg)
	end

	if hp <= 0 then
		self:kill()
	end

	health.hp = hp
end

local function draw(self)
	local health = self.health
	local max_hp = health.max_hp
	local hp = health.hp

	if hp < max_hp and hp > 0 then
		color(8)
		rect(self.sx - max_hp/2 + 4,self.sy-2,max_hp,1)
		color(11)
		rect(self.sx - max_hp/2 + 4,self.sy-2,hp,1)
	end
end

	--Class--
local function attach(object, max_hp, damage_calls)
	object.health = {
		max_hp = max_hp or 5,
		hp = max_hp,
		damage_calls = damage_calls or {},
	}
	object.damage = damage
	table.insert(object.draws, draw)
end





return attach