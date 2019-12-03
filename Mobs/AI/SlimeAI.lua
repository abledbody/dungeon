	--Localization--
local abs = math.abs
local sign = math.sign

	--Class
local SlimeAI = class("SlimeAI")

SlimeAI.maxDist = 10

function SlimeAI:initialize()

end

function SlimeAI:update()
	local mob,maxDist,target = self.mob,self.maxDist,self.target
	local x,y = mob.x,mob.y
	local targetDist
	

	--Targeting--
	if not target then
		local pl = game.pl()
		targetDist = gMap.dist(x,y,pl.x,pl.y)
		
		if targetDist <= maxDist then
			self.target = pl
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

		targetDist = targetDist or gMap.dist(x,y,xTarget,yTarget)

		--Chasing--
		if targetDist > 1 then
			
			
			if yGreater then
				local _ = mob:move(yDir) or (xSign == 0 or mob:move(xDir))
			else
				local _ = mob:move(xDir) or (ySign == 0 or mob:move(yDir))
			end
		else --Attacking--
			if yGreater then
				mob:attack(yDir)
			else
				mob:attack(xDir)
			end
		end
	end
end

return SlimeAI