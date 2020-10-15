local abs, floor = math.abs, math.floor

local DOUBLE_CLICK_THRESHOLD = 0.5
local MOUSE_MOVE_THRESHOLD = 2

mouse = {}

local double_click_time = 0
local last_click_x, last_click_y = 0, 0

function mouse.unmoved(x, y)
	return abs(last_click_x - x) < MOUSE_MOVE_THRESHOLD and abs(last_click_y - y) < MOUSE_MOVE_THRESHOLD
end

function mouse.double_clicked(x, y)
	if double_click_time > 0 and double_click_time < DOUBLE_CLICK_THRESHOLD and mouse.unmoved(x, y) then
		double_click_time = 0
		return true
	else
		double_click_time = DOUBLE_CLICK_THRESHOLD
		return false
	end
end

function mouse.screen_to_world(x, y)
	return (x - HSW) / camera.view_scale + camera.view_x, (y - HSH) / camera.view_scale + camera.view_y
end

function mouse.pressed(x, y, button)
	local world_x, world_y = mouse.screen_to_world(x, y)
	
	if button == 1 then
		if y >= SH - TOOLBAR_WIDTH then
			toolbar.press_tool(x)
		else
			state.active_mode.press_screen(world_x, world_y)
		end
	end
	
    if button == 2 then
        camera.dragging = true
        cursor("hand")
	end
	
	last_click_x = world_x
	last_click_y = world_y
end

function mouse.released(x, y, button)
	if button == 1 then
		selection.handle_grabbed = false
	end
	
    if button == 2 then
        camera.dragging = false
        cursor("normal")
    end
end

function mouse.moved(x, y, dx, dy)
    if camera.dragging then
        camera.move(dx, dy)
	end
	
	if selection.handle_grabbed then
		local world_x, world_y = mouse.screen_to_world(x, y)
		
		local room = selection.room
		local rect = selection.rect
		
		local x1, y1, x2, y2 = selection.resize(world_x, world_y, floor(rect.x1 / 8), floor(rect.y1 / 8), floor(rect.x2 / 8), floor(rect.y2 / 8))
		
		if state.show_reveal_bounds then
			room.rx1, room.ry1, room.rx2, room.ry2 = x1, y1, x2, y2
		else
			room.x1, room.y1, room.x2, room.y2 = x1, y1, x2, y2
			room.cx = floor((x2 - x1) / 2) + x1
			room.cy = floor((y2 - y1) / 2) + y1
		end
		
		selection.select_room_bounds(room)
	end
end

function mouse.wheel_moved(_, delta)
	if delta > 0 then
		camera.view_scale = 1
	end
	if delta < 0 then
		camera.view_scale = 0.25
	end
end

function mouse.update(dt)
	double_click_time = math.max(double_click_time - dt, 0)
end