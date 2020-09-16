local PATH = "D:/dungeon/"

cursor("normal",true)

local mdat = dofile("D:/dungeon/mdat.lua")

local MapObj = require("Libraries.map")
local Map = MapObj(144,128)

local floor = math.floor

local dungeon = HDD.read(PATH.."dungeon.lk12")
local spr_sheet
local tile_map

do
 local start =
  dungeon:find("LK12;GPUIMG;")
 local stop =
  dungeon:find("___sfx___")
 
 local ss_data = dungeon:sub(start, stop)

 spr_sheet = GPU.imagedata(ss_data)
end

spr_sheet = spr_sheet:image()

do
 local start =
  dungeon:find("LK12;TILEMAP;")
 local stop =
  dungeon:find("___spritesheet___")
 
 local tm_data = dungeon:sub(start, stop)

 Map:import(tm_data)
end

--------------------------------------

local view_x,view_y = 0,0
local dragging = false


local function Sprite(id, x, y)
 id = id-1
 local quad_x = floor(id) % 24 * 8
 local quad_y = floor(id / 24) * 8
 local q = GPU.quad(quad_x,quad_y,8,8,192,128)
 spr_sheet:draw(x,y,0,1,1,q)
end

local function tile_draw(x,y,id)
 if id > 0 then
  Sprite(id,x*8,y*8)
 end
end

local function draw_tilemap()
 Map:map(tile_draw)
end

local function press_square(x,y)
 Sprite(193,x*8,y*8)
 sleep(0.2)
end

local function _mousepressed(x,y,button)
 if button == 2 then
  dragging = true
  cursor("hand",true)
 end
 if button == 1 then
  press_square(
   floor((view_x + x)/8),
   floor((view_y + y)/8))
 end
end

local function _mousereleased(x,y,button)
 if button == 2 then
  dragging = false
  cursor("normal",true)
 end
end

local function _mousemoved(x,y,dx,dy)
 if dragging then
  view_x = view_x + dx
  view_y = view_y + dy
 end
end                        

local function _update(dt)

end

local function _draw()
 clear()
 
 pushMatrix()
 cam("translate",view_x,view_y)
 
 draw_tilemap()
 
 popMatrix()
end

while true do
 local event,a,b,c,d = pullEvent()
 local test = "_"..event
 
 if event == "keypressed" and a == "escape" then  
  break
 end
 
 if event == "update" then
  _update(a)
  _draw()
 end
 
 if event == "mousepressed" then
  _mousepressed(a,b,c,d)
 end
 if event == "mousereleased" then
  _mousereleased(a,b,c,d)
 end
 if event == "mousemoved" then
  _mousemoved(a,b,c,d)
 end      
end