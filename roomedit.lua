local PATH = "D:/dungeon/"
local ROOMEDIT_PATH = PATH.."roomedit/"

cursor("normal")
dofile(PATH .. "Rayleigh.lua")

local mdat = dofile(PATH .. "mdat.lua")
dofile(ROOMEDIT_PATH .. "roomedit_dat.lua")

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
local roomedit_sheet_file = HDD.read(ROOMEDIT_PATH .. "roomedit_sheet.lk12")

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
local ROOM_HANDLE_PAD = -1
local ROOM_HANDLE_SIZE = 5

local view_x, view_y = HSW, HSH
local view_scale = 1

local dragging = false
local ctrl_pressed = false

local room_handle_grabbed = false

local show_room_data = false
local show_reveal_bounds = false
local objects_selectable = true

local selected_room = nil
local selected_index = nil
local selected_rect = nil
local selected_room_name = nil
local selected_object_name = nil


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
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			show_reveal_bounds, self.enabled = value, value
		end,
	},
}

local selected_tool = 1
local toolbar = {
	{
		sprite = 2,
	},
	{
		sprite = 4,
		on_selected = function()
			objects_selectable = false
			toggles[1]:set_enabled(true)
		end,
		on_deselected = function()
			objects_selectable = true
			toggles[1]:set_enabled(false)
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

local function binary_search(tab, value)
	if #tab > 0 then
		local ret_tab = {}
		local i_start, i_stop = 1, #tab
		while true do
			local check = floor((i_stop - i_start) / 2 + i_start)
			local pointer = tab[check]
			
			if pointer[1] == value then
				local first_check = check
				while true do
					if pointer[1] == value then
						table.insert(ret_tab, pointer)
						check = check - 1
						pointer = tab[check]
					else
						break
					end
				end
				check = first_check + 1
				pointer = tab[check]
				while true do
					if pointer[1] == value then
						table.insert(ret_tab, pointer)
						check = check + 1
						pointer = tab[check]
					else
						return ret_tab
					end
				end
			elseif pointer[1] > value then
				i_stop = check - 1
			elseif pointer[1] < value then
				i_start = check + 1
			end
			if i_start > i_stop then
				return ret_tab
			end
		end
	else
		return {}
	end
end

local function write_table(str, tab)
	str = str.."{"
		for _, v in pairs(tab) do
			if type(v) == "table" then
				str = write_table(str, v)
			elseif type(v) == "string" then
				local new_string = v:gsub("\n", "\\n")
				str = str.."\""..new_string.."\", "
				
			else
				str = str..v..", "
			end
		end
	str = str.."}"
	return str
end

local function export(path)
	local compiled = "local mdat = {}\nlocal rooms = {}\n\n"
	
	--Each room--
	for room_k, room in pairs(mdat.rooms) do
		compiled = compiled..
			"rooms."..room_k..
			" = {\n\tx1 = "..room.x1..", y1 = "..room.y1..
			",\n\tx2 = "..room.x2..", y2 = "..room.y2..
			",\n\n\t rx1 = "..room.rx1..", ry1 = "..room.ry1..
			",\n\t rx2 = "..room.rx2..", ry2 = "..room.ry2..
			",\n\n\tcx = "..room.cx..", cy = "..room.cy..
			",\n\n\t objects = {"
		
		for _, obj in pairs(room.objects) do
			compiled = compiled..
				"\n\t\t{\""..obj[1].."\", "..obj[2]..", "..obj[3]..", "
			compiled = write_table(compiled, obj[4])
			compiled = compiled.."},"
		end
		compiled = compiled.."\n\t}\n}\n\n"
	end
	
	compiled = compiled.."--Connections\nmdat.connections = {\n"
	
	for i = 1, #mdat.connections do
		local connection = mdat.connections[i]
		compiled = compiled.."\t{\""..connection[1].."\", \""..connection[2].."\"},\n"
	end
	
	compiled = compiled.."}\n\nfor _, v in ipairs(mdat.connections) do\n\tlocal room_a = v[1]\n\tlocal room_b = v[2]\n\n\trooms[room_a].con = rooms[room_a].con or {}\n\trooms[room_b].con = rooms[room_b].con or {}\n\n\ttable.insert(rooms[room_a].con, room_b)\n\ttable.insert(rooms[room_b].con, room_a)\nend\n\nmdat.rooms = rooms\n\nreturn mdat"
	
	HDD.write(PATH..path, compiled)
	selected_object_name = "Exported to "..PATH..path
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
	return x >= room.x1 and y >= room.y1 and x < room.x2 and y < room.y2
end

local function find_mouse(x, y)
	return (x - HSW) / view_scale + view_x, (y - HSH) / view_scale + view_y
end

local function handle_clicked(x, y)
	if selected_tool == 2 and selected_room and selected_index == nil then
		local left_handle_x = selected_rect.x1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD
		local right_handle_x = selected_rect.x2 + ROOM_HANDLE_PAD
		--If we're within the x coordinates that could possibly select a handle
		if x >= left_handle_x and x < right_handle_x + ROOM_HANDLE_SIZE then
			local top_handle_y = selected_rect.y1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD
			local bottom_handle_y = selected_rect.y2 + ROOM_HANDLE_PAD
			--If we're within the y coordinates that could possibly select a handle
			if y >= top_handle_y and y < bottom_handle_y + ROOM_HANDLE_SIZE then
				local is_top = y < top_handle_y + ROOM_HANDLE_SIZE
				local is_bottom = y >= bottom_handle_y
				--If we're on the left side
				if x < left_handle_x + ROOM_HANDLE_SIZE then
					if is_top then return 1
					elseif is_bottom then return 3 end
				--If we're on the right side
				elseif x >= right_handle_x then
					if is_top then return 2
					elseif is_bottom then return 4 end
				end
			end
		end
	end
	return false
end

local function select_room_bounds(room)
	selected_rect = {x1 = room.x1 * 8, y1 = room.y1 * 8, x2 = room.x2 * 8, y2 = room.y2 * 8}
end

local function press_screen(x, y)
	local selected_handle = handle_clicked(x, y)
	if selected_handle then
		room_handle_grabbed = selected_handle
	else
		--Pixel world-space to grid world-space
		x, y = floor(x / 8), floor(y / 8)
		
		selected_room = nil
		selected_rect = nil
		selected_room_name = nil
		selected_object_name = nil
		selected_index = nil

		for room_name, room in pairs(mdat.rooms) do
			if in_room(room, x, y) then
				--We're going to assume that we've just selected the room
				selected_room = room
				select_room_bounds(room)
				selected_room_name = room_name

				--And then we'll check to see if we've actually selected an object, and replace the selection data with that if we have.
				if objects_selectable then
					for object_index, object in pairs(room.objects) do
						if data.test_occupancy(object[1], x, y, object[2], object[3]) then
							selected_index = object_index
							selected_object_name = object[1]
							
							local rect_x, rect_y, rect_w, rect_h = data.get_object_bounds(selected_object_name, (object[2]) * 8, (object[3]) * 8)
							selected_rect = {x1 = rect_x, y1 = rect_y, x2 = rect_x + rect_w, y2 = rect_y + rect_h}
							break
						end
					end
				end
				break
			end
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

local function red_tint()
	pal(1, 2)
	pal(2, 2)
	pal(3, 2)
	pal(4, 8)
	pal(5, 2)
	pal(6, 8)
	pal(7, 9)
	pal(9, 8)
	pal(10, 9)
	pal(11, 8)
	pal(12, 9)
	pal(13, 8)
	pal(14, 9)
	pal(15, 9)
end

------LOVE events------

local function _mousepressed(x, y, button)
	if button == 1 then
		if y >= SH - TOOLBAR_WIDTH then
			press_tool(x)
		else
			local world_x, world_y = find_mouse(x, y)
			press_screen(world_x, world_y)
		end
	end
	
    if button == 2 then
        dragging = true
        cursor("hand")
    end
end

local function _mousereleased(x, y, button)
	if button == 1 then
		room_handle_grabbed = false
	end
	
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
	
	if room_handle_grabbed then
		local world_x, world_y = find_mouse(x, y)
		
		local grid_x, grid_y = floor(world_x / 8 + 0.5), floor(world_y / 8 + 0.5)
		
		if room_handle_grabbed == 1 then
			if grid_x < selected_room.x2 then
				selected_room.x1 = grid_x
			end
			if grid_y < selected_room.y2 then
				selected_room.y1 = grid_y
			end
		elseif room_handle_grabbed == 2 then
			if grid_x > selected_room.x1 then
				selected_room.x2 = grid_x
			end
			if grid_y < selected_room.y2 then
				selected_room.y1 = grid_y
			end
		elseif room_handle_grabbed == 3 then
			if grid_x < selected_room.x2 then
				selected_room.x1 = grid_x
			end
			if grid_y > selected_room.y1 then
				selected_room.y2 = grid_y
			end
		else
			if grid_x > selected_room.x1 then
				selected_room.x2 = grid_x
			end
			if grid_y > selected_room.y1 then
				selected_room.y2 = grid_y
			end
		end
		
		select_room_bounds(selected_room)
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
	r = function() toggles[2]:on_pressed() end,
	lctrl = function() ctrl_pressed = true end,
	s = function() if ctrl_pressed then export("mdat.lua") end end
}

local function _keypressed(key)
	if keypress_actions[key] then
		keypress_actions[key]()
	end
end

local keyrelease_actions = {
	lalt = function() toggles[1]:set_enabled(false) end,
	lctrl = function() ctrl_pressed = false end,
}

local function _keyreleased(key)
	if keyrelease_actions[key] then
		keyrelease_actions[key]()
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
		local room_px1,		room_py1 =	room.x1 * 8,	room.y1 * 8
		local room_px2,		room_py2 =	room.x2 * 8,	room.y2 * 8
		
		local room_prx1,	room_pry1 =	room.rx1 * 8,	room.ry1 * 8
		local room_prx2,	room_pry2 =	room.rx2 * 8,	room.ry2 * 8
		
		local room_pw,		room_ph =	room_px2 - room_px1,	room_py2 - room_py1
		local room_prw,		room_prh =	room_prx2 - room_prx1,	room_pry2 - room_pry1

		--Objects--
		for _, object in pairs(room.objects) do
			if not in_room(room, object[2], object[3]) then
				red_tint()
			end
			data.draw_object(object[1], object[2], object[3])
			pal()
		end

		--Room data--
		if show_room_data then
			
			color(8)
			rect(room_px1, room_py1, room_pw, room_ph, true)
			
			color(0)
			rect(room_px1 + 1, room_py1 + 1, room_name:len() * FONT_WIDTH, FONT_HEIGHT)
			color(7)
			print(room_name, room_px1 + 1, room_py1 + 1)
			if show_reveal_bounds then
				color(11)
				rect(room_prx1, room_pry1, room_prw, room_prh, true)
			end
		end
	end
	
	--Selection bounds--
	if selected_rect then
		color(7)
		rect(
			selected_rect.x1 - 1,
			selected_rect.y1 - 1,
			selected_rect.x2 - selected_rect.x1 + 2,
			selected_rect.y2 - selected_rect.y1 + 2,
			true)
		
		if selected_tool == 2 and selected_room and not selected_index then
			f.Sprite(7,
				selected_rect.x1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD,
				selected_rect.y1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD, 2)
			f.Sprite(7,
				selected_rect.x2 + ROOM_HANDLE_PAD,
				selected_rect.y1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD, 2)
			f.Sprite(7,
				selected_rect.x1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD,
				selected_rect.y2 + ROOM_HANDLE_PAD, 2)
			f.Sprite(7,
				selected_rect.x2 + ROOM_HANDLE_PAD,
				selected_rect.y2 + ROOM_HANDLE_PAD, 2)
		end
	end

    popMatrix()

	if selected_room_name then
		local str_len = selected_room_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, 0, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(selected_room_name, HSW - str_len * FONT_WIDTH/2, 1)
	end
	
	if selected_object_name then
		local str_len = selected_object_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, FONT_HEIGHT + 1, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(selected_object_name, HSW - str_len * FONT_WIDTH/2, FONT_HEIGHT + 2)
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
