--Variables--
local all = {}
local types = {}

--Functions--
local function doAll(method,...)
	for i = 1, #all do
		local mob = all[i]
		mob[method](mob,...)
	end
end

--Mob class--
local Mob = dofile("D:/dungeon/Classes/Mob.lua")

--MOVEME--
local Slime = class("Slime")

function Slime:initialize(x,y)
	local mob = Mob:new(x,y,aData.slime)
	
	mob.x,mob.y = x,y
	
	self.mob = mob
end

types.Slime = Slime

--Module--
local mobs = {}

mobs.Mob = Mob
mobs.all = all
mobs.doAll = doAll
mobs.types = types

return mobs