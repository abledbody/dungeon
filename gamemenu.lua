local game_menu = {}

local categories = {
	system = {}
}

function game_menu.open()
	game.screenshot()
	main.setState("game_menu")
end

function game_menu.close()
	main.setState("game")
end

function main.updates.game_menu(dt)
	local close_menu = btn_down(7)

	if close_menu then
		game_menu.close()
	end
end

function main.draws.game_menu()
	clear()

	brightness(1)
	game.scrImage:draw()
end

return game_menu