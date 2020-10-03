local mdat = {}

local rooms = {}

rooms.entry = {
	--Actual room position and scale, used for room switching
	x1 = 54,	y1 = 0,
	x2 = 66,	y2 = 11,

	--The chunk of tilemap revealed when the room is entered
	rx1 = 54,	ry1 = 0,
	rx2 = 66,	ry2 = 12,

	--The center of the room for camera positioning
	cx = 60,	cy = 6,

	--Things and mobs have a class name, an x and y coordinate, and a table of data for spawning,
	--which works like   thatClass:new(unpack(thatTable))
	objects = {
		{"RobeStat",	59,	4,	{}},
		{"Chest",		55,	1,	{"health_flask"}},
		{"Chest",		56,	1,	{"health_flask"}},
		{"Chest",		64,	1,	{"speed_flask"}},
		{"Chest",		63,	1,	{"speed_flask"}},
		{"Barrel",		64,	10,	{"water_flask"}},
		{"Barrel",		64,	9,	{"water_flask"}},
	}
}

rooms.entry_hall = {
	x1 = 58,	y1 = 11,
	x2 = 62,	y2 = 18,

	rx1 = 58,	ry1 = 11,
	rx2 = 62,	ry2 = 18,

	cx = 60,	cy = 14,
	objects = {
		
	}
}

rooms.text = {
	x1 = 62,	y1 = 15,
	x2 = 70,	y2 = 21,

	rx1 = 62,	ry1 = 15,
	rx2 = 70,	ry2 = 21,

	cx = 66,	cy = 18,
	objects = {
		{"ExTile",	63,	15,	{{"Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff.","It's been physically\nchiseled into the wall.","Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff."}}},
		{"Barrel",	68,	16,	{"water_flask"}},
		{"Barrel",	67,	16,	{"water_flask"}},
		{"Slime",	68,	19,	{}},
	}
}

rooms.slime = {
	x1 = 44,	y1 = 11,
	x2 = 58,	y2 = 18,

	rx1 = 44,	ry1 = 11,
	rx2 = 59,	ry2 = 18,

	cx = 51,	cy = 15,
	objects = {
		{"Chest",	50,	12,	{"health_flask"}},
		{"Slime",	51,	13,	{}},
		{"Slime",	52,	13,	{}},
	}
}

rooms.lava_bridge = {
	x1 = 52,	y1 = 18,
	x2 = 62,	y2 = 31,

	rx1 = 52,	ry1 = 18,
	rx2 = 62,	ry2 = 31,

	cx = 57,	cy = 25,
	objects  = {
		{"Slime",	53,	26,	{}},
	},
}

rooms.lava_cave = {
	x1 = 44,	y1 = 18,
	x2 = 52,	y2 = 26,

	rx1 = 44,	ry1 = 18,
	rx2 = 53,	ry2 = 26,

	cx = 48,	cy = 22,
	objects = {
		
	}
}

--Connections

mdat.connections = {
	{"entry", "entry_hall"},
	{"entry_hall", "text"},
	{"entry_hall", "slime"},
	{"entry_hall", "lava_bridge"},
	{"slime", "lava_cave"},
	{"lava_bridge", "lava_cave"}
}

--Moving the connection data to the rooms themselves.

for _, v in ipairs(mdat.connections) do
	local room_a = v[1]
	local room_b = v[2]

	rooms[room_a].con = rooms[room_a].con or {}
	rooms[room_b].con = rooms[room_b].con or {}

	table.insert(rooms[room_a].con, room_b)
	table.insert(rooms[room_b].con, room_a)
end

mdat.rooms = rooms

return mdat