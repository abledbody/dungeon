local Animator = class("Animator")

function Animator:initialize(animSet, initialState, endCalls)
	self.animSet = animSet or error("Animator:new requires a set of animations to operate")
	self.endCalls = endCalls or {}
	self:setState(initialState or error("Animator:new requires an initial state to operate"))
end

function Animator:update(dt)
	local timing, frame = self.anim.timing, self.frame
	local fCount = #timing
	
	--Offset is measured in "Seconds before the next frame"
	local offset = self.offset-dt
	local ended = false
	
	--If offset is ever negative, we'll know we just passed the next frame.
	while offset <= 0 do
		if frame == fCount then
			ended = true
			frame = 1
		else
			frame = frame+1
		end
		
		--If we add the time it takes to get to the next frame to offset and it's still negative, we'll know we skipped multiple frames.
		offset = offset+timing[frame]
	end
	
	self.offset, self.frame = offset, frame

	if ended then
		local call = self.endCalls[self.state]
		if call then call() end
	end
end

function Animator:setState(state)
	self.state = state
	local anim = self.animSet[state] or error("No such animation state "..state)

	self.offset = anim.timing[1]
	self.frame = 1
	self.anim = anim
end

function Animator:check()
	return self.frame
end

function Animator:fetch(key)
	local anim,frame = self.anim, self.frame

	local set = anim[key]
	if set then
		return anim[key][frame]
	end
end

return Animator