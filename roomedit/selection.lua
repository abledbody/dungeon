local floor = math.floor

local ROOM_HANDLE_PAD = -1
local ROOM_HANDLE_SIZE = 5

selection = {
	handle_grabbed = nil,
	
	room = nil,
	room_name = nil,
	rect = nil,
	object_index = nil,
	object_name = nil,
}

local this = selection

function this.resize(x, y, x1, y1, x2, y2)
	local grid_x, grid_y = floor(x / 8 + 0.5), floor(y / 8 + 0.5)
	
	local handle = this.handle_grabbed
	
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

function this.handle_clicked(x, y, x1, y1, x2, y2)
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
				if is_top then return 1 --UR
				elseif is_bottom then return 3 end --BL
			--If we're on the right side
			elseif x >= right_handle_x then
				if is_top then return 2 --UR
				elseif is_bottom then return 4 end --BR
			end
		end
	end
	return false
end

function this.draw(show_handles)
	--Selection bounds--
	local selection_rect = this.rect
	if selection_rect then
		color(7)
		rect(
			selection_rect.x1 - 1,
			selection_rect.y1 - 1,
			selection_rect.x2 - selection_rect.x1 + 2,
			selection_rect.y2 - selection_rect.y1 + 2,
			true)
		
		if show_handles then
			f.Sprite(7,
				selection_rect.x1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD,
				selection_rect.y1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD, 2)
			f.Sprite(7,
				selection_rect.x2 + ROOM_HANDLE_PAD,
				selection_rect.y1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD, 2)
			f.Sprite(7,
				selection_rect.x1 - ROOM_HANDLE_SIZE - ROOM_HANDLE_PAD,
				selection_rect.y2 + ROOM_HANDLE_PAD, 2)
			f.Sprite(7,
				selection_rect.x2 + ROOM_HANDLE_PAD,
				selection_rect.y2 + ROOM_HANDLE_PAD, 2)
		end
	end
end

function this.deselect()
	this.rect = nil
	this.room = nil
	this.room_name = nil
	this.object_name = nil
	this.object_index = nil
end

function this.select_room_bounds(room)
	if room then
		if state.show_reveal_bounds then
			this.rect = {x1 = room.rx1 * 8, y1 = room.ry1 * 8, x2 = room.rx2 * 8, y2 = room.ry2 * 8}
		else
			this.rect = {x1 = room.x1 * 8, y1 = room.y1 * 8, x2 = room.x2 * 8, y2 = room.y2 * 8}
		end
	end
end

function this.select_room(room_name)
	local room = mdat.rooms[room_name]
	this.room = room
	this.select_room_bounds(room)
	this.room_name = room_name
end

function this.select_object(object_index, object)
	selection.object_index = object_index
	selection.object_name = object[1]
	
	local rect_x, rect_y, rect_w, rect_h = object_data.get_object_bounds(selection.object_name, (object[2]) * 8, (object[3]) * 8)
	selection.rect = {x1 = rect_x, y1 = rect_y, x2 = rect_x + rect_w, y2 = rect_y + rect_h}
end