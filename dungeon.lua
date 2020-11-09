--Dungeon game by abledbody, 2019


--Define PATH (Used for loading)
PATH = "D:/dungeon/"
local STATE_PATH = PATH.."States/"

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

dofile(PATH.."main.lua")

--States--
dofile(STATE_PATH.."di_box.lua")
dofile(STATE_PATH.."game.lua")
dofile(STATE_PATH.."throw_select.lua")
dofile(STATE_PATH.."main_menu.lua")
dofile(STATE_PATH.."game_over.lua")
dofile(STATE_PATH.."game_menu.lua")
dofile(STATE_PATH.."quit_prompt.lua")

--Others--
dofile(PATH.."menu.lua")
dofile(PATH.."map.lua")
dofile(PATH.."components.lua")
dofile(PATH.."objects.lua")
dofile(PATH.."items.lua")
dofile(PATH.."particles.lua")


--== Start the program ==--

function _init()
	main.set_state(main_menu)
end