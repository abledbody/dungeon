	--Constants--
local CLASSPATH = PATH.."MapEntities/"

	--Module--
local mapEnts = {}

mapEnts.Health = dofile(CLASSPATH.."Health.lua")
mapEnts.Movable = dofile(CLASSPATH.."Movable.lua")
mapEnts.Melee = dofile(CLASSPATH.."Melee.lua")

return mapEnts