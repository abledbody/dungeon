objects = {}
local this = objects

function this.try_select(gx, gy)
	local room = selection.room
	for object_index, object in pairs(room.objects) do
		if object_data.test_occupancy(object[1], gx, gy, object[2], object[3]) then
			selection.select_object(object_index, object)
			return true
		end
	end
	return false
end