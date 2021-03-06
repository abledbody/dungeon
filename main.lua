main = {}

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

local state_update
local state_draw

	--Functions--
function main.set_state(new_state)
	state_update = new_state.update
	state_draw = new_state.draw
	if new_state.init then
		new_state.init()
	end
end

function main.new_game()
	game.reset()
	objects.reset()
	game_map.reset("entry")
	game_menu.reset()
	particle_sys.clear()
	objects.spawn("Player", 59, 1, nil, "entry")
	items.types.water_flask:add(1)
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

	state_update(dt)
end

function _draw()
	state_draw()
end

function btn_up(index)
	return buttons_up[index]
end

function btn_down(index)
	return buttons_down[index]
end