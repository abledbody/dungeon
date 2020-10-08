local floor = math.floor

local roomedit_sheet_file = HDD.read(ROOMEDIT_PATH .. "roomedit_sheet.lk12")

local function get_sheet(file)
	local start = file:find("LK12;GPUIMG;")
    local stop = file:find("___sfx___") or file:len()

    local ss_data = file:sub(start, stop)

    return GPU.imagedata(ss_data)
end

local spr_sheets = {
	get_sheet(dungeon):image(),
	get_sheet(roomedit_sheet_file):image(),
}


f = {}

function f.Sprite(id, x, y, sheet_index)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, 8, 8, 192, 128)
    spr_sheets[sheet_index or 1]:draw(x, y, 0, 1, 1, q)
end

function f.SpriteGroup(id, w, h, x, y, sheet_index)
    id = id - 1
    local quad_x = floor(id) % 24 * 8
    local quad_y = floor(id / 24) * 8
    local q = GPU.quad(quad_x, quad_y, w * 8, h * 8, 192, 128)
    spr_sheets[sheet_index or 1]:draw(x, y, 0, 1, 1, q)
end