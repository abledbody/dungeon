PATH = "D:/dungeon/"
ROOMEDIT_PATH = PATH.."roomedit/"

local floor = math.floor
local abs = math.abs

cursor("normal")
dofile(PATH .. "Rayleigh.lua")

mdat = dofile(PATH .. "mdat.lua")
dofile(ROOMEDIT_PATH .. "object_data.lua")

local MapObj = require("Libraries.map")
local Map = MapObj(144, 128)


dungeon = HDD.read(PATH .. "dungeon.lk12")

local function get_tilemap(file)
	local start = file:find("LK12;TILEMAP;")
    local stop = file:find("___spritesheet___")

    local tm_data = file:sub(start, stop)

    Map:import(tm_data)
end


get_tilemap(dungeon)

--------------------------------------

dofile(ROOMEDIT_PATH.."consts.lua")

local view_x, view_y = HSW, HSH
local view_scale = 1
local double_click_time = 0
local last_click_x, last_click_y = 0, 0

dofile(ROOMEDIT_PATH.."state.lua")
dofile(ROOMEDIT_PATH.."toolbar.lua")
dofile(ROOMEDIT_PATH.."render.lua")

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

local function mouse_unmoved(x, y)
	return abs(last_click_x - x) < MOUSE_MOVE_THRESHOLD and abs(last_click_y - y) < MOUSE_MOVE_THRESHOLD
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
	state.selected_object_name = "Exported to "..PATH..path
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

local function handle_clicked(x, y, x1, y1, x2, y2)
	local left_handle_x = x1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD
	local right_handle_x = x2 + ROOM_HANDLE_PAD
	--If we're within the x coordinates that could possibly select a handle
	if x >= left_handle_x and x < right_handle_x + ROOM_HANDLE_SIZE then
		local top_handle_y = y1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD
		local bottom_handle_y = y2 + ROOM_HANDLE_PAD
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
	return false
end

local function new_room(x, y)
	local room_name_index = 0
	local room_name = "unnamed_room_"..room_name_index
	while (mdat.rooms[room_name]) do
		room_name_index = room_name_index + 1
		room_name = "unnamed_room_"..room_name_index
	end
	mdat.rooms[room_name] = {
		x1 = x,		y1 = y,
		x2 = x+1,	y2 = y+1,
	
		rx1 = x,	ry1 = y,
		rx2 = x+1,	ry2 = y+1,
	
		cx = x,	cy = y,
		objects = {
			
		}
	}
	state.select_room(room_name)
end

local function press_screen(x, y)
	--Pixel world-space to grid world-space
	local gx, gy = floor(x / 8), floor(y / 8)
	
	local selected_handle
	local room = state.selected_room
	if room and not state.selected_index then
		if state.show_reveal_bounds then
			selected_handle = handle_clicked(x, y, room.rx1 * 8, room.ry1 * 8, room.rx2 * 8, room.ry2 * 8)
		else
			selected_handle = handle_clicked(x, y, room.x1 * 8, room.y1 * 8, room.x2 * 8, room.y2 * 8)
		end
	end
	
	if selected_handle then
		state.room_handle_grabbed = selected_handle
	else
		state.deselect()

		for room_name, room in pairs(mdat.rooms) do
			if in_room(room, gx, gy) then
				--We're going to assume that we've just selected the room
				state.select_room(room_name)

				--And then we'll check to see if we've actually selected an object, and replace the selection data with that if we have.
				if state.objects_selectable then
					for object_index, object in pairs(room.objects) do
						if object_data.test_occupancy(object[1], gx, gy, object[2], object[3]) then
							state.selected_index = object_index
							state.selected_object_name = object[1]
							
							local rect_x, rect_y, rect_w, rect_h = object_data.get_object_bounds(state.selected_object_name, (object[2]) * 8, (object[3]) * 8)
							state.selected_rect = {x1 = rect_x, y1 = rect_y, x2 = rect_x + rect_w, y2 = rect_y + rect_h}
							break
						end
					end
				end
				break
			end
		end
	end
	
	if not state.selected_room and double_click_time > 0 and mouse_unmoved(x, y) then
		double_click_time = 0
		new_room(gx, gy)
	else
		double_click_time = DOUBLE_CLICK_THRESHOLD
	end
	
	last_click_x = x
	last_click_y = y
end

local function selection_resize(x, y, x1, y1, x2, y2)
	local grid_x, grid_y = floor(x / 8 + 0.5), floor(y / 8 + 0.5)
	
	local handle = state.room_handle_grabbed
	
	if handle == 1 then
		if grid_x < x2 then
			x1 = grid_x
		end
		if grid_y < y2 then
			y1 = grid_y
		end
	elseif handle == 2 then
		if grid_x > x1 then
			x2 = grid_x
		end
		if grid_y < y2 then
			y1 = grid_y
		end
	elseif handle == 3 then
		if grid_x < x2 then
			x1 = grid_x
		end
		if grid_y > y1 then
			y2 = grid_y
		end
	else
		if grid_x > x1 then
			x2 = grid_x
		end
		if grid_y > y1 then
			y2 = grid_y
		end
	end
	
	return x1, y1, x2, y2
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
			toolbar.press_tool(x)
		else
			local world_x, world_y = find_mouse(x, y)
			press_screen(world_x, world_y)
		end
	end
	
    if button == 2 then
        state.dragging = true
        cursor("hand")
    end
end

local function _mousereleased(x, y, button)
	if button == 1 then
		state.room_handle_grabbed = false
	end
	
    if button == 2 then
        state.dragging = false
        cursor("normal")
    end
end

local function _mousemoved(x, y, dx, dy)
    if state.dragging then
        view_x = view_x - dx / view_scale
		view_y = view_y - dy / view_scale
		
		view_x = math.min(math.max(view_x, 0), 1152)
		view_y = math.min(math.max(view_y, 0), 1024)
	end
	
	if state.room_handle_grabbed then
		local world_x, world_y = find_mouse(x, y)
		
		local room = state.selected_room
		local rect = state.selected_rect
		
		local x1, y1, x2, y2 = selection_resize(world_x, world_y, floor(rect.x1 / 8), floor(rect.y1 / 8), floor(rect.x2 / 8), floor(rect.y2 / 8))
		
		if state.show_reveal_bounds then
			room.rx1, room.ry1, room.rx2, room.ry2 = x1, y1, x2, y2
		else
			room.x1, room.y1, room.x2, room.y2 = x1, y1, x2, y2
			room.cx = floor((x2 - x1) / 2) + x1
			room.cy = floor((y2 - y1) / 2) + y1
		end
		
		state.select_room_bounds(room)
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
	lalt = function() toolbar.toggles[1]:set_enabled(true) end,
	["1"] = function() toolbar.select_tool(1) end,
	["2"] = function() toolbar.select_tool(2) end,
	r = function() toolbar.toggles[2]:on_pressed() end,
	lctrl = function() state.ctrl_pressed = true end,
	s = function() if state.ctrl_pressed then export("mdat.lua") end end,
	delete = function()
		if state.selected_index then
			table.remove(state.selected_room.objects, state.selected_index)
		elseif state.selected_room then
			mdat.rooms[state.selected_room_name] = nil
		end
		state.deselect()
	end,
}

local function _keypressed(key)
	if state.active_string then
		state.active_string = state.active_string..key
	elseif keypress_actions[key] then
		keypress_actions[key]()
	end
end

local keyrelease_actions = {
	lalt = function() toolbar.toggles[1]:set_enabled(false) end,
	lctrl = function() state.ctrl_pressed = false end,
}

local function _keyreleased(key)
	if keyrelease_actions[key] then
		keyrelease_actions[key]()
	end
end

------Main loops------

local function _update(dt)
	double_click_time = math.max(double_click_time - dt, 0)
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
			object_data.draw_object(object[1], object[2], object[3])
			pal()
		end

		--Room data--
		if state.show_room_data then
			
			color(8)
			rect(room_px1, room_py1, room_pw, room_ph, true)
			
			color(0)
			rect(room_px1 + 1, room_py1 + 1, room_name:len() * FONT_WIDTH, FONT_HEIGHT)
			color(7)
			print(room_name, room_px1 + 1, room_py1 + 1)
			
			if state.show_reveal_bounds or (state.selected_room_name == room_name and state.room_handle_grabbed) then
				color(11)
				rect(room_prx1, room_pry1, room_prw, room_prh, true)
			end
			
			f.Sprite(8, room.cx * 8 - 2, room.cy * 8 - 2, 2)
		end
	end
	
	--Selection bounds--
	local selected_rect = state.selected_rect
	if selected_rect then
		color(7)
		rect(
			selected_rect.x1 - 1,
			selected_rect.y1 - 1,
			selected_rect.x2 - selected_rect.x1 + 2,
			selected_rect.y2 - selected_rect.y1 + 2,
			true)
		
		if toolbar.get_mode() == "room" and state.selected_room and not state.selected_index then
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

	if state.selected_room_name then
		local str_len = state.selected_room_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, 0, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(state.selected_room_name, HSW - str_len * FONT_WIDTH/2, 1)
	end
	
	if state.selected_object_name then
		local str_len = state.selected_object_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, FONT_HEIGHT + 1, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(state.selected_object_name, HSW - str_len * FONT_WIDTH/2, FONT_HEIGHT + 2)
	end

	toolbar.draw()
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
