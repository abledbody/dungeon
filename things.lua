	--Constants--
local CLASSPATH = PATH.."Things/"

	--Variables--
local all = {}
local types = {}

--Interaction indicator vertical position
local indicatorY = 0

	--Functions--
local function doAll(method,...)
	for i = 1, #all do
		all[i][method](all[i],...)
	end
end

local function indicatorY_prop(x)
	indicatorY = x or indicatorY
	return indicatorY
end

	--Classes--
local Examable = dofile(CLASSPATH.."Examable.lua")

types.RobeStat = dofile(CLASSPATH.."RobeStat.lua")
types.ExTile = dofile(CLASSPATH.."ExTile.lua")

	--Module--
local things = {}

things.types = types
things.all = all
things.doAll = doAll
things.Examable = Examable
things.indicatorY = indicatorY_prop

return things