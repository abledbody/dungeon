local game_menu = {}

local PADDING = 16
local WIDTH = const.SW - PADDING * 2
local HEIGHT = const.SH - PADDING * 2

local BORDER_WIDTH = 3
local HW = WIDTH / 2
local HH = HEIGHT / 2
local INSCREEN_QUAD = quad(0, 0, WIDTH, HEIGHT, const.SW, const.SH)

local SLOT_SIZE = 16
local SLOT_H_PADDING = 6
local SLOT_V_PADDING = 6

local SLOT_COUNT_X = 14
local SLOT_COUNT_Y = 13

game_menu.categories = {
	{
		selected = 1,
		name = "system",
		index = 1,
		slots = {
			{
				count = 1,
				object = {
					item_name = "Exit",
					category = "system",
					draw = function(self, x, y)
						Sprite(315, x + 4, y + 4)
					end,

					select = function(self)
						main.setState("main_menu")
					end,
				},
			},
			{
				count = 1,
				object = {
					item_name = "Options",
					category = "system",
					draw = function(self, x, y)
						Sprite(316, x + 4, y + 4)
					end,

					select = function(self)
						game_menu.close()
					end
				},
			},
		},
	},
}

local category_indeces = {
	system = 1,
}

local category_sort_values = {
	system = 1,
	flasks = 2,
}

local item_lookup = {
	Exit = game_menu.categories[1].slots[1],
	Options = game_menu.categories[1].slots[2],
}

local selected_category = 1
local active_category = game_menu.categories[selected_category]


local function select_category(index)
	selected_category = index
	active_category = game_menu.categories[index]
end

local function category_iterator(a, b)
	return a.index < b.index
end

local function sort_categories()
	local categories = game_menu.categories
	table.sort(categories, category_iterator)

	category_indeces = {}
	for i = 1, #categories do
		category_indeces[categories[i].name] = i
	end
	
	select_category(selected_category)
end

local function reselect()
	local length = #game_menu.categories
	if selected_category > length then
		select_category(length)
	end

	length = #active_category.slots
	if active_category.selected > length then
		active_category.selected = length
	end
end

local function new_category(category_name)
	local category = {
		selected = 1,
		name = category_name,
		index = category_sort_values[category_name],
		slots = {}
	}

	table.insert(game_menu.categories, category)

	sort_categories()

	return category
end

local function remove_category(category_name)
	table.remove(game_menu.categories, category_indeces[category_name])
	sort_categories()
	reselect()
end

function game_menu.add_item(item, count)
	count = count or 1

	local existing_item = item_lookup[item.item_name]

	if existing_item then
		existing_item.count = existing_item.count + count
	else
		local relevant_category = game_menu.categories[category_indeces[item.category]] or new_category(item.category)

		local new_slot = {
			count = count,
			object = item,
		}

		item_lookup[item.item_name] = new_slot

		table.insert(relevant_category.slots, new_slot)
	end
end

function game_menu.remove_item(item, count)
	count = count or 1

	local existing_item = item_lookup[item.item_name]

	if existing_item then
		if count == existing_item.count then
			local relevant_category = game_menu.categories[category_indeces[item.category]]

			item_lookup[item.item_name] = nil

			for i = 1, #relevant_category.slots do
				if relevant_category.slots[i].object == item then
					table.remove(relevant_category.slots, i)
					break
				end
			end
			if #relevant_category.slots == 0 then
				remove_category(item.category)
			end

			reselect()
		elseif count < existing_item.count then
			existing_item.count = existing_item.count - count
		else
			error("Attempted to remove more items than were in the inventory. ("..item.item_name..")")
		end
	else
		error("Attempted to remove an item that isn't in the inventory. ("..item.item_name..")")
	end
end

function game_menu.peek_item_count(item)
	local existing_item = item_lookup[item.item_name]

	return (existing_item and existing_item.count) or 0
end

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
		select_category(menu.cycle_previous(game_menu.categories, selected_category))
		SFX(15)
	end

	if btn_down(4) then
		select_category(menu.cycle_next(game_menu.categories, selected_category))
		SFX(15)
	end

	if btn_down(5) then
		active_category.slots[active_category.selected].object:select()
		SFX(16, 3)
	end

	if btn_down(6) or btn_down(7) then
		game_menu.close()
		SFX(19, 3)
	end
end

function main.draws.game_menu()
	clear()

	for i = 1, #game_menu.categories do
		local category = game_menu.categories[i]

		local y = (i - selected_category) * (SLOT_SIZE + SLOT_V_PADDING) + HH - SLOT_SIZE / 2

		--print(category.index, 3, y)

		for j = 1, #category.slots do
			local slot = category.slots[j]

			local x = (j - category.selected) * (SLOT_SIZE + SLOT_H_PADDING) + HW - SLOT_SIZE / 2

			--Outline
			if selected_category == i and category.selected == j then
				color(7)
			else
				color(5)
			end
			rect(x - 1, y - 1, SLOT_SIZE + 2, SLOT_SIZE + 2, true)

			--Sprite
			slot.object:draw(x, y)
			
			--Count
			if slot.count > 1 then
				color(0)
				rect(x + SLOT_COUNT_X - 1, y + SLOT_COUNT_Y - 1, SLOT_SIZE - SLOT_COUNT_X + 2, SLOT_SIZE - SLOT_COUNT_Y + 2)
				color(1)
				print(slot.count, x + SLOT_COUNT_X + 1, y + SLOT_COUNT_Y + 1)
				color(7)
				print(slot.count, x + SLOT_COUNT_X, y + SLOT_COUNT_Y)
			end
		end
	end

	--Debug
	--print(selected_category, 0, 0)
	--print(active_category.selected, 0, 8)


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