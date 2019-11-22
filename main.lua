--Variables--
local updates = {}
local draws = {}

--Functions--
--Just to change _update and _draw in the same line
local function setState(state)
	_update = updates[state]
	_draw = draws[state]
end

--Module--
local main = {}

main.updates = updates
main.draws = draws

main.setState = setState

return main