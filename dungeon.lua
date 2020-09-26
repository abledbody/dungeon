--Dungeon game by abledbody, 2019


--Define PATH (Used for loading)
PATH = "D:/dungeon/"

--Apply the custom Rayleigh palette
dofile(PATH.."Rayleigh.lua")

--== Load third-party libraries ==--

--Middleclass library
class = Library("class")

--== Load external libraries ==--

--Animation system
dofile(PATH.."anim.lua")
--Extended math library
dofile(PATH.."amath.lua")


--== Load external files ==--

--Animation data
dofile(PATH.."a_data.lua")
--Game constants
dofile(PATH.."const.lua")

brightness = dofile(PATH.."brightness.lua")

--== Load game modules ==--

--States--
dofile(PATH.."main.lua")
dofile(PATH.."game.lua")
dofile(PATH.."throw_select.lua")
dofile(PATH.."main_menu.lua")
dofile(PATH.."game_over.lua")
dofile(PATH.."game_menu.lua")
dofile(PATH.."quit_prompt.lua")

--Others--
dofile(PATH.."menu.lua")
dofile(PATH.."di_box.lua")
dofile(PATH.."map.lua")
dofile(PATH.."components.lua")
dofile(PATH.."objects.lua")
dofile(PATH.."items.lua")
dofile(PATH.."particles.lua")


--== Start the program ==--

function _init()
	main.set_state(main_menu)
	game_map.switchRoom("entry")
	objects.spawn("Player", 59, 1, nil, "entry")
	items.types.water_flask:add(20)
end