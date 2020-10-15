state = {
	ctrl_pressed = false,

	show_room_data = false,
	show_reveal_bounds = false,
	show_connections = false,
	objects_selectable = true,
	
	active_string = nil,
	editing_room_name = nil,
	
	mode_index = 1,
	active_mode = nil,
}

local this = state

this.toggles = {
	{
		sprite = 5,
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			this.show_room_data, self.enabled = value, value
		end,
	},
	{
		sprite = 6,
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			this.show_reveal_bounds, self.enabled = value, value
			selection.select_room_bounds(selection.room)
		end,
	},
	{
		sprite = 9,
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			this.show_connections, self.enabled = value, value
		end,
	}
}

local mode_name = "object"
this.modes = {
	{
		name = "object",
		sprite = 2,
		press_screen = object_mode.press_screen,
	},
	{
		name = "room",
		sprite = 4,
		on_selected = function()
			this.objects_selectable = false
			this.toggles[1]:set_enabled(true)
		end,
		on_deselected = function()
			this.objects_selectable = true
			this.toggles[1]:set_enabled(false)
		end,
		press_screen = room_mode.press_screen,
	},
}

function this.set_mode(index)
	local mode = this.modes[this.mode_index]
	if mode.on_deselected then
		mode.on_deselected()
	end
	
	this.mode_index = index
	
	mode = this.modes[this.mode_index]
	mode_name = mode.name
	if mode.on_selected then
		mode.on_selected()
	end
	this.active_mode = mode
end

function this.get_mode()
	return mode_name
end