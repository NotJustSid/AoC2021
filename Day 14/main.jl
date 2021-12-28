content = readlines("input.txt")
template = content[1]
rules = Dict{String, String}()

foreach(split.(content[3:end], " -> ")) do rule
    rules[rule[1]] = rule[2]
end

generatePairs(str) = [str[i]*str[i+1] for i in 1:length(str)-1]

function counterCount(collection)
    dict = Dict()
    for item in collection
        dict[item] = get(dict, item, 0) + 1
    end
    return dict
end

function polymerizationCountsSorted(template, nSteps)
    pairs = generatePairs(template)
    
    pairCounts = counterCount(pairs)
    
    for _ in 1:nSteps
        subCounter = Dict()
        for (key, val) in pairCounts
            if !haskey(rules, key) return pairCounts end

            insertionCh = rules[key]
            pair1, pair2 = key[1] * insertionCh, insertionCh * key[2]

            subCounter[pair1] = get(subCounter, pair1, 0) + val
            subCounter[pair2] = get(subCounter, pair2, 0) + val
        end
        pairCounts = subCounter
    end
    
    counts = Dict{Char, Int}()

    for (keyPair, occurrences) in pairCounts
        counts[keyPair[1]] = get(counts, keyPair[1], 0) + occurrences
    end
    counts[template[end]] = get(counts, template[end], 0) + 1

    return sort(collect(counts), by = x -> x[2])
end

diffMostLeastCommon(countsSorted) = countsSorted[end][2] - countsSorted[begin][2]

#! Part 1

template10Counts = polymerizationCountsSorted(template, 10)
diffMostLeastCommon(template10Counts)

#! Part 2

template40Counts = polymerizationCountsSorted(template, 40)
diffMostLeastCommon(template40Counts)