local floor = math.floor

toolbar = {}
local this = toolbar

function this.press_tool(x)
	if x >= 0 and x < #state.modes * 10 then
		state.set_mode(floor(x / 10) + 1)
	elseif x < SW and x > SW - #state.toggles * 10 then
		local toggle_index = floor((SW - x) / 10) + 1
		local toggle = state.toggles[toggle_index]
		toggle:on_pressed()
	end
end

function this.draw()
	color(2)
	local toolbar_y = SH - TOOLBAR_WIDTH
	rect(0, toolbar_y, SW, TOOLBAR_WIDTH)

	for i = 1, #state.modes do
		local tool = state.modes[i]

		local x = (i - 1) * 10
		if state.mode_index == i then
			pal(2, 15)
			pal(15, 2)
			rect(x, toolbar_y, 10, 10)
		end
		f.Sprite(tool.sprite, x + 1, toolbar_y + 1, 2)
		pal()
	end

	for i = 1, #state.toggles do
		local toggle = state.toggles[i]

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