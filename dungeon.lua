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
anim = dofile(PATH.."anim.lua")
--Extended math library
dofile(PATH.."amath.lua")


--== Load external files ==--

--Animation data
aData = dofile(PATH.."adat.lua")
--Game constants
const = dofile(PATH.."gameConsts.lua")

brightness = dofile(PATH.."brightness.lua")

--== Load game modules ==--

--These are all forward declarations of modules defined later,
--so Lua can refer to these tables without needing to know what's in them.
main = nil --General systems
game = nil --Gameplay-specific functionality
main_menu = nil
game_over = nil
game_menu = nil

menu = nil --All things menu UI related
diBox = nil --Dialogue box
gMap = nil --Game map
components = nil --Components for mobs and things
mobs = nil --Enemies, player, ect.
things = nil --Non-map objects within the game
items = nil
particleSys = nil --The particle system

main = dofile(PATH.."main.lua")
game = dofile(PATH.."game.lua")
main_menu = dofile(PATH.."mainmenu.lua")
game_over = dofile(PATH.."gameover.lua")
game_menu = dofile(PATH.."gamemenu.lua")

menu = dofile(PATH.."menu.lua")
diBox = dofile(PATH.."diBox.lua")
gMap = dofile(PATH.."map.lua")
components = dofile(PATH.."components.lua")
mobs = dofile(PATH.."mobs.lua")
things = dofile(PATH.."things.lua")
items = dofile(PATH.."items.lua")
particleSys = dofile(PATH.."particles.lua")


--== Start the program ==--

function _init()
	main.setState("main_menu")
	gMap.switchRoom("entry")
	mobs.spawn("Player", 59, 1)
	local flask = items.types.Flask:new():add(1)
end