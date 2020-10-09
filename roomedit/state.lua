state = {
	dragging = false,
	ctrl_pressed = false,

	room_handle_grabbed = false,

	show_room_data = false,
	show_reveal_bounds = false,
	objects_selectable = true,

	selected_room = nil,
	selected_index = nil,
	selected_rect = nil,
	selected_room_name = nil,
	selected_object_name = nil,
	
	active_string = nil,
	editing_room_name = nil,
}

local this = state



function this.deselect()
	this.selected_room = nil
	this.selected_rect = nil
	this.selected_room_name = nil
	this.selected_object_name = nil
	this.selected_index = nil
end

function this.select_room(room_name)
	local room = mdat.rooms[room_name]
	state.selected_room = room
	state.select_room_bounds(room)
	state.selected_room_name = room_name
end

function this.select_room_bounds(room)
	if room then
		if this.show_reveal_bounds then
			this.selected_rect = {x1 = room.rx1 * 8, y1 = room.ry1 * 8, x2 = room.rx2 * 8, y2 = room.ry2 * 8}
		else
			this.selected_rect = {x1 = room.x1 * 8, y1 = room.y1 * 8, x2 = room.x2 * 8, y2 = room.y2 * 8}
		end
	end
end