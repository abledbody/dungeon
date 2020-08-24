	--Localization--
local abs = math.abs
local sign = math.sign

local function update(self)
	local ai = self.ai
	local maxDist,target = ai.maxDist,ai.target
	local x,y = self.x,self.y
	local targetDist
	

	--Targeting--
	if not target then
		local pl = game.player
		targetDist = game_map.dist(x,y,pl.x,pl.y)
		
		if targetDist <= maxDist then
			ai.target = pl
		end
	end
	

	if target then
		local xTarget,yTarget = target.x,target.y
		local xDelta,yDelta = xTarget-x,yTarget-y

		local xSign,ySign = sign(xDelta),sign(yDelta)

		local xDir,yDir =
			xSign > 0 and 2 or 1,
			ySign > 0 and 4 or 3
		
		local yGreater = abs(yDelta) >= abs(xDelta)

		targetDist = targetDist or game_map.dist(x,y,xTarget,yTarget)

		--Chasing--
		if targetDist > 1 then
			
			
			if yGreater then
				local _ = self:move(yDir) or (xSign == 0 or self:move(xDir))
			else
				local _ = self:move(xDir) or (ySign == 0 or self:move(yDir))
			end
		else --Attacking--
			if yGreater then
				self:melee_attack(yDir)
			else
				self:melee_attack(xDir)
			end
		end
	end
end

local function attach(object)
	object.ai = {
		maxDist = 10,
		target = nil,
	}

	table.insert(object.updates, update)
end

return attach