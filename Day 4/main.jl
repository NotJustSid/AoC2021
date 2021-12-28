content = readlines("input.txt")

drawingNums = split(popfirst!(content), ',')

# 2:6, 8:12, 14:18, 20:24 

# Have to use a regex instead of just ' ' because there are multiple space characters
# Matrix(hcat(x...)') to convert to a matrix (transpose to get the correct orientation)

Base.adjoint(x::SubString) = x

boards = [Matrix(hcat(split.(content[x], r"\s+", keepempty=false)...)') for x in [range(i, stop=i+4) for i in 2:6:length(content) if i+4 <= length(content)]]

marker = "x"

markedString = repeat(marker, 5)

function checkBoard(board::Matrix)
    for row in eachrow(board)
        if join(row) == markedString
            return true
        end
    end

    for col in eachcol(board)
        if join(col) == markedString
            return true
        end
    end

    return false
end

boardScore(board, num) = sum([parse(Int, x) for x in board if x != marker]) * parse(Int, num)

function draw()

    for num in drawingNums
        for board in boards, i in 1:length(board)
            if board[i] == num
                board[i] = marker
                if checkBoard(board)
                    return boardScore(board, num)
                end
            end
        end
    end
    
end

draw()

#! Part 2

# Reset board
boards = [Matrix(hcat(split.(content[x], r"\s+", keepempty=false)...)') for x in [range(i, stop=i+4) for i in 2:6:length(content) if i+4 <= length(content)]]



function drawpt2()
    local trackedDrawingNum
    local winningBoardIndices::Vector{Int} = []
    for num in drawingNums
        for (boardIndex, board) in enumerate(boards), i in 1:length(board)
            if board[i] == num
                board[i] = marker
                if checkBoard(board) && !(boardIndex in winningBoardIndices)
                    push!(winningBoardIndices, boardIndex)
                    trackedDrawingNum = num
                    if length(winningBoardIndices) == length(boards)
                        return boardScore(boards[last(winningBoardIndices)], trackedDrawingNum)
                    end
                end
            end
        end
    end
end

drawpt2()