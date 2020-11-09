local exit = setmetatable({}, items.item_base)
exit.__index = exit

exit.category = "system"
exit.item_name = "Exit"

function exit:draw(x, y)
	Sprite(315, x, y)
end

function exit:select()
	main.set_state(quit_prompt)
end

return exit