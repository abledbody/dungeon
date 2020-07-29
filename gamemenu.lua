local game_menu = {}

local PADDING = 16
local WIDTH = const.SW - PADDING * 2
local HEIGHT = const.SH - PADDING * 2

local BORDER_WIDTH = 3
local HW = WIDTH / 2
local HH = HEIGHT / 2
local INSCREEN_QUAD = quad(0, 0, WIDTH, HEIGHT, const.SW, const.SH)

local SLOT_SIZE = 16
local SLOT_PADDING = 6

local categories = {
	system = {
		selected = 0,
		slots = {
			[0] = {
				draw = function(self, x, y)
					Sprite(315, x + 4, y + 4)
				end,

				select = function(self)
					main.setState("main_menu")
				end,
			},
			{
				draw = function(self, x, y)
					Sprite(316, x + 4, y + 4)
				end,

				select = function(self)
					main.setState("main_menu")
				end
			}
		}
	},

	flasks = {
		selected = 0,
		slots = {
			[0] = {
				draw = function(self, x, y)
					pal(6, 8)
					pal(5, 8)
					pal(1, 2)
					pal(15, 9)
					SpriteGroup(313, x, y, 2, 2)
					pal()
				end,

				select = function()
					game_menu.close()
				end,
			}
		}
	}
}

local category_indeces = {
	[0] = "system",
	"flasks",
}

local selected_category = 0
local active_category = categories[category_indeces[selected_category]]

function game_menu.open()
	game.screenshot()
	SFX(18, 3)
	main.setState("game_menu")
end

function game_menu.close()
	main.setState("game")
end

function main.updates.game_menu(dt)
	
	if btn_down(1) then
		active_category.selected = menu.cycle_previous(active_category.slots, active_category.selected)
		SFX(15)
	end

	if btn_down(2) then
		active_category.selected = menu.cycle_next(active_category.slots, active_category.selected)
		SFX(15)
	end

	if btn_down(3) then
		selected_category = menu.cycle_previous(category_indeces, selected_category)
		active_category = categories[category_indeces[selected_category]]
		SFX(15)
	end

	if btn_down(4) then
		selected_category = menu.cycle_next(category_indeces, selected_category)
		active_category = categories[category_indeces[selected_category]]
		SFX(15)
	end

	if btn_down(5) then
		active_category.slots[active_category.selected]:select()
		SFX(16)
	end

	if btn_down(6) or btn_down(7) then
		game_menu.close()
		SFX(19, 3)
	end
end

function main.draws.game_menu()
	clear()

	for i = 0, #category_indeces do
		local category = categories[category_indeces[i]]
		for j = 0, #category.slots do
			local slot = category.slots[j]

			local x = (j - category.selected) * (SLOT_SIZE + SLOT_PADDING) + HW - SLOT_SIZE / 2
			local y = (i - selected_category) * (SLOT_SIZE + SLOT_PADDING) + HH - SLOT_SIZE / 2
			if selected_category == i and category.selected == j then
				color(7)
			else
				color(5)
			end
			
			rect(x - 1, y - 1, SLOT_SIZE + 2, SLOT_SIZE + 2, true)
			slot:draw(x, y)
			brightness(0)
		end
	end

	--Debug
	print(selected_category, 0, 0)
	print(active_category.selected, 0, 8)


	--After drawing to the menu

	local menu_render = screenshot(0, 0, WIDTH, HEIGHT)
	menu_render = menu_render:image()
	
	palt(0, false)
	brightness(1)
	game.scrImage:draw()

	brightness(0)
	color(1)
	rect(PADDING - BORDER_WIDTH, PADDING - BORDER_WIDTH, WIDTH + BORDER_WIDTH * 2, HEIGHT + BORDER_WIDTH * 2)
	color(7)
	rect(PADDING - 2, PADDING - 2, WIDTH + 4, HEIGHT + 4, true)
	menu_render:draw(PADDING, PADDING)
	palt()
end

return game_menu