function love.load()
    x = 0
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        x = x + 1
    elseif love.keyboard.isDown("left") then
        x = x - 1
    end
end

function love.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", x, 500, 80, 20)
end