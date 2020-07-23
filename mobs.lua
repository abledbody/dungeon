	--Constants--
MOBS_PATH = PATH.."Mobs/"

	--Module--
mobs = {
	Mob = dofile(MOBS_PATH.."Mob.lua")
}

--Mobs need access to mobs.Mob to initialize
mobs.types = {
	Player = dofile(MOBS_PATH.."Player.lua"),
	Slime = dofile(MOBS_PATH.."Slime.lua"),
}

	--Variables--
local all = {}
local types = mobs.types

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

function mobs.spawn(mob_type, x, y, meta)
	local itemCl = types[mob_type]
	if not itemCl then error("Could not find mob \""..mob_type.."\"") end

	local mob
	if meta then
		mob = itemCl:new(x, y, unpack(meta))
	else
		mob = itemCl:new(x, y)
	end

	table.insert(all, mob)
end

return mobs