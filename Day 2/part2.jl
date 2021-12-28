using DelimitedFiles

content = readdlm("input.txt", ' ')

mutable struct SubmarineState
    x::Int
    y::Int
    aim::Int
end

p = SubmarineState(0, 0, 0)

function modifyState(instruction)
    command, value = instruction
    if command == "forward"
        p.x += value
        p.y += p.aim * value
    elseif command == "down"
        p.aim += value
    else
        p.aim -= value
    end
end

for i in 1:length(content[:, 1])
    modifyState(content[i, :])
end

p.x * p.y