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
	things = {
		{"RobeStat",5,4,{}}
	},
	mobs = {

	},
}

rooms.entryHall = {
	x = 58, y = 11,
	w = 4, h = 7,

	rx = 58, ry = 11,
	rw = 4, rh = 7,

	cx = 2, cy = 3,
	things = {

	},
	mobs = {

	},
}

rooms.text = {
	x = 62,	y = 15,
	w = 8, h = 6,

	rx = 62, ry = 15,
	rw = 8, rh = 6,

	cx = 4, cy = 3,
	things = {
		{"ExTile",1,0,{{"Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff.","It's been physically\nchiseled into the wall.","Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff."}}}
	},
	mobs = {
		{"Slime",6,4,{}},
	},
}

rooms.slime = {
	x = 44, y = 11,
	w = 14, h = 7,

	rx = 44, ry = 11,
	rw = 15, rh = 7,

	cx = 7, cy = 4,
	things = {
		{"Chest", 6, 1, {"flask"}}
	},
	mobs = {
		{"Slime",7,2,{}},
		{"Slime",8,2,{}},
	},
}

rooms.lavaBridge = {
	x = 52, y = 18,
	w = 10, h = 13,

	rx = 52, ry = 18,
	rw = 10, rh = 13,

	cx = 5, cy = 7,
	things = {

	},
	mobs = {
		{"Slime",1,8,{}},
	},
}

rooms.lavaCave = {
	x = 44, y = 18,
	w = 8, h = 8,

	rx = 44, ry = 18,
	rw = 9, rh = 8,

	cx = 4, cy = 4,
	things = {

	},
	mobs = {
		
	},
}

--Connections

local connections = {
	{"entry", "entryHall"},
	{"entryHall", "text"},
	{"entryHall", "slime"},
	{"entryHall", "lavaBridge"},
	{"slime", "lavaCave"},
	{"lavaBridge", "lavaCave"}
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