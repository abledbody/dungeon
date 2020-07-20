	--Constants--
MOBS_PATH = PATH.."Mobs/"

	--Module--
mobs = {
	types = {},
	all = {},
	Mob = dofile(MOBS_PATH.."Mob.lua")
}

	--Variables--
local all = mobs.all

	--Functions--
function mobs.update(dt)
	for k, v in pairs(all) do
		v:update(dt)
		if v.remove_me then
			table.remove(all, k)
		end
	end
end

function mobs.doAll(method,...)
	for i = 1, #all do
		local mob = all[i]
		mob[method](mob,...)
	end
end

	--Types--
mobs.types = {
	Player = dofile(MOBS_PATH.."Player.lua"),
	Slime = dofile(MOBS_PATH.."Slime.lua"),
}

return mobs