myParse(x) = parse.(Int, x)
crabPositions = myParse.(split.(readline("input.txt"), ','))

#! Part 1

using Statistics

function findLeastFuelPositionPt1(positions)
    return round(median(positions))
end

totalFuelCostPt1(positions, destination) = sum([abs(x-destination) for x in positions])

print(totalFuelCostPt1(crabPositions, findLeastFuelPositionPt1(crabPositions)))

#! Part 2

function findLeastFuelCostPt2(positions)
    fuel = Inf
    approxPos = Int(round(mean(positions)))
    𝛜 = 3
    for pos in approxPos-𝛜:approxPos+𝛜
        dists = [abs(x - pos) for x in positions]
        f = sum([0.5*(d^2 + d) for d in dists])

        if fuel > f
            fuel = f
        end
    end
    
    return fuel
end

print(findLeastFuelCostPt2(crabPositions))

# Intuition for the least fuel Position functions: https://www.johnmyleswhite.com/notebook/2013/03/22/modes-medians-and-means-an-unifying-perspective/