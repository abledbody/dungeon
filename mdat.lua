local mdat = {}

local rooms = {}

rooms.entry = {
	--Actual room position and scale, used for room switching
	x = 54, y = 0,
	w = 12, h =11,

	--The chunk of tilemap revealed when the room is entered
	rx = 54, ry = 0,
	rw = 12, rh = 12,

	--The center of the room for camera positioning
	cx = 6, cy = 6,

	--Things and mobs have a class name, an x and y coordinate, and a table of data for spawning,
	--which works like   thatClass:new(unpack(thatTable))
	objects = {
		{"RobeStat", 5, 4, {}},
		{"Chest", 1, 1, {"health_flask"}},
		{"Chest", 2, 1, {"health_flask"}},
		{"Chest", 10, 1, {"speed_flask"}},
		{"Chest", 9, 1, {"speed_flask"}},
		{"Barrel", 10, 10, {"water_flask"}},
		{"Barrel", 10, 9, {"water_flask"}},
	}
}

rooms.entry_hall = {
	x = 58, y = 11,
	w = 4, h = 7,

	rx = 58, ry = 11,
	rw = 4, rh = 7,

	cx = 2, cy = 3,
	objects = {
		
	}
}

rooms.text = {
	x = 62,	y = 15,
	w = 8, h = 6,

	rx = 62, ry = 15,
	rw = 8, rh = 6,

	cx = 4, cy = 3,
	objects = {
		{"ExTile",1,0,{{"Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff.","It's been physically\nchiseled into the wall.","Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff."}}},
		{"Barrel", 6, 1, {"water_flask"}},
		{"Barrel", 5, 1, {"water_flask"}},
		{"Slime",6,4,{}},
	}
}

rooms.slime = {
	x = 44, y = 11,
	w = 14, h = 7,

	rx = 44, ry = 11,
	rw = 15, rh = 7,

	cx = 7, cy = 4,
	objects = {
		{"Chest", 6, 1, {"health_flask"}},
		{"Slime",7,2,{}},
		{"Slime",8,2,{}},
	}
}

rooms.lava_bridge = {
	x = 52, y = 18,
	w = 10, h = 13,

	rx = 52, ry = 18,
	rw = 10, rh = 13,

	cx = 5, cy = 7,
	objects  = {
		{"Slime",1,8,{}},
	},
}

rooms.lava_cave = {
	x = 44, y = 18,
	w = 8, h = 8,

	rx = 44, ry = 18,
	rw = 9, rh = 8,

	cx = 4, cy = 4,
	objects = {
		
	}
}

--Connections

local connections = {
	{"entry", "entry_hall"},
	{"entry_hall", "text"},
	{"entry_hall", "slime"},
	{"entry_hall", "lava_bridge"},
	{"slime", "lava_cave"},
	{"lava_bridge", "lava_cave"}
}

--Moving the connection data to the rooms themselves.

for k,v in ipairs(connections) do
	local room_a = v[1]
	local room_b = v[2]

	rooms[room_a].con = rooms[room_a].con or {}
	rooms[room_b].con = rooms[room_b].con or {}

	table.insert(rooms[room_a].con, room_b)
	table.insert(rooms[room_b].con, room_a)
end

mdat.rooms = rooms

return mdat