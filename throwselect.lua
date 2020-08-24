local tau = math.pi * 2
local DIR_X = const.DIR_X

throw_select = {}

local direction = 3

function throw_select.init()
    game.player:flipCheck(DIR_X[direction])
    game.player.animator:setState("throw")
end

function throw_select.update(dt)
    for i = 1, 4 do
        if btn(i) then
            if direction ~= i then
                SFX(15, 3)
            end
            direction = i
            game.player:flipCheck(DIR_X[i])
            break
        end
    end


    if btn_down(5) then
        main.set_state(game)
        SFX(20, 1)
        game.player:throw(direction, throw_select.item)
	end
	
	if btn_down(6) then
		main.set_state(game)
		SFX(23, 1)
		game.player.animator:setState("idle")
	end
end

local pointer_offset_lookup = {
    x = {   -1, 2,  0,  1},
    y = {   1,  0,  -1, 2},
    rot = {-tau/4, tau/4, 0,  tau/2}
}

function throw_select.draw()
     game.draw()

     pushMatrix()
     game.camera_transform()

     local offset_x = pointer_offset_lookup.x[direction] * 8
     local offset_y = pointer_offset_lookup.y[direction] * 8
     local rot = pointer_offset_lookup.rot[direction]

     Sprite(362, game.player.sx + offset_x, game.player.sy + offset_y, rot)
     popMatrix()
end