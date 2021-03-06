local COMPONENT_PATH = PATH.."Components/"

components = {
	melee =			dofile(COMPONENT_PATH.."melee.lua"),
	health =		dofile(COMPONENT_PATH.."health.lua"),
	examable =		dofile(COMPONENT_PATH.."examable.lua"),
	searchable =	dofile(COMPONENT_PATH.."searchable.lua"),
	bag_dropper =	dofile(COMPONENT_PATH.."bag_dropper.lua"),
	thrower =		dofile(COMPONENT_PATH.."thrower.lua"),
}