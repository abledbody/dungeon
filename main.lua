	--Variables--
local updates = {}
local draws = {}
local state = "main_menu"

local button_locks = {
	false,
	false,
	false,
	false,
	false,
	false,
	false,
}
local buttons_down = {
	false,
	false,
	false,
	false,
	false,
	false,
	false,
}
local buttons_up = {
	false,
	false,
	false,
	false,
	false,
	false,
	false,
}

	--Functions--
--Just to change _update and _draw in the same line
local function setState(new_state)
	state = new_state
end

function _update(dt)
	for i = 1, 7 do
		buttons_down[i] = false
		buttons_up[i] = false

		local button_down = btn(i)
		if button_locks[i] then
			if not button_down then
				buttons_up[i] = true
			end
		else
			if button_down then
				buttons_down[i] = true
			end
		end

		button_locks[i] = button_down
	end

	updates[state](dt)
end

function _draw()
	draws[state]()
end

function btn_up(index)
	return buttons_up[index]
end

function btn_down(index)
	return buttons_down[index]
end

	--Module--
local main = {}

main.updates = updates
main.draws = draws

main.setState = setState

return main