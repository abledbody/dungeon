local floor = math.floor

local this = {}
toolbar = this

this.toggles = {
	{
		sprite = 5,
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			state.show_room_data, self.enabled = value, value
		end,
	},
	{
		sprite = 6,
		enabled = false,
		on_pressed = function(self)
			self:set_enabled(not self.enabled)
		end,
		set_enabled = function(self, value)
			state.show_reveal_bounds, self.enabled = value, value
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
			state.show_connections, self.enabled = value, value
		end,
	}
}

local mode_index = 1
local mode_name = "object"
this.modes = {
	{
		name = "object",
		sprite = 2,
	},
	{
		name = "room",
		sprite = 4,
		on_selected = function()
			state.objects_selectable = false
			this.toggles[1]:set_enabled(true)
		end,
		on_deselected = function()
			state.objects_selectable = true
			this.toggles[1]:set_enabled(false)
		end,
	},
}

function this.select_tool(index)
	local tool = this.modes[mode_index]
	if tool.on_deselected then
		tool.on_deselected()
	end
	
	mode_index = index
	
	tool = this.modes[mode_index]
	mode_name = tool.name
	if tool.on_selected then
		tool.on_selected()
	end
end

function this.press_tool(x)
	if x >= 0 and x < #this.modes * 10 then
		this.select_tool(floor(x / 10) + 1)
	elseif x < SW and x > SW - #this.toggles * 10 then
		local toggle_index = floor((SW - x) / 10) + 1
		local toggle = this.toggles[toggle_index]
		toggle:on_pressed()
	end
end

function this.get_mode()
	return mode_name
end

function this.draw()
	color(2)
	local toolbar_y = SH - TOOLBAR_WIDTH
	rect(0, toolbar_y, SW, TOOLBAR_WIDTH)

	for i = 1, #this.modes do
		local tool = this.modes[i]

		local x = (i - 1) * 10
		if mode_index == i then
			pal(2, 15)
			pal(15, 2)
			rect(x, toolbar_y, 10, 10)
		end
		f.Sprite(tool.sprite, x + 1, toolbar_y + 1, 2)
		pal()
	end

	for i = 1, #this.toggles do
		local toggle = this.toggles[i]

		local x = SW - 10 - (i - 1) * 10
		if toggle.enabled then
			pal(2, 15)
			pal(15, 2)
			rect(x, toolbar_y, 10, 10)
		end
		f.Sprite(toggle.sprite, x + 1, toolbar_y + 1, 2)
		pal()
	end
end