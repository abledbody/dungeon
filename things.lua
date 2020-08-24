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
	for i, thing in pairs(all) do
		if thing.update then
			thing:update(dt)
		end

		if thing.remove_me then
			--print("Removed "..i)
			--sleep(1)
			table.remove(all, i)
		end
	end
end

function things.doAll(method,...)
	for i = 1, #all do
		all[i][method](all[i],...)
	end
end

function things.spawn(thing_type, x, y, meta, room)
	local itemCl = types[thing_type]
	if not itemCl then error("Could not find thing \""..thing_type.."\"") end

	local new_thing = itemCl:new(x, y, unpack(meta))
	new_thing.room = room
	table.insert(all, new_thing)

	return new_thing
end


things.types = types
things.all = all

return things