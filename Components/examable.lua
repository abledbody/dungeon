local function trigger(self)
	local dat = self.examable.dat
	local datLen = #dat
	
	local count = game.examine(self,datLen)
	diBox.show(dat[count])
end

local function attach(object, dat)
	object.examable = {
		dat = dat
	}

	object.interact = trigger
end

return attach