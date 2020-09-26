local PATH = "D:/dungeon/"

cursor("normal")
dofile(PATH .. "Rayleigh.lua")

local mdat = dofile(PATH .. "mdat.lua")
dofile(PATH .. "roomedit_dat.lua")

local MapObj = require("Libraries.map")
local Map = MapObj(144, 128)

local floor = math.floor

local function get_sheet(file)
	local start = file:find("LK12;GPUIMG;")
    local stop = file:find("___sfx___") or file:len()

    local ss_data = file:sub(start, stop)

    return GPU.imagedata(ss_data)
end

local function get_tilemap(file)
	local start = file:find("LK12;TILEMAP;")
    local stop = file:find("___spritesheet___")

    local tm_data = file:sub(start, stop)

    Map:import(tm_data)
end

local dungeon = HDD.read(PATH .. "dungeon.lk12")
local roomedit_sheet_file = HDD.read(PATH .. "roomedit_sheet.lk12")

local spr_sheets = {
	get_sheet(dungeon):image(),
	get_sheet(roomedit_sheet_file):image(),
}
get_tilemap(dungeon)

--------------------------------------

local SW, SH = screenSize()
local HSW, HSH = SW / 2, SH / 2
local FONT_WIDTH = fontWidth() + 1
local FONT_HEIGHT = fontHeight()
local TOOLBAR_WIDTH = 10

local view_x, view_y = HSW, HSH
local view_scale = 1
local dragging = false
local show_room_data = false
local show_reveal_bounds = true
local show_objects = true
local selected_room = nil
local selected_index = 1
local selected_rect = nil
local selected_object_name = nil


local selected_tool = 1
local toolbar = {
	{
		sprite = 2,
	},
	{
		sprite = 4,
		on_selected = function()
			show_objects = false
		end,
		on_deselected = function()
			show_objects = true
		end,
	},
}

local toggles = {
	{
		sprite = 5,
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			show_room_data, self.enabled = value, value
		end,
	},
	{
		sprite = 6,
		enabled = true,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			show_reveal_bounds, self.enabled = value, value
		end,
	},
}

f = {}

function f.Sprite(id, x, y, sheet_index)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, 8, 8, 192, 128)
    spr_sheets[sheet_index or 1]:draw(x, y, 0, 1, 1, q)
end

function f.SpriteGroup(id, w, h, x, y, sheet_index)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, w * 8, h * 8, 192, 128)
    spr_sheets[sheet_index or 1]:draw(x, y, 0, 1, 1, q)
end

local function tile_draw(x, y, id)
    if id > 0 then
        f.Sprite(id, x * 8, y * 8)
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
	selected_object_name = nil

	for room_name, room in pairs(mdat.rooms) do
		if in_room(room, x, y) then
			--We're going to assume that we've just selected the room
			selected_room = room
			selected_object_name = nil
			selected_rect = {x = room.x * 8, y = room.y * 8, w = room.w * 8, h = room.h * 8}
			selected_object_name = room_name

			--And then we'll check to see if we've actually selected an object, and replace the selection data with that if we have.
			if show_objects then
				for object_index, object in pairs(room.objects) do
					if data.test_occupancy(object[1], x, y, object[2] + room.x, object[3] + room.y) then
						selected_index = object_index
						selected_object_name = object[1]
						local rect_x, rect_y, rect_w, rect_h = data.get_object_bounds(selected_object_name, (object[2] + room.x) * 8, (object[3] + room.y) * 8)
						selected_rect = {x = rect_x, y = rect_y, w = rect_w, h = rect_h}
						break
					end
				end
			end
			break
		end
	end
end

local function select_tool(index)
	local tool = toolbar[selected_tool]
	if tool.on_deselected then
		tool.on_deselected()
	end
	
	selected_tool = index
	
	tool = toolbar[selected_tool]
	if tool.on_selected then
		tool.on_selected()
	end
end

local function press_tool(x)
	if x >= 0 and x < #toolbar * 10 then
		select_tool(floor(x / 10) + 1)
	elseif x < SW and x > SW - #toggles * 10 then
		local toggle_index = floor((SW - x) / 10) + 1
		local toggle = toggles[toggle_index]
		toggle:on_pressed()
	end
end

------LOVE events------

local function _mousepressed(x, y, button)
    if button == 2 then
        dragging = true
        cursor("hand")
    end
	if button == 1 then
		if y >= SH - TOOLBAR_WIDTH then
			press_tool(x)
		else
			local square_x, square_y = find_mouse(x, y)
			press_square(floor(square_x / 8), floor(square_y / 8))
		end
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

local keypress_actions = {
	lalt = function() toggles[1]:set_enabled(true) end,
	["1"] = function() select_tool(1) end,
	["2"] = function() select_tool(2) end,
}

local function _keypressed(key)
	if keypress_actions[key] then
		keypress_actions[key]()
	end
end

local function _keyreleased(key)
	if key == "lalt" then
		toggles[1]:set_enabled(false)
	end
end

------Main loops------

local function _update(dt)

end

local function _draw()
	clear()

	local inv_scale = 1 / view_scale

	--Camera transformations--
	pushMatrix()
	cam("translate", HSW, HSH)
	cam("scale", view_scale, view_scale)
    cam("translate", -floor(view_x * view_scale) * inv_scale, -floor(view_y * view_scale) * inv_scale)

	--Border--
	color(7)
	rect(-inv_scale, -inv_scale, 1152 + inv_scale * 2, inv_scale)
	rect(-inv_scale, -inv_scale, inv_scale, 1024 + inv_scale * 2)
	rect(-inv_scale, 1025, 1152 + inv_scale * 2, inv_scale)
	rect(1153, -inv_scale, inv_scale, 1024 + inv_scale * 2)

	--Tilemap--
    draw_tilemap()

	--Rooms--
	for room_name, room in pairs(mdat.rooms) do
		local room_px, room_py = room.x * 8, room.y * 8
		local room_pw, room_ph = room.w * 8, room.h * 8
		local room_prx, room_pry = room.rx * 8, room.ry * 8
		local room_prw, room_prh = room.rw * 8, room.rh * 8

		if show_objects then
			for _, object in pairs(room.objects) do
				data.draw_object(object[1], object[2] + room.x, object[3] + room.y)
			end
		end

		if show_room_data then
			if show_reveal_bounds then
				color(11)
				rect(room_prx, room_pry, room_prw, room_prh, true)
			end
			
			color(8)
			rect(room_px, room_py, room_pw, room_ph, true)
			
			color(0)
			rect(room_px + 1, room_py + 1, room_name:len() * FONT_WIDTH, FONT_HEIGHT)
			color(7)
			print(room_name, room_px + 1, room_py + 1)
		end
	end
	
	if selected_rect then
		color(7)
		rect(selected_rect.x - 1, selected_rect.y - 1, selected_rect.w + 2, selected_rect.h + 2, true)
	end

    popMatrix()

	if selected_object_name then
		local str_len = selected_object_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, 0, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(selected_object_name, HSW - str_len * FONT_WIDTH/2, 1)
	end

	--Toolbar--
	color(2)
	local toolbar_y = SH - TOOLBAR_WIDTH
	rect(0, toolbar_y, SW, TOOLBAR_WIDTH)

	for i = 1, #toolbar do
		local tool = toolbar[i]

		local x = (i - 1) * 10
		if selected_tool == i then
			pal(2, 15)
			pal(15, 2)
			rect(x, toolbar_y, 10, 10)
		end
		f.Sprite(tool.sprite, x + 1, toolbar_y + 1, 2)
		pal()
	end

	for i = 1, #toggles do
		local toggle = toggles[i]

		local x = SW - 10 - (i - 1) * 10
		if toggle.enabled then
			pal(2, 15)
			pal(15, 2)
			rect(x, toolbar_y, 10, 10)
		end
		f.Sprite(toggle.sprite, x + 1, toolbar_y + 1, 2)
		pal()
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
