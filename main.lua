enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}

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
    enemies_controller:spawnEnemy(0, 0)
    enemies_controller:spawnEnemy(40, 0)
end

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.width = 30
    enemy.height = 30
    enemy.bullets = {}
    enemy.cooldown_ref = 50
    enemy.cooldown = 50
    enemy.speed = 2
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
    -- draw the player
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

    -- draw enemies
    love.graphics.setColor(0, 0, 255)
    for _,enemy in pairs(enemies_controller.enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    end

    -- draw bullets
    love.graphics.setColor(255, 255, 255)
    for _,bullet in pairs(player.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
end