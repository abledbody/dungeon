local rand = math.random

game_over = {}

local exploded = false
local made_sound = false

local explode_timer = game.Timer:new()
local text_timer = game.Timer:new()

function game_over.trigger()
	game.setCamTarget(game.player.x+0.5, game.player.y+0.5)
	explode_timer:trigger(1)
	main.set_state(game_over)
end

function game_over.update(dt)
	game.darkness = math.min(game.darkness + game.fade_speed * dt, 3.99)
	game.camera_smoove(dt)

	if exploded and text_timer:check() and btn_down(7) then
		main.set_state(main_menu)
	end

	if explode_timer:check() and not exploded then
		local player = game.player
		
		particle_sys.clear()
		for i = 1, 15 do
			particle_sys.newParticle(player.sx+4,player.sy+8,4,rand()*40-20,rand()*40-20,70,8,0,rand()+3)
		end

		SFX(8)
		
		text_timer:trigger(0.5)

		exploded = true
	end

	if exploded and text_timer:check() and not made_sound then
		SFX(4)
		SFX(5,1)
		made_sound = true
	end

	explode_timer:update(dt)
	text_timer:update(dt)

	particle_sys.update(dt)
end

function game_over.draw()
	if not exploded then
		game.draw()
	end

	pushMatrix()
	game.camera_transform()

	brightness(0)

	if exploded then
		clear()
		particle_sys.draw()
		if text_timer:check() then
			color(7)
			pushMatrix()
			cam()
			print("Game Over", screenWidth()/2-22, screenHeight()/2-24)
			popMatrix()
		end
	else
		game.player:draw()
	end

	popMatrix()
end