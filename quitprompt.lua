local HSW, HSH = const.HSW, const.HSH

local YES_X = HSW - 19
local NO_X = HSW + 11
local PROMPT_Y = HSH + 3

local quit_prompt = {}

local quit_selected = false

function main.inits.quit_prompt()
	quit_selected = false
	diBox.set_text("Did you mean to quit?\n\nYes   No")
end

function main.updates.quit_prompt(dt)
	if btn_down(1) or btn_down(2) then
		SFX(15, 3)
		quit_selected = not quit_selected
	end

	if btn_down(5) then
		if quit_selected then
			SFX(16, 3)
			main.setState("main_menu")
		else
			SFX(23, 3)
			main.setState("game_menu")
		end
	elseif btn_down(6) then
		SFX(23, 3)
		main.setState("game_menu")
	end

	diBox.widen(dt)
	menu.update_cursor(dt)
end

function main.draws.quit_prompt()
	main.draws.game_menu()
	
	diBox.draw_box()

	local x = quit_selected and YES_X or NO_X

	menu.draw_cursor(x, PROMPT_Y)
end

return quit_prompt