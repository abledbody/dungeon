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

function math.between(val,min,max)
	return val >= min and val <= max
end

function math.lerp(a,b,x)
	return (b-a)*x+a
end