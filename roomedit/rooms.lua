rooms = {}
local this = rooms

function this.in_room(room, x, y)
	return x >= room.x1 and y >= room.y1 and x < room.x2 and y < room.y2
end

function this.new_room(x, y)
	local room_name_index = 0
	local room_name = "unnamed_room_"..room_name_index
	while (mdat.rooms[room_name]) do
		room_name_index = room_name_index + 1
		room_name = "unnamed_room_"..room_name_index
	end
	
	do
		local room = mdat.rooms[mdat.initial_room]
		while room.next do
			room = mdat.rooms[room.next]
		end
		room.next = room_name
	end
	
	mdat.rooms[room_name] = {
		next = nil,
		
		x1 = x,		y1 = y,
		x2 = x+1,	y2 = y+1,
	
		rx1 = x,	ry1 = y,
		rx2 = x+1,	ry2 = y+1,
	
		cx = x,	cy = y,
		objects = {
			
		}
	}
	selection.select_room(room_name)
end

function this.delete_room(room_name)
	local new_target_room = mdat.rooms[selection.room_name].next
	
	mdat.rooms[selection.room_name] = nil
	
	do
		local room = mdat.rooms[mdat.initial_room]
		while room.next and room.next ~= room_name do
			room = mdat.rooms[room.next]
		end
		room.next = new_target_room
	end
	
	for i = #mdat.connections, 1, -1  do
		local connection = mdat.connections[i]
		if connection[1] == room_name or connection[2] == room_name then
			table.remove(mdat.connections, i)
		end
	end
end

function this.edit_room_name()
	state.editing_room_name = true
	state.active_string = selection.room_name
end

function this.apply_room_name(room_name, new_name)
	if not mdat.rooms[new_name] then
		mdat.rooms[new_name] = mdat.rooms[room_name]
		mdat.rooms[room_name] = nil
	end
	
	do
		local room = mdat.rooms[mdat.initial_room]
		while room.next and room.next ~= room_name do
			room = mdat.rooms[room.next]
		end
		if room.next == room_name then
			room.next = new_name
		end
	end
	
	for i = 1, #mdat.connections do
		local connection = mdat.connections[i]
		if connection[1] == room_name then
			connection[1] = new_name
		elseif connection[2] == room_name then
			connection[2] = new_name
		end
	end
end

function this.find_room(gx, gy)
	for room_name, room in pairs(mdat.rooms) do
		if this.in_room(room, gx, gy) then
			return room_name
		end
	end
end

function this.try_select(gx, gy)
	local found_room = this.find_room(gx, gy)
	
	if found_room then
		selection.select_room(found_room)
		return true
	else
		return false
	end
end