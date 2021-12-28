myParse(x) = parse.(Int, x)

# hcat(x...) converts x::Vector{Vector} to Matrix
# hcat to get columns as rows instead 

bits = hcat(myParse.(collect.(readlines("input.txt")))...)

#! Part 1

mcb = x -> count(isone, x) >= length(x)/2 ? 1 : 0;
lcb = x -> count(isone, x) < length(x)/2 ? 1 : 0;

γVec = [mcb(row) for row in eachrow(bits)]
εVec = replace(γVec, 0 => 1, 1 => 0)

γ = parse(Int, string(γVec...); base=2)
ε = parse(Int, string(εVec...); base=2)

power = γ * ε

#! Part 2

nRows = length(bits[:, 1])

function findRatingRecursive(vec, measure, rowIndex=1)
    
    if(length(vec[1, :]) == 1) 
        return vec
    end
    
    if(rowIndex > nRows)
        rowIndex = 1
    end
    
    requiredBit = measure(vec[rowIndex, :])
    
    filteredVec::Vector{Vector{Int}} = []
    
    for col in eachcol(vec)
        if col[rowIndex] == requiredBit
            push!(filteredVec, col)
        end
    end

    findRatingRecursive(hcat(filteredVec...), measure, rowIndex+1)
end

oxygenRating = parse(Int, string(findRatingRecursive(bits, mcb)...); base=2)

co2Rating = parse(Int, string(findRatingRecursive(bits, lcb)...); base=2)

lifeSupportRating = oxygenRating * co2Rating