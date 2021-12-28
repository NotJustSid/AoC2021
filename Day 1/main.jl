depths = parse.(Int, readlines("input.txt"))

#! Part 1

function countLarger(vec)
    isLarger = a -> a > 0 ? 1 : 0;
    sum([isLarger(vec[j] - vec[i]) for i in 1:length(vec) for j = i+1 if j <= length(vec)])
end

countLarger(depths)

#! Part 2

# A (1) -> 1, 2, 3
# B (2) -> 2, 3, 4
# C (3) -> 3, 4, 5
# ⋮

giveIndices = window -> [window + 1, window + 2, window + 3]

countLarger([sum(depths[giveIndices(i)]) for i in 1:length(depths)-2 if max(giveIndices(i)...) <= length(depths)])