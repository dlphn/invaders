
love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('assets/grumpycat.png')

function love.load()
    player = {}
    player.x = 0
    player.y = 550
    player.width = 0.1
    player.image = love.graphics.newImage('assets/ufo.png')
    player.bullets = {}
    player.cooldown_ref = 60
    player.cooldown = player.cooldown_ref
    player.speed = 2
    player.fire = function()
        if player.cooldown <= 0 then
            player.cooldown = player.cooldown_ref
            bullet = {}
            bullet.width = 10
            bullet.height = 10
            bullet.x = player.x + 20
            bullet.y = player.y
            table.insert(player.bullets, bullet)
        end
    end
    enemies_controller:spawnEnemy(0, 0)
    enemies_controller:spawnEnemy(40, 0)
end

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.width = 0.1
    enemy.bullets = {}
    enemy.cooldown_ref = 50
    enemy.cooldown = 50
    enemy.speed = 0.8
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

    for _,enemy in pairs(enemies_controller.enemies) do
        enemy.y = enemy.y + 0.3
    end

    for i,bullet in ipairs(player.bullets) do
        if bullet.y < -10 then
            table.remove(player.bullets, i)
        end
        bullet.y = bullet.y - 2
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)

    -- draw the player
    love.graphics.draw(player.image, player.x, player.y, 0, player.width)

    -- draw enemies
    for _,enemy in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, enemy.x, enemy.y, 0, enemy.width)
    end

    -- draw bullets
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
end