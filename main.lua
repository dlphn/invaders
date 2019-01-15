function love.load()
    player = {}
    player.x = 0
    player.y = 550
    player.width = 80
    player.height = 20
    player.bullets = {}
    player.cooldown_ref = 50
    player.cooldown = 50
    player.speed = 2
    player.fire = function()
        if player.cooldown <= 0 then
            player.cooldown = player.cooldown_ref
            bullet = {}
            bullet.width = 10
            bullet.height = 10
            bullet.x = player.x + player.width/2 - bullet.width/2
            bullet.y = player.y
            table.insert(player.bullets, bullet)
        end
    end
end

function love.update(dt)
    player.cooldown = player.cooldown - 1
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
    elseif love.keyboard.isDown("left") then
        player.x = player.x - player.speed
    end

    if love.keyboard.isDown("space") then
        player.fire()
    end

    for i,bullet in ipairs(player.bullets) do
        if bullet.y < -10 then
            table.remove(player.bullets, i)
        end
        bullet.y = bullet.y - 2
    end
end

function love.draw()
    -- draw the player
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- draw bullets
    love.graphics.setColor(255, 255, 255)
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
end