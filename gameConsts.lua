	--Constants--
local SW,SH = screenSize()
local HSW,HSH = SW/2,SH/2
local DIRX = {-1,1,0,0}
local DIRY = {0,0,-1,1}

	--Module--
local const = {}

const.SW,const.SH = SW,SH
const.HSW,const.HSH = HSW,HSH
const.DIRX,const.DIRY = DIRX,DIRY

return const