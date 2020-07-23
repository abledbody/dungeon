	--Constants--
local CLASSPATH = PATH.."Things/"

	--Module--
local things = {
	--Interaction indicator vertical position
	indicatorY = 0
}

	--Variables--
local all = {}
local types = {}

	--Functions--
function things.update(dt)
	for k, v in pairs(all) do
		v:update(dt)
		if v.remove_me then
			table.remove(all, k)
		end
	end
end

function things.doAll(method,...)
	for i = 1, #all do
		all[i][method](all[i],...)
	end
end

function things.spawn(thing_type, x, y, meta)
	local itemCl = types[thing_type]
	if not itemCl then error("Could not find thing \""..thing_type.."\"") end

	table.insert(all, itemCl:new(x, y, unpack(meta)))
end

	--Classes--
local Examable = dofile(CLASSPATH.."Examable.lua")

types.RobeStat = dofile(CLASSPATH.."RobeStat.lua")
types.ExTile = dofile(CLASSPATH.."ExTile.lua")


things.types = types
things.all = all
things.Examable = Examable

return things