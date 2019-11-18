local sheetStartString = "___spritesheet___"

local file = HDD.read("D:/dungeon/dungeon.lk12")

local sheetStart = 1
local sheetEnd = 1

sheetStart = file:find(
 sheetStartString,sheetStart)+17

sheetEnd = file:find("___",sheetStart)-1

local sheetString = file:sub(sheetStart,sheetEnd-1)

print(sheetString:sub(1,20))
print(sheetStart)
print(sheetEnd)

--local sprSheetData = GPU.imagedata(sheetString)