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
	
	local examable = things.Examable:new()
	
	examable.dat = self.dat
	
	self.x,self.y,self.examable = x,y,examable
	table.insert(things.all,self)
end

function RobeStat:draw()
	local x,y = self.x,self.y

	SpriteGroup(97,x*8,y*8,2,3)
end

function RobeStat:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8+4
	y = y*8-5+things.indicatorY()
	
	Sprite(361,x,y)
end

function RobeStat:interact()
	self.examable:trigger()
end

return RobeStat