local floor = math.floor

object_mode = {}

local this = object_mode

local grabbed_object = false

function this.press_screen(x, y)
	--Pixel world-space to grid world-space
	local gx, gy = floor(x / 8), floor(y / 8)
	
	selection.deselect()

	if rooms.try_select(gx, gy) and state.objects_selectable then
		objects.try_select(gx, gy)
	end
end