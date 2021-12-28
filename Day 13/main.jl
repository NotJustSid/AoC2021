function dotAfterFoldAlongX(lineX, dot) # Vertical Line
    if (dot[1] > lineX)
        return [lineX - abs(lineX-dot[1]), dot[2]]
    end
    
    return dot
end

function dotAfterFoldAlongY(lineY, dot) # Horizontal Line
    if (dot[2] > lineY)
        return [dot[1], lineY - abs(lineY-dot[2])]
    end
    
    return dot
end


content = readlines("input.txt")
splitIndex = findfirst(isempty, content)

atEnd(vec) = vec[end]

myParse(x) = parse.(Int, x)

dots, instructions = myParse.(split.(content[1:splitIndex-1], ",")), split.(atEnd.(split.(content[splitIndex+1:end], " ")), "=")

function doFold(instruction)
    if instruction[1] == "x"
        return Set([dotAfterFoldAlongX(parse(Int, instruction[2]), dot) for dot in dots])
    else
        return Set([dotAfterFoldAlongY(parse(Int, instruction[2]), dot) for dot in dots])
    end
end

#! Part 1

length(doFold(instructions[1]))

#! Part 2

for instruction in instructions
    dots = doFold(instruction)
end

using Plots

plot([(dot[1], dot[2]) for dot in dots], seriestype = :scatter, yflip = true, aspect_ratio=:equal, c=:black)