require 'enemies'
require 'particle_systems'

love.graphics.setDefaultFilter('linear', 'linear')

function checkCollisions(enemies, bullets)
    for i, e in pairs(enemies) do
        for _, b in pairs(bullets) do
            if b.y <= e.y + e.scaleFactor * e.height and b.x >= e.x and b.x + b.width <= e.x + e.scaleFactor * e.width then
                particle_systems:spawn(e.x, e.y)
                table.remove(enemies, i)
            end
        end
    end
end

function love.load()
    local music = love.audio.newSource('assets/music.mp3', 'static')
    music:setLooping(true)
    love.audio.play(music)
    game_over = false
    game_win = false
    background_image = love.graphics.newImage('assets/background.png')
    firework_image = love.graphics.newImage('assets/firework.jpg')
    player = {}
    player.x = 0
    player.y = 550
    player.width = 0.1
    player.image = love.graphics.newImage('assets/ufo.png')
    player.fire_sound = love.audio.newSource('assets/laser.wav', 'static')
    player.bullets = {}
    player.cooldown_ref = 60
    player.cooldown = player.cooldown_ref
    player.speed = 2
    player.fire = function()
        if player.cooldown <= 0 then
            love.audio.play(player.fire_sound)
            player.cooldown = player.cooldown_ref
            bullet = {}
            bullet.width = 10
            bullet.height = 10
            bullet.x = player.x + 20
            bullet.y = player.y
            bullet.speed = 300
            table.insert(player.bullets, bullet)
        end
    end
    for i = 0, 8 do
        enemies_controller:spawnEnemy(i * 85, 0)
    end 
end

function love.update(dt)
    if game_win == false and game_over == false then
        player.cooldown = player.cooldown - 300 * dt
        if love.keyboard.isDown("right") then
            player.x = player.x + player.speed
        elseif love.keyboard.isDown("left") then
            player.x = player.x - player.speed
        end

        if love.keyboard.isDown("space") then
            player.fire()
        end
    end

    if game_win == true then
        if player.y > 100 then
            player.y = player.y - player.speed * 100 * dt
        end
    end

    if #enemies_controller.enemies == 0 then
        game_win = true
    end

    for i,enemy in ipairs(enemies_controller.enemies) do
        if enemy.y >= love.graphics.getHeight() then
            game_over = true
        end
        enemy.y = enemy.y + enemy.speed * dt
    end

    for i,bullet in ipairs(player.bullets) do
        if bullet.y < -10 then
            table.remove(player.bullets, i)
        end
        bullet.y = bullet.y - bullet.speed * dt
    end

    checkCollisions(enemies_controller.enemies, player.bullets)
    particle_systems:update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(background_image, 0, 0, 0, 1.5)
    
    if game_over == true then
        love.graphics.printf({{255, 0, 0}, 'Game Over!'}, 100, 100, 200, 'center', 0, 2)
        return
    elseif game_win == true then
        love.graphics.draw(firework_image, 0, 0, 0, 0.3)
        love.graphics.print('You Won!', 10, 10)
    end

    -- draw the player
    love.graphics.draw(player.image, player.x, player.y, 0, player.width)

    -- draw enemies
    for _,enemy in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, enemy.x, enemy.y, 0, enemy.scaleFactor)
    end

    particle_systems:draw()

    -- draw bullets
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
end
