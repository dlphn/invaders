particle_systems = {}
particle_systems.list = {}
particle_systems.image = love.graphics.newImage('assets/dog.png')

function particle_systems:spawn(x, y)
    local psystem = {}
    psystem.x = x + 0.2 * enemies_controller.image:getWidth() / 2
    psystem.y = y + 0.2 * enemies_controller.image:getHeight() / 2
    psystem.ps = love.graphics.newParticleSystem(particle_systems.image, 32)
    psystem.ps:setParticleLifetime(0, 3)
    psystem.ps:setSizes(0.1, 0)
    psystem.ps:setLinearAcceleration(-200, -200, 200, 200)
    psystem.ps:setColors(255, 255, 255, 255, 255, 255, 255, 0.5)
    psystem.ps:emit(32)
    table.insert(particle_systems.list, psystem)
end

function particle_systems:draw()
    for _, p in pairs(particle_systems.list) do
        love.graphics.draw(p.ps, p.x, p.y)  -- not working
    end
end

function particle_systems:update(dt)
    for _, p in pairs(particle_systems.list) do
        p.ps:update(dt)
    end
end

function particle_systems:cleanup()
    -- delete particle systems after a while
end