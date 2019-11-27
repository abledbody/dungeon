	--Localization--
local DIRX,DIRY = const.DIRX,const.DIRY

	--Class--
local Mob = class("Mob")

function Mob:initialize(x,y,aSet)
	self.x,self.y = x,y
	self.sx,self.sy = x*8,y*8
	self.smooveRate = 0.06
	self.t_move = game.Timer:new(0.22)
	self.t_attack = game.Timer:new(0.4)
	
	self.movable = mapEnts.Movable:new(self)

	local function attackEndWrapper() Mob.attackAnimEnd(self) end
	self.animator = game.Animator:new(aSet,"idle",{attack = attackEndWrapper})
	
	table.insert(mobs.all,self)
end

function Mob:attackAnimEnd()
	self.animator:setState("idle")
end

function Mob:update(dt)
	local animator,x,y,sx,sy,t_move,t_attack,smooveRate = self.animator,self.x,self.y,self.sx,self.sy,self.t_move,self.t_attack,self.smooveRate
	
	--Animation--
	animator:update(dt)
	
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
	local movable,t_move = self.movable,self.t_move
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	local couldMove = false

	if t_move:check() then
		couldMove = movable:move(xM,yM)

		if couldMove then
			SFX(7)
			t_move:trigger()
		end
		
		self:flipCheck(xM)
	end

	return couldMove
end

function Mob:attack(dir)
	local x,y,t_attack = self.x,self.y,self.t_attack
	
	local xM,yM = DIRX[dir],DIRY[dir]
	
	if t_attack:check() then
		x,y = x+xM,y+yM
		
		self.animator:setState("attack")
		
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
	local animator,x,y,flip = self.animator,self.sx,self.sy,self.flip

	local xScale = flip and -1 or 1

	local spr = animator:fetch("spr")
	local offX = animator:fetch("offX")
	if offX then
		--Apply to sprite x offset.
		x = x+offX*xScale
	end
	
	--If the sprite is flipped, we need to account for the fact that the origin is on the upper left corner.
	x = flip and x+8 or x
	
	Sprite(spr,x,y,0,xScale)
end

return Mob