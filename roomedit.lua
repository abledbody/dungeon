PATH = "D:/dungeon/"
ROOMEDIT_PATH = PATH.."roomedit/"

local floor = math.floor
local abs = math.abs

cursor("normal")
dofile(PATH .. "Rayleigh.lua")

mdat = dofile(PATH .. "mdat.lua")
dofile(ROOMEDIT_PATH .. "object_data.lua")

dungeon = HDD.read(PATH .. "dungeon.lk12")

--------------------------------------

dofile(ROOMEDIT_PATH.."consts.lua")
dofile(PATH.."amath.lua")

dofile(ROOMEDIT_PATH.."camera.lua")
dofile(ROOMEDIT_PATH.."state.lua")
dofile(ROOMEDIT_PATH.."toolbar.lua")
dofile(ROOMEDIT_PATH.."render.lua")
dofile(ROOMEDIT_PATH.."rooms.lua")
dofile(ROOMEDIT_PATH.."mouse.lua")
dofile(ROOMEDIT_PATH.."selection.lua")
dofile(ROOMEDIT_PATH.."room_mode.lua")

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
	local compiled = "local mdat = {}\nlocal rooms = {}\nmdat.initial_room = \""..mdat.initial_room.."\"\n\n"
	
	--Each room--
	local room_k = mdat.initial_room
	local room = mdat.rooms[room_k]
	while room do
		local next_room_name
		if room.next then
			next_room_name = "\""..room.next.."\""
		else
			next_room_name = "nil"
		end
		
		compiled = compiled..
			"rooms."..room_k..
			" = {\n\tnext = "..next_room_name..
			",\n\n\tx1 = "..room.x1..", y1 = "..room.y1..
			",\n\tx2 = "..room.x2..", y2 = "..room.y2..
			",\n\n\trx1 = "..room.rx1..", ry1 = "..room.ry1..
			",\n\trx2 = "..room.rx2..", ry2 = "..room.ry2..
			",\n\n\tcx = "..room.cx..", cy = "..room.cy..
			",\n\n\t objects = {"
		
		for _, obj in pairs(room.objects) do
			compiled = compiled..
				"\n\t\t{\""..obj[1].."\", "..obj[2]..", "..obj[3]..", "
			compiled = write_table(compiled, obj[4])
			compiled = compiled.."},"
		end
		compiled = compiled.."\n\t}\n}\n\n"
		
		room_k = room.next
		room = mdat.rooms[room_k]
	end
	
	compiled = compiled.."--Connections\nmdat.connections = {\n"
	
	for i = 1, #mdat.connections do
		local connection = mdat.connections[i]
		compiled = compiled.."\t{\""..connection[1].."\", \""..connection[2].."\"},\n"
	end
	
	compiled = compiled.."}\n\nfor _, v in ipairs(mdat.connections) do\n\tlocal room_a = v[1]\n\tlocal room_b = v[2]\n\n\trooms[room_a].con = rooms[room_a].con or {}\n\trooms[room_b].con = rooms[room_b].con or {}\n\n\ttable.insert(rooms[room_a].con, room_b)\n\ttable.insert(rooms[room_b].con, room_a)\nend\n\nmdat.rooms = rooms\n\nreturn mdat"
	
	HDD.write(PATH..path, compiled)
	selection.room_name = "Exported to "..PATH..path
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

local keypress_actions = {
	lalt = function() toolbar.toggles[1]:set_enabled(true) end,
	["1"] = function() toolbar.select_tool(1) end,
	["2"] = function() toolbar.select_tool(2) end,
	r = function() toolbar.toggles[2]:on_pressed() end,
	lctrl = function() state.ctrl_pressed = true end,
	s = function() if state.ctrl_pressed then export("mdat.lua") end end,
	delete = function()
		if selection.object_index then
			table.remove(selection.room.objects, selection.object_index)
		elseif selection.room then
			rooms.delete_room(selection.room_name)
		end
		selection.deselect()
	end,
}

local function _keypressed(key)
	if state.editing_room_name then
		local active_string = state.active_string
		
		if key:len() == 1 then
			active_string = active_string..key
		elseif key == "backspace" then
			if active_string ~= "" then
				active_string = active_string:sub(1, active_string:len() - 1)
			end
		elseif key == "return" then
			rooms.apply_room_name(selection.room_name, active_string)
			selection.select_room(active_string)
			state.editing_room_name = false
		elseif key == "escape" then
			state.editing_room_name = false
		end
		
		state.active_string = active_string
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
	mouse.update(dt)
end

local function _draw()
	clear()

	local inv_scale = 1 / camera.view_scale

	--Camera transformations--
	pushMatrix()
	camera.transform()

	--Border--
	color(7)
	rect(-inv_scale, -inv_scale, 1152 + inv_scale * 2, inv_scale)
	rect(-inv_scale, -inv_scale, inv_scale, 1024 + inv_scale * 2)
	rect(-inv_scale, 1025, 1152 + inv_scale * 2, inv_scale)
	rect(1153, -inv_scale, inv_scale, 1024 + inv_scale * 2)

	--Tilemap--
    render.draw_tilemap()

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
			if not rooms.in_room(room, object[2], object[3]) then
				red_tint()
			end
			object_data.draw_object(object[1], object[2], object[3])
			pal()
		end

		--Room data--
		if state.show_room_data then
			
			color(8)
			rect(room_px1, room_py1, room_pw, room_ph, true)
			
			local room_name_str = room_name
			
			if state.editing_room_name and selection.room_name == room_name then
				room_name_str = state.active_string
			end
			
			color(0)
			rect(room_px1 + 1, room_py1 + 1, room_name_str:len() * FONT_WIDTH, FONT_HEIGHT)
			color(7)
			print(room_name_str, room_px1 + 1, room_py1 + 1)
			
			if state.show_reveal_bounds or (selection.room_name == room_name and selection.handle_grabbed) then
				color(11)
				rect(room_prx1, room_pry1, room_prw, room_prh, true)
			end
			
			f.Sprite(8, room.cx * 8 - 2, room.cy * 8 - 2, 2)
		end
	end
	
	selection.draw()

    popMatrix()

	if selection.room_name then
		local str_len = selection.room_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, 0, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(selection.room_name, HSW - str_len * FONT_WIDTH/2, 1)
	end
	
	if selection.object_name then
		local str_len = selection.object_name:len()

		color(0)
		rect(HSW - str_len * 2.5 - 1, FONT_HEIGHT + 1, str_len * FONT_WIDTH + 1, FONT_HEIGHT + 1)
		color(7)
		print(selection.object_name, HSW - str_len * FONT_WIDTH/2, FONT_HEIGHT + 2)
	end

	toolbar.draw()
end

local events = {
    update = function(a, b, c, d, e)
        _update(a)
        _draw()
    end,
    mousepressed = mouse.pressed,
    mousereleased = mouse.released,
	mousemoved = mouse.moved,
	wheelmoved = mouse.wheel_moved,
	keypressed = _keypressed,
	keyreleased = _keyreleased,
}

local quit = false

while true do
    local event, a, b, c, d, e = pullEvent()

    if event == "keypressed" and a == "escape" and not state.editing_room_name then
        quit = true
    end
    if events[event] then
        events[event](a, b, c, d, e)
	end
	
	if quit then
		break
	end
end
