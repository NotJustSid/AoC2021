myParse(x) = parse.(Int, x)
energyLevels = Matrix(hcat(myParse.(collect.(readlines("input.txt")))...)')

nRows, nCols = size(energyLevels)
nLevels = length(energyLevels)

function coordfromIndex(index)
    row = ((index - 1) % nRows) + 1
    col = ((index - 1) ÷ nRows) + 1
    return row, col
end

function indexfromCoord(row, col)
    return nRows * (col - 1) + row
end

function surroundingIndices(index)
    row, col = coordfromIndex(index)
    arr = [(row - 1, col), (row, col - 1), (row + 1, col), (row, col + 1), (row + 1, col +1), (row - 1, col - 1), (row - 1, col + 1), (row + 1, col - 1)]
    return [indexfromCoord(x, y) for (x, y) in arr if x in 1:nRows && y in 1:nCols]
end

function simulatePt1(steps, elevels)

    function flashNode(index, flashed)
        flashed[index] = true
        for i in surroundingIndices(index)
            elevels[i] += 1
            if elevels[i] > 9 && !flashed[i]
                flashNode(i, flashed)
            end
        end
    end

    function simulateFlashes()
        flashed = [false for i in 1:nLevels]
        for i in 1:nLevels
            if elevels[i] > 9 && !flashed[i]
                flashNode(i, flashed)
            end
        end
        
        for (i, hasFlashed) in enumerate(flashed)
            if hasFlashed
                elevels[i] = 0
            end
        end

        return count(flashed)
    end

    flashes = 0

    for _ in 1:steps
        elevels .= elevels .+ 1
        flashes += simulateFlashes()
    end

    return flashes
end

simulate(100, copy(energyLevels))

function simulatePt2(elevels)

    function flashNode(index, flashed)
        flashed[index] = true
        for i in surroundingIndices(index)
            elevels[i] += 1
            if elevels[i] > 9 && !flashed[i]
                flashNode(i, flashed)
            end
        end
    end

    function simulateFlashes()
        flashed = [false for i in 1:nLevels]
        for i in 1:nLevels
            if elevels[i] > 9 && !flashed[i]
                flashNode(i, flashed)
            end
        end
        
        for (i, hasFlashed) in enumerate(flashed)
            if hasFlashed
                elevels[i] = 0
            end
        end

        return count(flashed) == length(flashed)
    end

    step = 1

    while true
        elevels .= elevels .+ 1
        if simulateFlashes() == true
            return step
        end
        step += 1
    end
end

simulatePt2(energyLevels)