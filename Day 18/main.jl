function loadInput(inputFile::AbstractString)::Vector{Any}
    raw = readchomp(inputFile)

    str = "[" * replace(replace(raw, "[" => "Any["), "\n" => ",\n") * "]"

    return include_string(Main, str)
end

function explodeSnail!(root, num, depth, indices=[])
    if depth >= 4 && isa(num[1], Number) && isa(num[2], Number)
        # Has to be a pair if both are numbers
        # Explode for depth >= 4
        
        pairValues  = [num[1], num[2]]
        
        # Get the containing pair
        pair = root 
        for i in 1:length(indices)-1
            pair = pair[indices[i]]
        end

        # Replace with 0
        pair[indices[end]] = 0

        # Add left and right
        for (i, j) in [(1, 2), (2, 1)]
            last = findlast(x -> x==j, indices)
            
            if last !== nothing

                # Get the containing pair
                pair = root 
                
                for i in 1:last-1
                    pair = pair[indices[i]]
                end

                if isa(pair[i], Number)
                    pair[i] += pairValues[i]
                else
                    pair = pair[i]
                    while true
                        if isa(pair[j], Number)
                            pair[j] += pairValues[i]
                            break
                        end
                        pair = pair[j]
                    end
                end
            end

        end

        return true
    end

    if !isa(num[1], Number)
        push!(indices, 1)
        if explodeSnail!(root, num[1], depth + 1, indices)
            return true
        end
    end
    
    if !isa(num[2], Number)
        push!(indices, 2)
        if explodeSnail!(root, num[2], depth + 1, indices)
            return true
        end
    end
    
    if !isempty(indices)
        pop!(indices)
    end
    
    return false
end

function explodeSnail!(root, depth=0)
    explodeSnail!(root, root, depth)
end

function splitSnail!(num)

    if isa(num[1], Number)
        if num[1] >= 10
            left, right = round(num[1]/2, RoundDown), round(num[1]/2, RoundUp)
            num[1] = Any[left, right]
            return true
        end
    end
    
    for i in 1:2
        if !isa(num[i], Number)
            if splitSnail!(num[i])
                return true
            end
        end
    end


    if isa(num[2], Number)
        if num[2] >= 10
            left, right = round(num[2]/2, RoundDown), round(num[2]/2, RoundUp)
            num[2] = Any[left, right]
            return true
        end
    end

    return false
end

function reduceSnail(num)
    while true
        explodeSnail!(num) && continue
        splitSnail!(num) && continue
        break
    end
    
    return num
end

function addSnails(left, right)
    return reduceSnail([left, right])
end

function magnitude(num)
    if isa(num, Number)
        return num
    else
        return 3*magnitude(num[1]) + 2*magnitude(num[2])
    end
end

#! Part 1

snailNumbers = loadInput("input.txt")
sum = snailNumbers[1]

for i in 2:length(snailNumbers)
    sum = addSnails(sum, snailNumbers[i])
end

magnitude(sum)

#! Part 2

snailNumbers = loadInput("input.txt")
maximum([magnitude(addSnails(deepcopy(snailNumbers[i]), deepcopy(snailNumbers[j]))) for i in 1:length(snailNumbers) for j in 1:length(snailNumbers) if i!=j])
