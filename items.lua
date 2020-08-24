	--Constants--
local ITEMPATH = PATH.."Items/"

	--Module--
items = {
	item_base = dofile(ITEMPATH.."item.lua"),
}

items.types = {
	health_flask = dofile(ITEMPATH.."health_flask.lua"),
	speed_flask = dofile(ITEMPATH.."speed_flask.lua"),
	water_flask = dofile(ITEMPATH.."water_flask.lua"),
}

return items