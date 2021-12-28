myParse(x) = parse.(Int, x)
fishes = myParse.(split.(readline("input.txt"), ','))


function simulateFishes!(fishVec, nDays)
    bucket = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    for fish in fishVec
        bucket[fish+1] += 1
    end

    for _ in 1:nDays
        bucket = circshift(bucket, -1)
        bucket[6+1] += bucket[8+1] # For each fish that generates a new fish (bucket tracking 8), add count to the 6 counter as the fish resets
    end
    return sum(bucket)
end

#! Part 1

simulateFishes!(fishes, 80)

#! Part 2

simulateFishes!(fishes, 256)