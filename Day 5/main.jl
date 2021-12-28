mutable struct Point
    x::Int
    y::Int
end

myParse(x) = parse.(Int, x)

Base.isequal(p1::Point, p2::Point) = p1.x == p2.x && p1.y == p2.y
Base.hash(p1::Point) = (53 + hash(p1.x))*53 + hash(p1.y)

function incrementCount!(d::Dict{Point, Int}, elem::Point)
    d[elem] = get(d, elem, 0) + 1
end

mutable struct Line
    p1::Point
    p2::Point
end

function slope(line::Line)
    return (line.p2.y - line.p1.y)/(line.p2.x - line.p1.x)
end

function countCoveredRange(line::Line, counterDict::Dict{Point, Int})
    m = slope(line)

    x1, y1 = line.p1.x, line.p1.y
    x2, y2 = line.p2.x, line.p2.y

    if m == Inf || m == -Inf
        for point in [Point(x1, y) for y in min(y1, y2):max(y1, y2)]
            incrementCount!(counterDict, point)
        end
    else
        for point in [Point(x, y1 + m*(x-x1)) for x in min(x1, x2):max(x1, x2)]
            incrementCount!(counterDict, point)
        end
    end
end

function countPoints(lines::Vector{Line}, lineFilter = line::Line -> true)
    pointDangerCounter = Dict{Point, Int}()

    foreach(line -> ( if lineFilter(line) countCoveredRange(line, pointDangerCounter) end), lines)

    count = 0

    for (_, coverage) in pointDangerCounter
        if coverage >= 2
            count += 1;
        end
    end

    return count

end

lines = [Line(Point(x[1:2]...), Point(x[3:4]...)) for x in myParse.(split.(readlines("input.txt"), r",|(->)|\s+", keepempty=false))]

#! Part 1

countPoints(lines, line::Line -> line.p1.x == line.p2.x || line.p1.y == line.p2.y)

#! Part 2

countPoints(lines)