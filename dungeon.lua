--Dungeon game by abledbody, 2019


--Define PATH (Used for loading)
PATH = ("D:/dungeon/")
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

--== Load game modules ==--

--These are all forward declarations of modules defined later,
--so Lua can refer to these tables without needing to know what's in them.
main = nil --General systems
game = nil --Gameplay-specific functionality
diBox = nil --Dialogue box
gMap = nil --Game map
mapEnts = nil --Entities in the game
mobs = nil --Enemies, player, ect.
things = nil --Non-map objects within the game

main = dofile(PATH.."main.lua")
game = dofile(PATH.."game.lua")
diBox = dofile(PATH.."diBox.lua")
gMap = dofile(PATH.."map.lua")
mapEnts = dofile(PATH.."mapEntities.lua")
mobs = dofile(PATH.."mobs.lua")
things = dofile(PATH.."things.lua")


--== Start the program ==--

function _init()
	main.setState("game")
	gMap.switchRoom(1)
	game.spawnPlayer(59,1)
end