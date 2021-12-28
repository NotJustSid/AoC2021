myParse(x) = parse.(Int, x)
caveMap = Matrix(hcat(myParse.(collect.(readlines("input.txt")))...)')

using DataStructures

function lowestRisk(start, goal, grid)

    # Utility Functions

    nRows, nCols = size(grid)

    function coordfromIndex(index)
        row = ((index - 1) % nRows) + 1
        col = ((index - 1) ÷ nRows) + 1
        return row, col
    end

    function indexfromCoord(row, col)
        return nRows * (col - 1) + row
    end

    function neighbors(index)
        row, col = coordfromIndex(index)
        arr = [(row - 1, col), (row, col - 1), (row + 1, col), (row, col + 1)]
        return [indexfromCoord(x, y) for (x, y) in arr if x in 1:nRows && y in 1:nCols]
    end

    # End: Utility Functions

    function heuristic(indexA, indexB)

        # Manhattan Distance
    
        A = coordfromIndex(indexA)
        B = coordfromIndex(indexB)
        
        return abs(A[2] - B[2]) + abs(A[1] - B[1])
    end
    

    frontier = PriorityQueue()
    enqueue!(frontier, start => 0)

    prev = Dict()
    costTill = Dict()

    prev[start] = nothing
    costTill[start] = 0

    while !isempty(frontier)
        current = dequeue!(frontier)

        # Early exit

        if current == goal
            break
        end

        for neighbor in neighbors(current)
            newCost = costTill[current] + grid[neighbor]
            
            # Update pathway if no costs or better cost
            
            if !haskey(costTill, neighbor) || newCost < costTill[neighbor]
                costTill[neighbor] = newCost
                priority = newCost + heuristic(neighbor, goal)
                frontier[neighbor] = priority
                prev[neighbor] = current
            end
        end
    end

    # Calculate risk
    cost = 0
    current = goal
    
    while current != start
        cost += grid[current]
        current = prev[current]
    end
    return cost
end

#! Part 1

lowestRisk(1, length(caveMap), caveMap)

#! Part 2

function addVal(x, val)
    sum = x + val
    x = sum != 9 ? sum % 9 : 9
end

newMap = vcat([hcat([addVal.(caveMap, Ref(i)) for i in j:j+4]...) for j in 0:4]...)

lowestRisk(1, length(newMap), newMap)