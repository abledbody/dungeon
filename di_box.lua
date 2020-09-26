local max,min = math.max,math.min
local HSW,HSH = const.HSW,const.HSH

di_box = {}

	--Parameters--
local boxTime = 1/20 --Should open in a 20th of a second.

	--Variables--
local size = 0
local targetSize = 6
--Box vertical size increment in pixels per second
local boxSpeed = 1
local boxWidth = 200
local message = {}

	--Functions--
--Returns an array of strings split up by newlines.
local function lineSplit(text)
	local lns = {}
	
	if text:sub(-1)~="\n" then
		text=text.."\n"
	end
	
	for s in text:gmatch("(.-)\n") do
		table.insert(lns,s)
	end
	
	return lns
end

--Gets the width of the widest string in an array
local function textWidth(lns)
	local lnsCount = #lns
	local lineLens = {}
	
	for i = 1, lnsCount do
		lineLens[i] = lns[i]:len()
	end
	
	return max(unpack(lineLens))
end

function di_box.set_text(text)
	size = 0
	message = lineSplit(text)
	boxWidth = textWidth(message)
	
	--Text characters are 4*6, with spaces of 1 pixel
	targetSize = #message*7-1
	boxWidth = boxWidth*5-1
	boxSpeed = targetSize/boxTime
end

--Dialogue box trigger
function di_box.show(text)
	game.draw()
	--We keep a screenshot of the game to display behind the text box.
	game.screenshot()
	main.set_state(di_box)
	
	SFX(9)
	
	di_box.set_text(text)
end

function di_box.widen(dt)
	size = min(size+dt*boxSpeed,targetSize)
end

function di_box.draw_box()
	local x = HSW+0.5-boxWidth/2
	local y = HSH+0.5-size/2
	
	color(13)
	rect(x-2,y-2,boxWidth+4,size+4)
	color(0)
	rect(x-1,y-1,boxWidth+2,size+2)

	if size >= targetSize then
		color(7)
		for i = 1, #message do
			local ln = message[i]
			local tw = ln:len()*5-1
			print(ln,HSW+0.5-tw/2,y+(i-1)*7)
		end
	end
end

	--States--
function di_box.update(dt)
	di_box.widen(dt)

	if btn_down(5) then
		main.set_state(game)
	end
end

function di_box.draw()
	clear()
	
	game.scrImage:draw()
	
	di_box.draw_box()
end