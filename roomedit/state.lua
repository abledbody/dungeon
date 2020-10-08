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
}

local this = state


function this.select_room_bounds(room)
	if room then
		if this.show_reveal_bounds then
			this.selected_rect = {x1 = room.rx1 * 8, y1 = room.ry1 * 8, x2 = room.rx2 * 8, y2 = room.ry2 * 8}
		else
			this.selected_rect = {x1 = room.x1 * 8, y1 = room.y1 * 8, x2 = room.x2 * 8, y2 = room.y2 * 8}
		end
	end
end