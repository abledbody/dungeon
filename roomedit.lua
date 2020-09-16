local PATH = "D:/dungeon/"

cursor("normal")

local mdat = dofile("D:/dungeon/mdat.lua")

local MapObj = require("Libraries.map")
local Map = MapObj(144, 128)

local floor = math.floor

local dungeon = HDD.read(PATH .. "dungeon.lk12")
local spr_sheet

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
local show_room_data = false
local selected = nil
local selected_rect = nil
local selected_name = nil

local function Sprite(id, x, y)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, 8, 8, 192, 128)
    spr_sheet:draw(x, y, 0, 1, 1, q)
end

local function SpriteGroup(id, w, h, x, y)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, w * 8, h * 8, 192, 128)
    spr_sheet:draw(x, y, 0, 1, 1, q)
end

local sprite_lookup = {
	Slime = function(x, y) Sprite(202, x * 8, y * 8) end,
	RobeStat = function(x, y) SpriteGroup(97, 2, 3, x * 8, y * 8) end,
	Chest = function(x, y) palt(0, false) palt(1, true) Sprite(169, x * 8, y * 8) palt() end,
	Barrel = function(x, y) Sprite(123, x * 8, y * 8) end,
}

local function tile_draw(x, y, id)
    if id > 0 then
        Sprite(id, x * 8, y * 8)
    end
end

local function draw_tilemap()
    Map:map(tile_draw)
end

local function in_room(room, x, y)
	return x >= room.x and y >= room.y and x < room.x + room.w and y < room.y + room.h
end

local function find_mouse(x, y)
	return (x - HSW) / view_scale + view_x, (y - HSH) / view_scale + view_y
end

local function press_square(x, y)
	selected = nil
	selected_rect = nil
	selected_name = nil

	for room_name, room in pairs(mdat.rooms) do
		if in_room(room, x, y) then
			selected = room
			selected_rect = {x = room.x * 8, y = room.y * 8, w = room.w * 8, h = room.h * 8}
			selected_name = room_name
			for _, mob in pairs(room.mobs) do
				if x == mob[2] + room.x and y == mob[3] + room.y then
					selected = mob
					selected_rect = {x = (mob[2] + room.x) * 8, y = (mob[3] + room.y) * 8, w = 8, h = 8}
					selected_name = mob[1]
					break
				end
			end
			for _, thing in pairs(room.things) do
				if x == thing[2] + room.x and y == thing[3] + room.y then
					selected = thing
					selected_rect = {x = (thing[2] + room.x) * 8, y = (thing[3] + room.y) * 8, w = 8, h = 8}
					selected_name = thing[1]
					break
				end
			end
			break
		end
	end
end

------LOVE events------

local function _mousepressed(x, y, button)
    if button == 2 then
        dragging = true
        cursor("hand")
    end
	if button == 1 then
		local square_x, square_y = find_mouse(x, y)
        press_square(floor(square_x / 8), floor(square_y / 8))
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

local function _keypressed(key)
	if key == "lalt" then
		show_room_data = true
	end
end

local function _keyreleased(key)
	if key == "lalt" then
		show_room_data = false
	end
end

------Main loops------

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

	for room_name, room in pairs(mdat.rooms) do
		local room_px, room_py = room.x * 8, room.y * 8
		local room_pw, room_ph = room.w * 8, room.h * 8
		local room_prx, room_pry = room.rx * 8, room.ry * 8
		local room_prw, room_prh = room.rw * 8, room.rh * 8

		if show_room_data then
			color(11)
			rect(room_prx, room_pry, room_prw, room_prh, true)
			color(8)
			rect(room_px, room_py, room_pw, room_ph, true)
			
			color(0)
			rect(room_px + 1, room_py + 1, room_name:len() * 5, 7)
			color(7)
			print(room_name, room_px + 1, room_py + 1)
		end

		for _, mob in pairs(room.mobs) do
			if sprite_lookup[mob[1]] then
				sprite_lookup[mob[1]](room.x + mob[2], room.y + mob[3])
			else
				Sprite(384, (room.x + mob[2]) * 8, (room.y + mob[3]) * 8)
			end
		end
		for _, thing in pairs(room.things) do
			if sprite_lookup[thing[1]] then
				sprite_lookup[thing[1]](room.x + thing[2], room.y + thing[3])
			else
				Sprite(384, (room.x + thing[2]) * 8, (room.y + thing[3]) * 8)
			end
		end
	end
	
	if selected_rect then
		color(7)
		rect(selected_rect.x - 1, selected_rect.y - 1, selected_rect.w + 2, selected_rect.h + 2, true)
	end

    popMatrix()

	if selected_name then
		local str_len = selected_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, 0, str_len * 5 + 1, 8)
		color(7)
		print(selected_name, HSW - str_len * 2.5, 1)
	end
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
	keypressed = _keypressed,
	keyreleased = _keyreleased,
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
