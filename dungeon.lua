--Dungeon game by abledbody, 2019


--Define path (Used for loading)
path = ("D:/dungeon/")
--Apply the custom Rayleigh palette
dofile(path.."Rayleigh.lua")

--== Load third-party libraries ==--

--Middleclass library
class = Library("class")

--== Load external libraries ==--

--Animation system
anim = dofile(path.."anim.lua")
--Extended math library
dofile(path.."amath.lua")


--== Load external files ==--

--Animation data
aData = dofile(path.."adat.lua")
--Game constants
const = dofile(path.."gameConsts.lua")

--== Load game modules ==--

--These are all forward declarations of modules defined later,
--so Lua can refer to these tables without needing to know what's in them.
main = nil --General systems
game = nil --Gameplay-specific functionality
diBox = nil --Dialogue box
gMap = nil --Game map
mobs = nil --Enemies, player, ect.
things = nil --Non-map objects within the game

main = dofile(path.."main.lua")
game = dofile(path.."game.lua")
diBox = dofile(path.."diBox.lua")
gMap = dofile(path.."map.lua")
mobs = dofile(path.."mobs.lua")
things = dofile(path.."things.lua")


--== Start the program ==--

function _init()
	main.setState("game")
	gMap.switchRoom(1)
	game.spawnPlayer(59,1)
end