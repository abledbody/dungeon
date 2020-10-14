local floor = math.floor

room_mode = {}

local this = room_mode

function this.press_screen(x, y)
	--Pixel world-space to grid world-space
	local gx, gy = floor(x / 8), floor(y / 8)
	
	local selected_handle
	local room = selection.room
	if room and not selection.object_index then
		if state.show_reveal_bounds then
			selected_handle = selection.handle_clicked(x, y, room.rx1 * 8, room.ry1 * 8, room.rx2 * 8, room.ry2 * 8)
		else
			selected_handle = selection.handle_clicked(x, y, room.x1 * 8, room.y1 * 8, room.x2 * 8, room.y2 * 8)
		end
	end
	
	if selected_handle then
		selection.handle_grabbed = selected_handle
	else
		selection.deselect()

		for room_name, room in pairs(mdat.rooms) do
			if rooms.in_room(room, gx, gy) then
				--We're going to assume that we've just selected the room
				selection.select_room(room_name)

				--And then we'll check to see if we've actually selected an object, and replace the selection data with that if we have.
				if state.objects_selectable then
					for object_index, object in pairs(room.objects) do
						if object_data.test_occupancy(object[1], gx, gy, object[2], object[3]) then
							selection.select_object(object_index, object)
							break
						end
					end
				end
				
				if not selection.object_index and toolbar.get_mode() == "room" and mouse.double_clicked(x, y) then
					rooms.edit_room_name()
				end
				
				break
			end
		end
	end
	
	if not selection.room and mouse.double_clicked(x, y) then
		rooms.new_room(gx, gy)
	end
end