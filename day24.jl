using Hexagons

const CHNOs = [
    # Cubic Hex Neighbor Offsets, in our convention E is on (-z,+x):
    1 -1 0;   # E
    1 0 -1;   # NE
    0 1 -1;   # NW
    -1 1 0;   # W
    -1 0 1;   # SW
    0 -1 1;   # SE
]


function readinput(strs)::Vector{Vector{Vector{Int64}}}
    instrs = []
    for s in eachindex(strs)
        cs = collect(strs[s])
        instr = []
        i = 1
        while i <= length(cs)
            c = cs[i]
            if cs[i] == 'e'
                push!(instr, CHNOs[1,:])
            elseif cs[i] == 'n' && cs[i+1] == 'e'
                # Short-circuit evaluation should prevent out-of-bounds

                i += 1
                push!(instr, CHNOs[2,:])
            elseif cs[i] == 'n' && cs[i+1] == 'w'
                i += 1
                push!(instr, CHNOs[3,:])
            elseif cs[i] == 'w'
                push!(instr, CHNOs[4,:])
            elseif cs[i] == 's' && cs[i+1] == 'w'
                i += 1
                push!(instr, CHNOs[5,:])
            elseif cs[i] == 's' && cs[i+1] == 'e'
                i += 1
                push!(instr, CHNOs[6,:])
            else
                throw(DomainError())
            end
            i += 1
        end
        push!(instrs, instr)
    end
    instrs
end

function placetiles(instrs)
    tiles = Dict()
    for steps in instrs
        pos = foldl(+, steps, init=[0,0,0])
        hexcoords = hexagon(pos[1], pos[2], pos[3])
        if haskey(tiles, hexcoords)
            # Tile yet flipped, so we flip again

            tiles[hexcoords] = !tiles[hexcoords]
        else
           # Tile never flipped before, we create it as black (true)

           tiles[hexcoords] = true
       end
   end
   tiles
end


# First Half

blacksideups(tiles) = count(t -> t[2], tiles)


puzzletestinput = readlines("inputs/day24-test.txt")
puzzleinput = readlines("inputs/day24.txt")

blacksideups(placetiles(readinput(puzzleinput)))
