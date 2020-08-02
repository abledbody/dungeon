local rand = math.random

local OPTIONS = {
	{
		name = "Start",
		select = function()
			main.setState("game")
			SFX(10,3)
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
local DRIP_GRAVITY = 200
local SPLASH_RATE = 24
local FLOOR_HEIGHT = screenHeight() - 32
local FLOOR_ASPECT = 0.4


local main_menu = {}


local selected = 1

local drips = {}

function new_drip(x,y)
	local drip = {
		x=x,
		y=y,
		y_vel = 0,
		splash_radius = 0,
		fall_time = 0,
	}

	table.insert(drips, drip)
end

function update_drips(dt)
	for k,drip in pairs(drips) do

		if drip.falling then
			drip.y = drip.y + drip.y_vel * dt
			if drip.y > FLOOR_HEIGHT then
				drip.falling = false
				drip.splashed = true
				SFX(17, 2)
			else
				drip.y_vel = drip.y_vel + DRIP_GRAVITY * dt
			end
		else
			if drip.splashed then
				drip.splash_radius = drip.splash_radius + dt * SPLASH_RATE
				if drip.splash_radius >= 13 then
					table.remove(drips, k)
				end
			else
				if drip.fall_time > 1 then
					drip.falling = true
					drip.y = drip.y + 3
					drip.forming = false
				else
					if drip.fall_time > 0.5 then
						drip.forming = true
					end
					drip.fall_time = drip.fall_time + dt
				end
			end
		end
	end
end

function draw_drips()
	for _,drip in pairs(drips) do
		if drip.forming then
			Sprite(295, drip.x-1, drip.y)
		elseif drip.splashed then
			color(5)
			local splash_radius = drip.splash_radius
			if splash_radius > 5 then
				ellipse(drip.x, drip.y, splash_radius - 5, (splash_radius - 5) * FLOOR_ASPECT, true)
			end
			if splash_radius < 8 then
				ellipse(drip.x, drip.y, splash_radius, splash_radius * FLOOR_ASPECT, true)
			end
		else
			color(7)
			point(drip.x, drip.y)
		end
	end
end

function main.updates.main_menu(dt)
	if btn_down(5) then
		OPTIONS[selected].select()
	end

	if btn_down(3) then
		selected = menu.cycle_previous(OPTIONS, selected)
		SFX(15)
	end

	if btn_down(4) then
		selected = menu.cycle_next(OPTIONS, selected)
		SFX(15)
	end

	menu.update_cursor(dt)
	
	--Water drips

	if rand(0,1/dt) == 0 then
		new_drip(rand(TITLE_X, TITLE_X + 48), TITLE_Y + 8)
	end

	update_drips(dt)
end

function main.draws.main_menu()
	clear()

	SpriteGroup(289, TITLE_X, TITLE_Y, 6, 1)

	draw_drips()

	color(1)
	rect(OPTIONS_X - 2, OPTIONS_Y - 2, OPTIONS_WIDTH, #OPTIONS * 8 + 2)

	for i = 1, #OPTIONS do
		local option = OPTIONS[i]
		color(7)
		print(option.name, OPTIONS_X, OPTIONS_Y + (i - 1)*8)
	end

	menu.draw_cursor(OPTIONS_X, OPTIONS_Y + (selected - 1)*8 - 1)
end

return main_menu