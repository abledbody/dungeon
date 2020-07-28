local game_menu = {}

local PADDING = 13
local WIDTH = const.SW - PADDING * 2
local HEIGHT = const.SH - PADDING * 2
local INSCREEN_PADDING = 3
local INSCREEN_WIDTH = WIDTH - INSCREEN_PADDING * 2
local INSCREEN_HEIGHT = HEIGHT - INSCREEN_PADDING * 2

local inscreen_canvas = imagedata(INSCREEN_WIDTH, INSCREEN_HEIGHT)

local categories = {
	system = {}
}

function game_menu.open()
	game.screenshot()
	SFX(18, 3)
	main.setState("game_menu")
end

function game_menu.close()
	main.setState("game")
end

function main.updates.game_menu(dt)
	local close_menu = btn_down(7)

	if close_menu then
		game_menu.close()
		SFX(19, 3)
	end
end

function main.draws.game_menu()
	clear()

	brightness(1)
	game.scrImage:draw()

	brightness(0)
	color(1)
	rect(PADDING, PADDING, WIDTH, HEIGHT)
	color(7)
	rect(PADDING + 1, PADDING + 1, WIDTH - 2, HEIGHT - 2, true)
	color(0)
	rect(PADDING + 3, PADDING + 3, WIDTH - 6, HEIGHT - 6)
end

return game_menu