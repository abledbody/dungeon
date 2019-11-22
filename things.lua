local Examable = dofile("D:/dungeon/Classes/Examable.lua")

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

--Classes--

local ExTile = class("ExTile")

function ExTile:initialize(x,y,dat)
	gMap.addIact(self,x,y)
	
	local examable = Examable:new()
	examable.dat = dat
	
	self.x,self.y,self.examable = x,y,examable
	table.insert(all,self)
end

function ExTile:draw()
end

function ExTile:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8
	y = y*8-5+indicatorY
	
	Sprite(361,x,y)
end

function ExTile:interact()
	self.examable:trigger()
end

types.ExTile = ExTile

--====--

local RobeStat = class("RobeStat")

RobeStat.dat = {
	"It's a statue of a robed figure.",
	"I don't recognize the face.",
	"It could be a saint.",
	"It's probably not a saint.",
	"It's very ominous.",
	"I don't really want to\nlook at it anymore.",
	"It's a statue of a robed figure."
}

function RobeStat:initialize(x,y)
	for i = x, x+1 do
		for j = y+1, y+2 do
			gMap.block(i,j)
			gMap.addIact(self,i,j)
		end
	end
	
	local examable = Examable:new()
	
	examable.dat = self.dat
	
	self.x,self.y,self.examable = x,y,examable
	table.insert(all,self)
end

function RobeStat:draw()
	local x,y = self.x,self.y

	SpriteGroup(97,x*8,y*8,2,3)
end

function RobeStat:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8+4
	y = y*8-5+indicatorY
	
	Sprite(361,x,y)
end

function RobeStat:interact()
	self.examable:trigger()
end

types.RobeStat = RobeStat

--Module--
local things = {}

things.RobeStat = RobeStat
things.types = types
things.doAll = doAll

return things