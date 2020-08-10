local tau = math.pi * 2
local DIRX = const.DIRX

local throw_select = {}

local direction = 3

function main.inits.throw_select()
    game.player:flipCheck(DIRX[direction])
    game.player.animator:setState("throw")
end

function main.updates.throw_select(dt)
    for i = 1, 4 do
        if btn(i) then
            if direction ~= i then
                SFX(15, 3)
            end
            direction = i
            game.player:flipCheck(DIRX[i])
            break
        end
    end


    if btn_down(5) then
        main.setState("game")
        SFX(20, 1)
        game.player:throw(direction, throw_select.item)
	end
	
	if btn_down(6) then
		main.setState("game")
		SFX(23, 1)
		game.player.animator:setState("idle")
	end
end

local pointer_offset_lookup = {
    x = {   -1, 2,  0,  1},
    y = {   1,  0,  -1, 2},
    rot = {-tau/4, tau/4, 0,  tau/2}
}

function main.draws.throw_select()
     main.draws.game()

     pushMatrix()
     game.camera_transform()

     local offset_x = pointer_offset_lookup.x[direction] * 8
     local offset_y = pointer_offset_lookup.y[direction] * 8
     local rot = pointer_offset_lookup.rot[direction]

     Sprite(362, game.player.sx + offset_x, game.player.sy + offset_y, rot)
     popMatrix()
end

return throw_select