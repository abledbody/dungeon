local PATH = "D:/dungeon/"

cursor("normal")

local mdat = dofile("D:/dungeon/mdat.lua")

local MapObj = require("Libraries.map")
local Map = MapObj(144, 128)

local floor = math.floor

local dungeon = HDD.read(PATH .. "dungeon.lk12")
local spr_sheet
local tile_map

do
    local start = dungeon:find("LK12;GPUIMG;")
    local stop = dungeon:find("___sfx___")

    local ss_data = dungeon:sub(start, stop)

    spr_sheet = GPU.imagedata(ss_data)
end

spr_sheet = spr_sheet:image()

do
    local start = dungeon:find("LK12;TILEMAP;")
    local stop = dungeon:find("___spritesheet___")

    local tm_data = dungeon:sub(start, stop)

    Map:import(tm_data)
end

--------------------------------------

local HSW, HSH = screenWidth() / 2, screenHeight() /2

local view_x, view_y = HSW, HSH
local view_scale = 1
local dragging = false

local function Sprite(id, x, y)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, 8, 8, 192, 128)
    spr_sheet:draw(x, y, 0, 1, 1, q)
end

local function tile_draw(x, y, id)
    if id > 0 then
        Sprite(id, x * 8, y * 8)
    end
end

local function draw_tilemap()
    Map:map(tile_draw)
end

local function press_square(x, y)
    Sprite(193, x * 8, y * 8)
    sleep(0.2)
end

local function _mousepressed(x, y, button)
    if button == 2 then
        dragging = true
        cursor("hand")
    end
    if button == 1 then
        press_square(floor((view_x + x) / 8), floor((view_y + y) / 8))
    end
end

local function _mousereleased(x, y, button)
    if button == 2 then
        dragging = false
        cursor("normal")
    end
end

local function _mousemoved(x, y, dx, dy)
    if dragging then
        view_x = view_x - dx / view_scale
		view_y = view_y - dy / view_scale
		
		view_x = math.min(math.max(view_x, 0), 1152)
		view_y = math.min(math.max(view_y, 0), 1024)
    end
end

local function _wheelmoved(_, delta)
	if delta > 0 then
		view_scale = 1
	end
	if delta < 0 then
		view_scale = 0.25
	end
end

local function _update(dt)

end

local function _draw()
	clear()

	pushMatrix()
	cam("translate", HSW, HSH)
	cam("scale", view_scale, view_scale)
    cam("translate", floor(-view_x * view_scale) / view_scale, floor(-view_y * view_scale) / view_scale)

	--Border
	color(7)
	local inv_scale = 1 / view_scale
	rect(-inv_scale, -inv_scale, 1152 + inv_scale * 2, inv_scale)
	rect(-inv_scale, -inv_scale, inv_scale, 1024 + inv_scale * 2)
	rect(-inv_scale, 1025, 1152 + inv_scale * 2, inv_scale)
	rect(1153, -inv_scale, inv_scale, 1024 + inv_scale * 2)

    draw_tilemap()

    popMatrix()
end

local events = {
    update = function(a, b, c, d, e)
        _update(a)
        _draw()
    end,
    mousepressed = _mousepressed,
    mousereleased = _mousereleased,
	mousemoved = _mousemoved,
	wheelmoved = _wheelmoved,
}

while true do
    local event, a, b, c, d, e = pullEvent()

    if event == "keypressed" and a == "escape" then
        break
    end
    if events[event] then
        events[event](a, b, c, d, e)
    end
end
