	--Constants--
local CLASSPATH = PATH.."Things/"

	--Module--
things = {
	--Interaction indicator vertical position
	indicatorY = 0,
	Thing = dofile(CLASSPATH.."Thing.lua"),
}

	--Variables--
local all = {}
local types = {
	RobeStat = dofile(CLASSPATH.."RobeStat.lua"),
	ExTile = dofile(CLASSPATH.."ExTile.lua"),
	Chest = dofile(CLASSPATH.."Chest.lua"),
	Barrel = dofile(CLASSPATH.."Barrel.lua"),
	Bag = dofile(CLASSPATH.."Bag.lua"),
	ItemPreview = dofile(CLASSPATH.."ItemPreview.lua"),
	FlyingFlask = dofile(CLASSPATH.."FlyingFlask.lua"),
}

	--Functions--
function things.update(dt)
	for k, v in pairs(all) do
		if v.update then
			v:update(dt)
		end
		if v.remove_me then
			print("removed "..k)
			sleep(1)
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


things.types = types
things.all = all

return things