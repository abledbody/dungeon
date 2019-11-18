local mdat = {}

local rooms = {}

local r = {}

--Entry--

r.x,r.y = 54,0
r.w,r.h = 12,11

r.rx,r.ry = 54,0
r.rw,r.rh = 12,12

r.cx,r.cy = 6,6

r.con = {2}
r.things = {
 {"RobeStat",5,4,{}}
}
r.mobs = {}

rooms[1] = r

--EntryHall--

r = {}
r.x,r.y = 58,11
r.w,r.h = 4,7

r.rx,r.ry = 58,11
r.rw,r.rh = 4,7

r.cx,r.cy = 2,3
r.con = {1,3,4,5}
r.things = {}
r.mobs = {}

rooms[2] = r

--Text room--

r = {}
r.x,r.y = 62,15
r.w,r.h = 8,6

r.rx,r.ry = 62,15
r.rw,r.rh = 8,6

r.cx,r.cy = 4,3
r.con = {2}
r.things = {
 {"ExTile",1,0,{{"Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff.","It's been physically\nchiseled into the wall.","Note to Joffrey: Please do not let\nthe slimes roam the dungeon. They\nneed to be kept in the traps where\nthey will not attack the staff."}}}
}
r.mobs = {}

rooms[3] = r

--Slime room--

r = {}
r.x,r.y = 44,11
r.w,r.h = 14,7

r.rx,r.ry = 44,11
r.rw,r.rh = 15,7

r.cx,r.cy = 7,4
r.con = {2,6}
r.things = {}
r.mobs = {
 {"Slime",7,2,{}}
}

rooms[4] = r

mdat.rooms = rooms

--Lava bridge--

r = {}
r.x,r.y = 52,18
r.w,r.h = 10,13

r.rx,r.ry = 52,18
r.rw,r.rh = 10,13

r.cx,r.cy = 5,7
r.con = {2,6}
r.things = {}
r.mobs = {}

rooms[5] = r

--Lava cave--

r = {}
r.x,r.y = 44,18
r.w,r.h = 8,8

r.rx,r.ry = 44,18
r.rw,r.rh = 9,8

r.cx,r.cy = 4,4
r.con = {4,5}
r.things = {}
r.mobs = {}

rooms[6] = r

mdat.rooms = rooms

return mdat