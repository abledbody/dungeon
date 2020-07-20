--Dungeon game by abledbody, 2019


--Define PATH (Used for loading)
PATH = "D:/dungeon/"
COMPONENT_PATH = PATH.."Components/"

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
mobs = nil --Enemies, player, ect.
things = nil --Non-map objects within the game
particleSys = nil --The particle system

main = dofile(PATH.."main.lua")
game = dofile(PATH.."game.lua")
diBox = dofile(PATH.."diBox.lua")
gMap = dofile(PATH.."map.lua")
mobs = dofile(PATH.."mobs.lua")
things = dofile(PATH.."things.lua")
particleSys = dofile(PATH.."particles.lua")


--== Start the program ==--

function _init()
	main.setState("game")
	gMap.switchRoom("entry")
	game.spawnPlayer(59,1)
end