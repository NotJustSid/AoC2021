using DelimitedFiles

content = readdlm("input.txt", ' ')

mutable struct MyPoint
    x::Int
    y::Int
end

p = MyPoint(0, 0)

function modifyPoint(instruction)
    command, value = instruction
    if command == "forward"
        p.x += value
    elseif command == "down"
        p.y += value
    else
        p.y -= value
    end
end

for i in 1:length(content[:, 1])
    modifyPoint(content[i, :])
end

p.x * p.y