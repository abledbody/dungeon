math.tau = 6.2831853071796

local math_min, math_max = math.min, math.max

function math.clamp(value, min, max)
	return math_min(math_max(value, min), max)
end

function math.round(value)
	--Surprisingly simple.
	return math.floor(value+0.5)
end

function math.sign(value)
	--Nested ternary.
	return value > 0 and 1 or
		value < 0 and -1 or 0
end

--Short for "better atan2",
--because Lua's atan2 is offset by
--90 degrees from cos and sin,
--AND BACKWARDS.
--Are you freaking kidding me?!
function math.bat(x,y)
	return (-math.atan2(x,y)+math.pi/2)%math.tau
end

function math.between(val,min,max)
	return val >= min and val <= max
end

function math.lerp(a,b,x)
	return (b-a)*x+a
end