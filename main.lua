function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    love.window.setTitle("Target Practice Game")
    love.window.setMode(800, 600)

    score = 0
    timer = 0
    gameState = 1 -- 1 = menu, 2 = bermain, 3 = game over

    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false)
end

function love.update(dt)
    if gameState == 2 then
        if timer > 0 then timer = timer - dt end

        if timer <= 0 then
            timer = 0
            gameState = 3 -- ganti ke game over
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, 5, 5)
    love.graphics.print("Time: " .. math.ceil(timer), 300, 5)

    if gameState == 1 then
        love.graphics.printf("Click anywhere to begin!", 0, 250,
                             love.graphics.getWidth(), "center")
    elseif gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius,
                           target.y - target.radius)
    elseif gameState == 3 then
        love.graphics.printf("Game Over! Click to play again!", 0, 250,
                             love.graphics.getWidth(), "center")
    end

    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20,
                       love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if gameState == 2 then
            local mouseToTarget = distanceBetween(x, y, target.x, target.y)
            if mouseToTarget < target.radius then
                score = score + 1
                target.x = math.random(target.radius,
                                       love.graphics.getWidth() - target.radius)
                target.y = math.random(target.radius,
                                       love.graphics.getHeight() - target.radius)
            end
        elseif gameState == 1 or gameState == 3 then
            -- mulai ulang permainan
            score = 0
            timer = 10
            gameState = 2
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
