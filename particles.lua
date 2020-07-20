-- math imports--
local abs = math.abs

local particleSys = {}

-- Constants--
particleSys.gravity = 250

-- Data--
local particles = {}

-- The fallback data for all particles
local particleBase = {
    x = 0,
    y = 0,
    z = 0,
    vx = 0,
    vy = 0,
    vz = 0,
    col = 7,
    bounce = 0.6
}
particleBase.__index = particleBase

-- Particle constructor--
function particleSys.newParticle(x, y, z, vx, vy, vz, col, bounce, life)
    -- If we feed this function parameters they'll get set here in the table declaration.
    -- Otherwise, the metatable values will be used.
    local particle = {
        x = x,
        y = y,
        z = z,
        vx = vx,
        vy = vy,
        vz = vz,
        col = col,
		bounce = bounce,
		timer = game.Timer:new(life or 4)
    }
    setmetatable(particle, particleBase)

	particle.timer:trigger()
	
    table.insert(particles, particle)

    return particle
end

function particleBase:update(dt)
    -- Localizing variables from self
    local x, y, z, vx, vy, vz, bounce = self.x, self.y, self.z, self.vx, self.vy, self.vz, self.bounce

    -- Motion--
    x = x + vx * dt
    y = y + vy * dt
    z = z + vz * dt

    -- Gravity--
    vz = vz - particleSys.gravity * dt

    -- Bouncing--
    if z <= 0 then
        -- We'll compensate for going through
        -- the floor by reflecting Z through
        -- zero
        z = -z

        -- bounce is usually < 1, so this
        -- should scale down all motion on
        -- every bounce.
        vx = vx * bounce
        vy = vy * bounce
        vz = -vz * bounce
    end

    -- Giving the updated values back to
    -- self
    self.x, self.y, self.z, self.vx, self.vy, self.vz = x, y, z, vx, vy, vz

    -- If this particle has basically
    -- stopped moving, we'll tell the
    -- update function by returning true.
    --if z < 1 and abs(vz) < 1 and abs(vx) < 21 and abs(vy) < 2 then
    --    return true
	--end

	if self.timer:check() then
		return true
	end

	self.timer:update(dt)
end

function particleBase:draw()
    color(self.col)
	point(self.x, self.y - self.z)
end

function particleSys.update(dt)
    for k, v in pairs(particles) do
        -- If the update returns true then
        -- we can get rid of the particle.
        if v:update(dt) then
            table.remove(particles, k)
        end
    end
end

function particleSys.draw()
    -- Drawing all the active particles
    for k, v in pairs(particles) do
        v:draw()
    end
end

return particleSys
