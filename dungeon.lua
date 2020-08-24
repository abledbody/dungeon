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
dofile(PATH.."adat.lua")
--Game constants
dofile(PATH.."gameConsts.lua")

brightness = dofile(PATH.."brightness.lua")

--== Load game modules ==--

--States--
dofile(PATH.."main.lua")
dofile(PATH.."game.lua")
dofile(PATH.."throwselect.lua")
dofile(PATH.."mainmenu.lua")
dofile(PATH.."gameover.lua")
dofile(PATH.."gamemenu.lua")
dofile(PATH.."quitprompt.lua")

--Others--
dofile(PATH.."menu.lua")
dofile(PATH.."diBox.lua")
dofile(PATH.."map.lua")
dofile(PATH.."components.lua")
dofile(PATH.."mobs.lua")
dofile(PATH.."things.lua")
dofile(PATH.."items.lua")
dofile(PATH.."particles.lua")


--== Start the program ==--

function _init()
	main.set_state(main_menu)
	game_map.switchRoom("entry")
	mobs.spawn("Player", 59, 1, nil, "entry")
	items.types.water_flask:add(20)
end