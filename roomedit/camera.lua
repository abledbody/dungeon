local clamp, floor = math.clamp, math.floor

camera = {}
local this = camera

this.view_x, this.view_y = HSW, HSH
this.view_scale = 1
this.dragging = false

function this.move(dx, dy)
	local view_x = this.view_x - dx / this.view_scale
	local view_y = this.view_y - dy / this.view_scale
	
	this.view_x = clamp(view_x, 0, 1152)
	this.view_y = clamp(view_y, 0, 1024)
end

function this.transform()
	local inv_scale = 1 / this.view_scale
	
	cam("translate", HSW, HSH)
	cam("scale", this.view_scale, this.view_scale)
    cam("translate", -floor(this.view_x * this.view_scale) * inv_scale, -floor(this.view_y * this.view_scale) * inv_scale)
end