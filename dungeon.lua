--Dungeon game by abledbody 2019

--Apply the custom Rayleigh palette
dofile("D:/dungeon/Rayleigh.lua")

--== Load third-party libraries ==--

--Middleclass library
class = Library("class")

--== Load external libraries ==--

--Animation system
anim = dofile("D:/dungeon/anim.lua")
--Extended math library
dofile("D:/dungeon/amath.lua")


--== Load external files ==--

--Animation data
aData = dofile("D:/dungeon/adat.lua")
--Game constants
const = dofile("D:/dungeon/gameConsts.lua")


--== Localize some variables ==--

--math
local min, max, abs, sin = math.min, math.max, math.abs, math.sin
--amath extensions
local round = math.round

--Constants
local HSW,HSH = const.HSW,const.HSH
local DIRX,DIRY = const.DIRX,const.DIRY

---------------General----------------


--Modules--
--These are all forward declarations of modules defined later,
--so Lua can refer to these tables without needing to know what's in them.
main = nil --General systems
game = nil --Gameplay-specific functionality
diBox = nil --Dialogue box
gMap = nil --Game map
mobs = nil --Enemies, player, ect.
things = nil --Non-map objects within the game

main = dofile("D:/dungeon/main.lua")
game = dofile("D:/dungeon/game.lua")
diBox = dofile("D:/dungeon/diBox.lua")
gMap = dofile("D:/dungeon/map.lua")
mobs = dofile("D:/dungeon/mobs.lua")
things = dofile("D:/dungeon/things.lua")


---------------Program----------------


function _init()
	main.setState("game")
	gMap.switchRoom(1)
	game.spawnPlayer(59,1)
end