--Animation Data
--This file stores the timing and sprite data for each kind of animation

local aData = {}

	--Timings--
local timings = {}
timings.twoIdle =	{0.5,	0.5}

--Slime
aData.slime = {
	idle = {
		spr = {202,203},
		timing = timings.twoIdle
    },
    
	attack = {
		spr = 		{203,	202,	204,	203},
		offX = 		{0,		1,		2,		1},
		timing = 	{0.08,	0.06,	0.11,	0.06}
	},
}

return aData