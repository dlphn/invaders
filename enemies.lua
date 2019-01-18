enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('assets/grumpycat.png')


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