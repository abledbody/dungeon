	--Constants--
local CLASSPATH = PATH.."Mobs/"

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
local Mob = dofile(CLASSPATH.."Mob.lua")

types.Slime = dofile(CLASSPATH.."Slime.lua")

	--Module--
local mobs = {}

mobs.Mob = Mob
mobs.all = all
mobs.doAll = doAll
mobs.types = types

return mobs