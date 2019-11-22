--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY

--Class--

local Mob = class("Mob")

function Mob:initialize(x,y,aSet)
	self.x,self.y = x,y
	self.sx,self.sy = x*8,y*8
	self.anim_i = 1
	self.anim_o = 0 
	self.states = aSet
	self:setState("idle")
	self.t_move = game.Timer:new(0.22)
	self.t_attack = game.Timer:new(0.4)
	self.smooveRate = 0.06
	
	table.insert(mobs.all,self)
end

function Mob:setState(state)
	self.anim_state = state
	local a = self.states[state]
	if not a then
		error("No such animation state "..state)
	end
	
	self.anim_o = a.timing[1]
	self.a,self.anim_i = a,1
end

function Mob:update(dt)
	local anim_i,anim_o,a,x,y,sx,sy,t_move,t_attack,anim_state,smooveRate = self.anim_i,self.anim_o,self.a,self.x,self.y,self.sx,self.sy,self.t_move,self.t_attack,self.anim_state,self.smooveRate
	
	--Animation--
	anim_i,anim_o,aEnd =
		anim.fetch(anim_i,anim_o,a.timing)
	anim_o = anim_o-dt
	
	self.anim_i,self.anim_o = anim_i,anim_o
	
	if aEnd and anim_state == "attack" then
		self:setState("idle")
	end
	
	--Other--
	sx,sy = game.smoove(sx,sy,x*8,y*8,smooveRate/dt)
	
	t_move:update(dt)
	t_attack:update(dt)
	
	self.sx,self.sy = sx,sy
end

function Mob:flipCheck(xM)
	if xM ~= 0 then
		self.flip = xM < 0
	end
end

function Mob:move(dir)
	local x,y,t_move = self.x,self.y,self.t_move
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	if t_move:check() then
		--Even if x and y are never modified, we still need the position for the block check.
		--If it passes, then we'll delocalize it.
		x,y = x+xM,y+yM
		
		if not gMap.isBlocked(x,y) then
			t_move:trigger()
			self.x,self.y = x,y
			SFX(7)
			if self.onMove then
				self:onMove()
			end
		end
		
		self:flipCheck(xM)
	end
end

function Mob:attack(dir)
	local x,y,t_attack = self.x,self.y,self.t_attack
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	if t_attack:check() then
		x,y = x+xM,y+yM
		
		self:setState("attack")
		
		if gMap.isBlocked(x,y) then
			SFX(6)
		else
			SFX(0)
		end
		
		self:flipCheck(xM)  
		
		t_attack:trigger()                
	end
end

function Mob:interact(dir)
	local x,y = self.x,self.y
	
	local xM,yM = DIRX[dir],DIRY[dir]
	x,y = x+xM,y+yM
	
	self:flipCheck(xM)
	
	local iact = gMap.isIact(x,y)
	
	if iact then
		iact:interact(self)
	end
end

function Mob:draw()
	local a,anim_i,sx,sy,f = self.a,self.anim_i,self.sx,self.sy,self.flip
	local spr = a.spr[anim_i]
	
	local sxScale = f and -1 or 1
	
	--Checking to see if our animation data has a sprite x offset.
	if a.offX then
		local offX = a.offX[anim_i]
		--Apply to sprite x offset.
		sx = sx+offX*sxScale
	end   
	
	--If the sprite is flipped, we need to account for the fact that the origin is on the upper left corner.
	sx = f and sx+8 or sx
	
	Sprite(spr,sx,sy,0,sxScale)
end

return Mob