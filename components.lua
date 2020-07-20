local COMPONENT_PATH = PATH.."Components/"

local components = {
	melee =		dofile(COMPONENT_PATH.."melee.lua"),
	health =	dofile(COMPONENT_PATH.."health.lua")
}

return components