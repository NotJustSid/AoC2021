hexMap = Dict{Char, String}(
    '0' => "0000",
    '1' => "0001",
    '2' => "0010",
    '3' => "0011",
    '4' => "0100",
    '5' => "0101",
    '6' => "0110",
    '7' => "0111",
    '8' => "1000",
    '9' => "1001",
    'A' => "1010",
    'B' => "1011",
    'C' => "1100",
    'D' => "1101",
    'E' => "1110",
    'F' => "1111",
    '\n' => ""
)

function hexToBin(str)
    return join([hexMap[c] for c in str])
end

function binToDec(str)
    len = length(str)
    return sum([parse(Int, c) * 2^(len - i) for (i, c) in enumerate(str)])
end

function parsePacket(bits, ind=1)
    version = bits[ind:ind+2]
    typeId = bits[ind+3:ind+5]

    ind += 6
    
    if typeId == "100"
        # Literal Value
        valStr = ""
        
        for index in ind:5:length(bits)
            valStr *= bits[index+1:index+4]
            ind += 5
            if bits[index] == '0'
                dec = binToDec(valStr)
                return (version = binToDec(version), typeId = binToDec(typeId), literal = dec, index = ind, innerPackets = [])
            end
        end
    else
        # Operator
        lengthTypeId = bits[ind]
        ind += 1
        if lengthTypeId == '0'
            subPacketslengthBits = binToDec(bits[ind:ind+14]) # Next 15 bits
            ind += 15
            subPackets = []
            oldInd = ind
            while true
                packet = parsePacket(bits, ind)
                push!(subPackets, packet)
                ind = packet[:index]
                
                if ind - oldInd == subPacketslengthBits
                    break
                end
            end
            return (version = binToDec(version), typeId = binToDec(typeId), literal = nothing, index = ind, innerPackets = subPackets)
        else 
            nSubPackets = binToDec(bits[ind:ind+10]) # Next 11 bits
            ind += 11
            subPackets = []
            for _ in 1:nSubPackets
                packet = parsePacket(bits, ind)
                ind = packet[:index]
                push!(subPackets, packet)
            end
            return (version = binToDec(version), typeId = binToDec(typeId), literal = nothing, index = ind, innerPackets = subPackets)
        end
    end
end

packet = parsePacket(hexToBin(read("input.txt", String)))

#! Part 1

function sumVersions(packet)
    version = packet[:version]
    for pckt in packet[:innerPackets]
        version += sumVersions(pckt)
    end
    return version
end

sumVersions(packet)

#! Part 2
function evalPacket(packet)
    typeId = packet[:typeId]
    if typeId == 0
        # Sum
        return sum([evalPacket(p) for p in packet[:innerPackets]])
    elseif typeId == 1
        # Product
        return prod([evalPacket(p) for p in packet[:innerPackets]])
    elseif typeId == 2
        # Minimum
        return minimum([evalPacket(p) for p in packet[:innerPackets]])
    elseif typeId == 3
        # Maximum
        return maximum([evalPacket(p) for p in packet[:innerPackets]])
    elseif typeId == 4
        # Literal
        return packet[:literal]
    elseif typeId == 5
        # Greater than packet
        p1 = evalPacket(packet[:innerPackets][1])
        p2 = evalPacket(packet[:innerPackets][2])
        return p1 > p2 ? 1 : 0
    elseif typeId == 6
        # Less than packet
        p1 = evalPacket(packet[:innerPackets][1])
        p2 = evalPacket(packet[:innerPackets][2])
        return p1 < p2 ? 1 : 0
    elseif typeId == 7
        # Equality packet
        p1 = evalPacket(packet[:innerPackets][1])
        p2 = evalPacket(packet[:innerPackets][2])
        return p1 == p2 ? 1 : 0
    end
end

evalPacket(packet)