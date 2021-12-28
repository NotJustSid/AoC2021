xRange, yRange = [parse.(Int, (split(x[3:end], "..")...,)) for x in split.(readline("input.txt")[14:end], ", ")]

#! Part 1

vy = -yRange[1]-1
yMax = vy * (vy + 1)/2

#! Part 2

# Sorta brute force 😅

function doesItHit(velocityX, velocityY)
    positionX = 0
    positionY = 0
    while true
        positionX += velocityX
        positionY += velocityY

        if xRange[1] <= positionX <= xRange[2] && yRange[1] <= positionY <= yRange[2]
            return true
        end

        if positionY < yRange[1] || positionX > xRange[2]
            return false
        end

        velocityY -= 1
        velocityX -= velocityX == 0 ? 0 : abs(velocityX)/velocityX
    end
end

function countVelocities()
    a = max(abs.(xRange)...)
    b = max(abs.(yRange)...)
    return count([doesItHit(x, y) for x in -a:a for y in -b:b])
end

countVelocities()