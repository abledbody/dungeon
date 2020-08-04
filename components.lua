local COMPONENT_PATH = PATH.."Components/"

local components = {
	melee =			dofile(COMPONENT_PATH.."melee.lua"),
	health =		dofile(COMPONENT_PATH.."health.lua"),
	examable =		dofile(COMPONENT_PATH.."examable.lua"),
	searchable =	dofile(COMPONENT_PATH.."searchable.lua"),
}

return components