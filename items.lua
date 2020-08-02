	--Constants--
local ITEMPATH = PATH.."Items/"

	--Module--
items = {
	item_base = dofile(ITEMPATH.."item.lua"),
}

items.types = {
	flask = dofile(ITEMPATH.."flask.lua"),
}

return items