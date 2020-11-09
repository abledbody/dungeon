	--Constants--
MOBS_PATH = PATH.."Mobs/"
THINGS_PATH = PATH.."Things/"

	--Module--
objects = {
	indicatorY = 0,
	Mob = dofile(MOBS_PATH.."Mob.lua"),
	Thing = dofile(THINGS_PATH.."Thing.lua")
}

--Mobs need access to mobs.Mob to initialize
objects.types = {
	Player = dofile(MOBS_PATH.."Player.lua"),
	Slime = dofile(MOBS_PATH.."Slime.lua"),
	Skull = dofile(MOBS_PATH.."Skull.lua"),

	RobeStat = dofile(THINGS_PATH.."RobeStat.lua"),
	ExTile = dofile(THINGS_PATH.."ExTile.lua"),
	Chest = dofile(THINGS_PATH.."Chest.lua"),
	Barrel = dofile(THINGS_PATH.."Barrel.lua"),
	Bag = dofile(THINGS_PATH.."Bag.lua"),
	ItemPreview = dofile(THINGS_PATH.."ItemPreview.lua"),
	FlyingFlask = dofile(THINGS_PATH.."FlyingFlask.lua"),
}

	--Variables--
local all
local types = objects.types

	--Functions--
function objects.update(dt)
	for layer = 1, #all do
		for k, v in pairs(all[layer]) do
			if v.update then
				v:update(dt)
			end
			if v.remove_me then
				table.remove(all[layer], k)
			end
		end
	end
end

function objects.doAll(method,...)
	for layer = 1, #all do
		for i = 1, #all[layer] do
			local object = all[layer][i]

			if object[method] then
				object[method](object,...)
			end
		end
	end
end

function objects.spawn(object_type, x, y, meta, room)
	local objectClass = types[object_type]
	if not objectClass then error("Could not find object \""..object_type.."\"") end

	local object
	if meta then
		object = objectClass:new(x, y, unpack(meta))
	else
		object = objectClass:new(x, y)
	end
	object.room = room


	local layer = object.layer or 3

	table.insert(all[layer], object)

	return object
end

function objects.reset()
	all = {
		{}, --[1] Floor Things
		{}, --[2] Mobs
		{}, --[3] Things
	}
end

return objects