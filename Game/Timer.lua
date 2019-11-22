local Timer = class("Timer")

function Timer:initialize(l)
	self.length = l
	self.timer = 0
	self.flag = true
end

function Timer:trigger(l)
	local timer,len = self.timer,self.length
	if l then
		self.length = l
	end
	
	--Just in case this timer gets triggered multiple times in a single frame.
	if timer <= 0 then
		self.timer = timer+len
	else
		self.timer = len
	end

	self.flag = false
end

function Timer:update(dt)
	local timer = self.timer
	
	if timer > 0 then
		timer = timer-dt
	end
	
	self.flag = timer <= 0
	
	self.timer = timer
end

function Timer:check()
	return self.flag
end

return Timer