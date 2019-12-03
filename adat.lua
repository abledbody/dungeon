--Animation Data
--This file stores the timing and sprite data for each kind of animation

local aData = {}

	--Timings--
local timings = {}
--Used for player idle animation
timings.bob =		{0.6,	0.06,	0.6,	0.06}
--Used for player strike animation
timings.strike =	{0.07,	0.08,	0.2}
timings.twoIdle =	{0.5,	0.5}

	--Frames data--
--Player
aData.player = {
    --Default player state
    idle = {
        spr = 	{193,	194,	195,	196},
        timing = timings.bob
    },
    
    --Attack state, when the spear is used
    attack = {
        spr = 	{197,	198,	199},
        offX = 	{-1,	2,		0},
        timing = timings.strike
    },
}

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