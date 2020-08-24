local function trigger(self)
	local dat = self.examable.dat
	local dat_len = #dat
	
	local count = game.examine(self,dat_len)
	di_box.show(dat[count])
end

local function attach(object, dat)
	object.examable = {
		dat = dat
	}

	object.interact = trigger
end

return attach