# Thanks to @iskyd for the motivation to this solution

connections = split.(readlines("input.txt"), "-")

links = Dict{String, Dict}()

for (cave1, cave2) in connections
    if !haskey(links, cave1)
        links[cave1] = Dict(
            "isBig" => lowercase(cave1) != cave1,
            "connections" => []
        )
    end
    if !haskey(links, cave2)
        links[cave2] = Dict(
            "isBig" => lowercase(cave2) != cave2,
            "connections" => []
        )
    end
    push!(links[cave1]["connections"], cave2)
    push!(links[cave2]["connections"], cave1)
end

#! Part 1

function part1()
    
    frontier = [["start"]]
    count = 0

    while !isempty(frontier)
        current = pop!(frontier)

        for neighbor in links[last(current)]["connections"]
            if !(neighbor in current) || links[neighbor]["isBig"]
                if neighbor == "end"
                    count += 1
                else
                    push!(frontier, push!(copy(current), neighbor))
                end
            end
        end

    end

    return count
end

part1()

#! Part 2

function part2()
    
    frontier = [["start"]]
    value = 0

    while !isempty(frontier)
        current = pop!(frontier)

        # Check if we've visited the things multiple times
        haveMultipleVisits = false
        visits = Dict([(i, count(x -> x == i, current)) for i in unique(current)])
        
        for (key, val) in visits
            if !links[key]["isBig"] && val > 1
                haveMultipleVisits = true
                break
            end
        end

        for neighbor in links[last(current)]["connections"]
            if neighbor == "start" 
                continue 
            end
            if !(neighbor in current) || links[neighbor]["isBig"] || !haveMultipleVisits 
                if neighbor == "end"
                    value += 1
                else
                    push!(frontier, push!(copy(current), neighbor))
                end
            end
        end

    end

    return value
end

part2()