local levels = {
	{
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 1,
		[4] = 2,
		[5] = 1,
		[6] = 5,
		[7] = 6,
		[8] = 2,
		[9] = 4,
		[10] = 9,
		[11] = 3,
		[12] = 13,
		[13] = 1,
		[14] = 8,
		[15] = 4,
	},
	{
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 2,
		[5] = 1,
		[6] = 1,
		[7] = 5,
		[8] = 2,
		[9] = 2,
		[10] = 2,
		[11] = 1,
		[12] = 1,
		[13] = 1,
		[14] = 2,
		[15] = 2,
	}
}

return function(value)
	value = math.floor(value)
	if value == 0 then
		return pal()
	end
	if value == 3 then
		for i = 0, 15 do
			pal(i, 0)
		end
		return
	end
	
	local set = levels[value]
	for i = 0, #set do
		pal(i, set[i])
	end
end