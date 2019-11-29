local ExTile = class("ExTile")

function ExTile:initialize(x,y,dat)
	gMap.setSquare(x,y,"interactable",self)
	
	local examable = things.Examable:new()
	examable.dat = dat
	
	self.x,self.y,self.examable = x,y,examable
	table.insert(things.all,self)
end

function ExTile:draw()
end

function ExTile:drawIndicator()
	local x,y = self.x,self.y
	
	x = x*8
	y = y*8-5+things.indicatorY()
	
	Sprite(361,x,y)
end

function ExTile:interact()
	self.examable:trigger()
end

return ExTile