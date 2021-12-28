myParse(x) = parse.(Int, x)
heightmap = Matrix(hcat(myParse.(collect.(readlines("input.txt")))...)')

nRows, nCols = size(heightmap)

function surrounding(row, col)
    arr = [(row - 1, col), (row, col - 1), (row + 1, col), (row, col + 1)]
    return [heightmap[x, y] for (x, y) in arr if x in 1:nRows && y in 1:nCols]
end

function coordfromIndex(index)
    row = ((index - 1) % nRows) + 1
    col = ((index - 1) ÷ nRows) + 1
    return row, col
end

function indexfromCoord(row, col)
    return nRows * (col - 1) + row
end

function surrounding(index)
    row, col = coordfromIndex(index)
    return surrounding(row, col)
end

function surroundingIndices(index)
    row, col = coordfromIndex(index)
    arr = [(row - 1, col), (row, col - 1), (row + 1, col), (row, col + 1)]
    return [indexfromCoord(x, y) for (x, y) in arr if x in 1:nRows && y in 1:nCols]
end

#! Part 1

function checkLower(height, index)
    val = min(surrounding(index)...)
    return height < val
end

function sumP1()
    sum = 0

    for (i, height) in enumerate(heightmap)
        if checkLower(height, i)
            sum += height + 1
        end
    end
    
    return sum
end

sumP1()

#! Part 2

function getProductPt2()
    visited = [heightmap[i] == 9 ? true : false for i in 1:length(heightmap)]
    
    basinSizes = []

    function basinSearch(index, basin = [])
        if !visited[index]
            visited[index] = true
            push!(basin, index)
            for i in surroundingIndices(index)
                basinSearch(i, basin)
            end
        end
        return length(basin)
    end

    for (i, _) in enumerate(heightmap)
        size = basinSearch(i)
        if size != 0
            push!(basinSizes, size)
        end
    end

    sort!(basinSizes, rev=true)

    return prod(basinSizes[1:3])

end

getProductPt2()