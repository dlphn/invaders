
love.graphics.setDefaultFilter('linear', 'linear')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('assets/grumpycat.png')

function checkCollisions(enemies, bullets)
    for i, e in pairs(enemies) do
        for _, b in pairs(bullets) do
            if b.y <= e.y + e.scaleFactor * e.height and b.x >= e.x and b.x + b.width <= e.x + e.scaleFactor * e.width then
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
    background_image = love.graphics.newImage('assets/background.jpeg')
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

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.scaleFactor = 0.2
    enemy.width = enemies_controller.image:getWidth()
    enemy.height = enemies_controller.image:getHeight()
    enemy.bullets = {}
    enemy.cooldown_ref = 50
    enemy.cooldown = 50
    enemy.speed = 60
    table.insert(self.enemies, enemy)
end

function enemy:fire()
    if self.cooldown <= 0 then
        self.cooldown = player.cooldown_ref
        bullet = {}
        bullet.width = 10
        bullet.height = 10
        bullet.x = self.x + self.width/2 - self.width/2
        bullet.y = self.y
        table.insert(self.bullets, bullet)
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
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(background_image, 0, 0, 0, 2)
    
    if game_over == true then
        love.graphics.print('Game Over!')
        return
    elseif game_win == true then
        love.graphics.print('You Won!')
    end

    -- draw the player
    love.graphics.draw(player.image, player.x, player.y, 0, player.width)

    -- draw enemies
    for _,enemy in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, enemy.x, enemy.y, 0, enemy.scaleFactor)
    end

    -- draw bullets
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
end
