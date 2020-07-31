local RobeStat = class("RobeStat", things.Thing)

local exam_dat = {
	"It's a statue of a robed figure.",
	"I don't recognize the face.",
	"It could be a saint.",
	"It's probably not a saint.",
	"It's very ominous.",
	"I don't really want to\nlook at it anymore.",
	"It's a statue of a robed figure."
}

function RobeStat:initialize(x, y)
	gMap.bulk(self, x, y + 1, 2, 2, gMap.setSquare)
	
	components.examable(self, exam_dat)
	
	dat = self.dat
	
	things.Thing.initialize(self, x, y)
end

function RobeStat:draw()
	local x,y = self.x,self.y

	SpriteGroup(97,x*8,y*8,2,3)
end

function RobeStat:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8+4
	y = y*8-5+things.indicatorY
	
	Sprite(361,x,y)
end

return RobeStat