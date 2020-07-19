	--Constants--
MOBS_PATH = PATH.."Mobs/"

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

	--Types--
types.Player = dofile(MOBS_PATH.."Player.lua")
types.Slime = dofile(MOBS_PATH.."Slime.lua")

	--Module--
local mobs = {}

mobs.Mob = dofile(MOBS_PATH.."Mob.lua")

mobs.all = all
mobs.doAll = doAll
mobs.types = types

return mobs