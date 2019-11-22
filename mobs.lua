--Variables--
local all = {}
local types = {}

--Functions--
local function doAll(method,...)
	for i = 1, #all do
		local mob = all[i]
		mob[method](mob,...)
	end
end

--Classes--
local Mob = dofile("D:/dungeon/Mobs/Mob.lua")

types.Slime = dofile("D:/dungeon/Mobs/Slime.lua")

--Module--
local mobs = {}

mobs.Mob = Mob
mobs.all = all
mobs.doAll = doAll
mobs.types = types

return mobs