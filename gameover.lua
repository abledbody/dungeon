local rand = math.random

local game_over = {}

local exploded = false

local explode_timer = game.Timer:new()
local text_timer = game.Timer:new()

function game_over.trigger()
	game.setCamTarget(game.player.x+0.5, game.player.y+0.5)
	explode_timer:trigger(1)
	main.setState("game_over")
end

function main.updates.game_over(dt)
	game.darkness = math.min(game.darkness + game.fade_speed * dt, 3.99)
	game.camera_smoove(dt)

	if explode_timer:check() and not exploded then
		local player = game.player
		
		particleSys.clear()
		for i = 1, 15 do
			particleSys.newParticle(player.sx+4,player.sy+8,4,rand()*40-20,rand()*40-20,70,8,0,rand()+3)
		end

		SFX(8)
		
		text_timer:trigger(0.5)

		exploded = true
	end

	explode_timer:update(dt)
	text_timer:update(dt)
	particleSys.update(dt)
end

function main.draws.game_over()
	if not exploded then
		main.draws.game()
	end

	pushMatrix()
	game.camera_transform()

	brightness(0)

	if exploded then
		clear()
		particleSys.draw()
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

return game_over