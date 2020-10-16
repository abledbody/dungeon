local floor = math.floor

room_mode = {
	connection_drag = nil,
}

local this = room_mode

function this.press_screen(x, y)
	--Pixel world-space to grid world-space
	local gx, gy = floor(x / 8), floor(y / 8)
	
	if state.ctrl_pressed then
		state.toggles[3]:set_enabled(true)
		this.connection_drag = rooms.find_room(gx, gy)
	else
		local selected_handle
		if selection.room and not selection.object_index then
			local sel_rect = selection.rect
			selected_handle = selection.handle_clicked(x, y, sel_rect.x1, sel_rect.y1, sel_rect.x2, sel_rect.y2)
		end
		
		if selected_handle then
			selection.handle_grabbed = selected_handle
		else
			selection.deselect()

			if rooms.try_select(gx, gy) then
				if state.objects_selectable then
					objects.try_select(gx, gy)
				end
				if not selection.object_index and mouse.double_clicked(x, y) then
					rooms.edit_room_name()
				end
			end
		end
		
		if not selection.room and mouse.double_clicked(x, y) then
			rooms.new_room(gx, gy)
		end
	end
end

function this.unpress_screen(x, y)
	--Pixel world-space to grid world-space
	local gx, gy = floor(x / 8), floor(y / 8)
	
	local connection_drag = this.connection_drag
	
	if connection_drag then
		local to_room = rooms.find_room(gx, gy)
		if to_room and to_room ~= connection_drag then
			local already_exists = false
			
			for i = 1, #mdat.connections do
				local connection = mdat.connections[i]
				
				if (connection[1] == connection_drag and connection[2] == to_room) or (connection[2] == connection_drag and connection[1] == to_room) then
					already_exists = true
					table.remove(mdat.connections, i)
					break
				end
			end
			
			if not already_exists then
				table.insert(mdat.connections, {connection_drag, to_room})
			end
		end
	
		this.connection_drag = false
	end
end