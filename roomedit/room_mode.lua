local floor = math.floor

room_mode = {}

local this = room_mode

function this.press_screen(x, y)
	--Pixel world-space to grid world-space
	local gx, gy = floor(x / 8), floor(y / 8)
	
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