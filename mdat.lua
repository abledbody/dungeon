local mdat = {}
local rooms = {}
mdat.initial_room = "entry"

rooms.entry = {
	next = "entry_hall",

	x1 = 54, y1 = 0,
	x2 = 66, y2 = 11,

	rx1 = 54, ry1 = 0,
	rx2 = 66, ry2 = 12,

	cx = 60, cy = 6,

	 objects = {
		{"Chest", 58, 1, {"health_flask", }},
		{"Chest", 61, 1, {"health_flask", }},
		{"Barrel", 64, 10, {"water_flask", }},
		{"Barrel", 64, 9, {"water_flask", }},
		{"RobeStat", 59, 4, {}},
	}
}

rooms.entry_hall = {
	next = "table",

	x1 = 58, y1 = 11,
	x2 = 62, y2 = 18,

	rx1 = 58, ry1 = 11,
	rx2 = 62, ry2 = 18,

	cx = 60, cy = 14,

	 objects = {
	}
}

rooms.table = {
	next = "text",

	x1 = 44, y1 = 11,
	x2 = 58, y2 = 18,

	rx1 = 44, ry1 = 11,
	rx2 = 59, ry2 = 18,

	cx = 51, cy = 14,

	 objects = {
		{"Chest", 52, 12, {"health_flask", }},
		{"Table", 50, 12, {}},
		{"Slime", 57, 16, {}},
		{"Slime", 53, 12, {}},
		{"DTile", 51, 11, {}},
	}
}

rooms.text = {
	next = "lava_bridge",

	x1 = 62, y1 = 15,
	x2 = 70, y2 = 21,

	rx1 = 62, ry1 = 15,
	rx2 = 70, ry2 = 21,

	cx = 66, cy = 18,

	 objects = {
		{"ExTile", 63, 15, {{"Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff.", "It's been physically\nchiseled into the wall.", "Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff.", }}},
		{"Barrel", 68, 16, {"water_flask", }},
		{"Slime", 68, 19, {}},
		{"Barrel", 67, 16, {"water_flask", }},
	}
}

rooms.lava_bridge = {
	next = "lava_cave",

	x1 = 52, y1 = 18,
	x2 = 62, y2 = 31,

	rx1 = 52, ry1 = 18,
	rx2 = 62, ry2 = 31,

	cx = 57, cy = 25,

	 objects = {
		{"Slime", 53, 26, {}},
	}
}

rooms.lava_cave = {
	next = "lava_pool",

	x1 = 44, y1 = 18,
	x2 = 52, y2 = 26,

	rx1 = 44, ry1 = 18,
	rx2 = 53, ry2 = 26,

	cx = 48, cy = 22,

	 objects = {
	}
}

rooms.lava_pool = {
	next = "empty_lava",

	x1 = 62, y1 = 25,
	x2 = 71, y2 = 35,

	rx1 = 61, ry1 = 25,
	rx2 = 72, ry2 = 36,

	cx = 66, cy = 30,

	 objects = {
	}
}

rooms.empty_lava = {
	next = "green_transition",

	x1 = 61, y1 = 35,
	x2 = 72, y2 = 44,

	rx1 = 61, ry1 = 35,
	rx2 = 72, ry2 = 44,

	cx = 66, cy = 39,

	 objects = {
		{"Skull", 64, 42, {}},
		{"Chest", 66, 39, {"speed_flask", }},
	}
}

rooms.green_transition = {
	next = "green_room",

	x1 = 70, y1 = 18,
	x2 = 81, y2 = 23,

	rx1 = 69, ry1 = 18,
	rx2 = 81, ry2 = 24,

	cx = 75, cy = 20,

	 objects = {
	}
}

rooms.green_room = {
	next = "first_secret_cave",

	x1 = 71, y1 = 23,
	x2 = 78, y2 = 34,

	rx1 = 71, ry1 = 23,
	rx2 = 78, ry2 = 34,

	cx = 74, cy = 28,

	 objects = {
	}
}

rooms.first_secret_cave = {
	next = nil,

	x1 = 46, y1 = 5,
	x2 = 54, y2 = 11,

	rx1 = 46, ry1 = 5,
	rx2 = 55, ry2 = 12,

	cx = 50, cy = 8,

	 objects = {
		{"Chest", 49, 7, {"speed_flask", }},
	}
}

--Connections
mdat.connections = {
	{"entry", "entry_hall"},
	{"entry_hall", "text"},
	{"entry_hall", "table"},
	{"entry_hall", "lava_bridge"},
	{"table", "lava_cave"},
	{"lava_bridge", "lava_cave"},
	{"text", "green_transition"},
	{"lava_pool", "empty_lava"},
	{"lava_pool", "lava_bridge"},
	{"lava_pool", "green_room"},
	{"green_transition", "green_room"},
	{"first_secret_cave", "table"},
}

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