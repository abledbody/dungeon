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
		{"RobeStat", 59, 4, {}},
		{"Chest", 55, 1, {"health_flask", }},
		{"Chest", 56, 1, {"health_flask", }},
		{"Chest", 64, 1, {"speed_flask", }},
		{"Chest", 63, 1, {"speed_flask", }},
		{"Barrel", 64, 10, {"water_flask", }},
		{"Barrel", 64, 9, {"water_flask", }},
	}
}

rooms.entry_hall = {
	next = "slime",

	x1 = 58, y1 = 11,
	x2 = 62, y2 = 18,

	rx1 = 58, ry1 = 11,
	rx2 = 62, ry2 = 18,

	cx = 60, cy = 14,

	 objects = {
		{"Skull", 59, 14, {}},
	}
}

rooms.slime = {
	next = "text",

	x1 = 44, y1 = 11,
	x2 = 58, y2 = 18,

	rx1 = 44, ry1 = 11,
	rx2 = 59, ry2 = 18,

	cx = 51, cy = 15,

	 objects = {
		{"Chest", 50, 12, {"health_flask", }},
		{"Slime", 51, 13, {}},
		{"Slime", 52, 13, {}},
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
		{"Barrel", 67, 16, {"water_flask", }},
		{"Slime", 68, 19, {}},
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
	next = "lavapool",

	x1 = 44, y1 = 18,
	x2 = 52, y2 = 26,

	rx1 = 44, ry1 = 18,
	rx2 = 53, ry2 = 26,

	cx = 48, cy = 22,

	 objects = {
	}
}

rooms.lavapool = {
	next = "emptylavaroom",

	x1 = 62, y1 = 25,
	x2 = 72, y2 = 35,

	rx1 = 61, ry1 = 25,
	rx2 = 72, ry2 = 36,

	cx = 67, cy = 30,

	 objects = {
	}
}

rooms.emptylavaroom = {
	next = "greentransition",

	x1 = 61, y1 = 35,
	x2 = 72, y2 = 44,

	rx1 = 61, ry1 = 35,
	rx2 = 72, ry2 = 44,

	cx = 66, cy = 39,

	 objects = {
	}
}

rooms.greentransition = {
	next = "greenroom",

	x1 = 70, y1 = 18,
	x2 = 81, y2 = 23,

	rx1 = 69, ry1 = 18,
	rx2 = 81, ry2 = 24,

	cx = 75, cy = 20,

	 objects = {
	}
}

rooms.greenroom = {
	next = nil,

	x1 = 72, y1 = 23,
	x2 = 78, y2 = 34,

	rx1 = 71, ry1 = 23,
	rx2 = 78, ry2 = 34,

	cx = 75, cy = 28,

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
	{"lava_bridge", "lava_cave"},
	{"text", "greentransition"},
	{"lavapool", "emptylavaroom"},
	{"lavapool", "lava_bridge"},
	{"lavapool", "greenroom"},
	{"greentransition", "greenroom"},
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