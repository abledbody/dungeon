local sheetImage = SpriteMap:image()
local bg = sheetImage:batch()



local function checkBit(flag,n)
 n = n-1
 n = (n==0) and 1 or (2^n)
 return bit.band(flag,n) == n
end     

local function reveal(x,y,w,h)
 TileMap:map(function(x,y,spr)
  if spr ~= 0 then
   local q = SpriteMap:quad(spr)
   bg:add(q,x*8,y*8)
  end
 end,x,y,w,h)
end

local function draw()
 bg:draw()
end

local function collide(x,y)
 local tile = bg:cell(x,y)
 local flags = fget(tile)
 return not checkBit(flags,1)
end

gMap = {}
gMap.reveal = reveal
gMap.draw = draw