	--Constants--
local CLASSPATH = PATH.."MapEntities/"

	--Module--
local mapEnts = {}

mapEnts.Health = dofile(CLASSPATH.."Health.lua")
mapEnts.Movable = dofile(CLASSPATH.."Movable.lua")

return mapEnts