startChars = ['(', '[', '{', '<']

characterMatch = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)

illegalCharScores = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)

lines = readlines("input.txt")

struct CorruptedException
    ch::Char
end

function parseline(line)
    stack = []
    try
        for ch in line
            if !(ch in startChars)
                if length(stack) != 0
                    if characterMatch[last(stack)] == ch
                        pop!(stack)
                    else
                        throw(CorruptedException(ch)) # Unexpected ending char
                    end
                else
                    throw((CorruptedException(ch))) # Unexpected; We never started with an open char
                end
            else
                push!(stack, ch)
            end
        end 
    catch err
        if isa(err, CorruptedException)
            return (isCorrupt=true, err.ch)
        else 
            error("An unknown error occured")
        end
    end

    return (isCorrupt=false, stack)
end

outs = parseline.(lines)


#! Part 1

corruptedOuts = filter(((isCorrupt, temp),) -> isCorrupt, outs)
totalSyntaxError = sum(illegalCharScores[ch] for (_, ch) in corruptedOuts)

#! Part 2

pointValue = Dict(
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
)

function getClosingSeqScore(stack)
    score = 0
    for ch in reverse(stack)
        score *= 5
        score += pointValue[characterMatch[ch]]
    end
    return score
end

incompleteOuts = filter(((isCorrupt, temp),) -> !isCorrupt, outs)
autoCompleteSeq = sort([getClosingSeqScore(stack) for (_, stack) in incompleteOuts])

middleScore = autoCompleteSeq[(length(autoCompleteSeq) + 1) ÷ 2]