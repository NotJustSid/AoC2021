using DelimitedFiles

content = readdlm("input.txt", '|')
nEntries = size(content)[1]

signals = split.(content[:, 1], " ", keepempty=false)
outputs = split.(content[:, 2], " ", keepempty=false)

function countP1()
    count = 0

    for i in 1:nEntries
        for output in outputs[i]
            len = length(output)
            
            if len == 2 || len ==  4 || len == 3 || len == 7
                count += 1
            end
        end
    end

    return count
end

countP1()

function countP2()
    value = 0

    numLengthMap = Dict(
        2 => ["1"],
        3 => ["7"],
        4 => ["4"],
        5 => ["2", "3", "5"],
        6 => ["0", "6", "9"],
        7 => ["8"]
    )

    for i in 1:nEntries
        numString = ""
        
        local overlapRef = Dict()

        for signal in signals[i]
            set = Set(signal)
            len = length(set)
            if len == 2 || len == 4
                overlapRef[len] = set
            end
        end


        for output in outputs[i]
            len = length(output)

            if len == 5
                digitSegs = Set(output)
                
                if length(digitSegs ∩ overlapRef[4]) == 2
                    numString *= numLengthMap[len][1] # 2
                elseif length(digitSegs ∩ overlapRef[2]) == 2
                    numString *= numLengthMap[len][2] # 3
                else
                    numString *= numLengthMap[len][3] # 5
                end

            elseif len == 6
                digitSegs = Set(output)

                if length(digitSegs ∩ overlapRef[2]) == 1
                    numString *= numLengthMap[len][2] # 6
                elseif length(digitSegs ∩ overlapRef[4]) == 4
                    numString *= numLengthMap[len][3] # 9
                else
                    numString *= numLengthMap[len][1] # 0
                end

            else
                numString *= numLengthMap[len][1]
            end

        end
        value += parse(Int, numString)
    end

    return value
end

countP2()