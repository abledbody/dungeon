	--Constants--
local CLASSPATH = PATH.."Items/"

	--Module--
items = {
	Item = dofile(CLASSPATH.."Item.lua"),
}

items.types = {
	Flask = dofile(CLASSPATH.."Flask.lua"),
}

return items