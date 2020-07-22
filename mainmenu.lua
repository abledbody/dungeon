local OPTIONS = {
	[0] = {
		name = "Start",
		select = function()
			main.setState("game")
			SFX(10)
		end
	},
	{
		name = "Options",
		select = function()
			main.setState("game")
		end
	},
	{
		name = "Quit",
		select = function()
			clear()
			exit()
		end
	}
}

local OPTIONS_X = 16
local OPTIONS_Y = screenHeight() - (#OPTIONS + 1)*8 - 16
local OPTIONS_WIDTH = 40
local TITLE_X = screenWidth()/2 - 8*3
local TITLE_Y = 32

local selected = 0



local cursor_animator = game.Animator:new(aData.cursor, "anim")

local main_menu = {}

local pressed = {}

function main.updates.main_menu(dt)
	if btn(5) then
		if not pressed.start then
			OPTIONS[selected].select()
			pressed.start = true
		end
	else
		pressed.start = false
	end

	if btn(3) then
		if not pressed.up then
			selected = (selected - 1) % (#OPTIONS + 1)
			pressed.up = true
			SFX(15)
		end
	else
		pressed.up = false
	end

	if btn(4) then
		if not pressed.down then
			selected = (selected + 1) % (#OPTIONS + 1)
			pressed.down = true
			SFX(15)
		end
	else
		pressed.down = false
	end

	cursor_animator:update(dt)
end

function main.draws.main_menu()
	clear()

	SpriteGroup(289, TITLE_X, TITLE_Y, 6, 1)

	color(1)
	rect(OPTIONS_X - 2, OPTIONS_Y - 2, OPTIONS_WIDTH, (#OPTIONS + 1) * 8 + 2)

	for i = 0, #OPTIONS do
		local option = OPTIONS[i]
		color(7)
		print(option.name, OPTIONS_X, OPTIONS_Y + i*8)
	end

	local cursor_sprite = cursor_animator:fetch("spr")

	Sprite(cursor_sprite, OPTIONS_X - 10, OPTIONS_Y + selected*8)
end

return main_menu