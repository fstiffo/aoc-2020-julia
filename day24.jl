using Hexagons
using Plots

const CHNOs = [
    # Cubic Hex Neighbor Offsets, in our convention E is on (-z,+x):
    1 -1 0   # E
    1 0 -1   # NE
    0 1 -1   # NW
    -1 1 0   # W
    -1 0 1   # SW
    0 -1 1   # SE
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
                push!(instr, CHNOs[1, :])
            elseif cs[i] == 'n' && cs[i+1] == 'e'
                # Short-circuit evaluation should prevent out-of-bounds

                i += 1
                push!(instr, CHNOs[2, :])
            elseif cs[i] == 'n' && cs[i+1] == 'w'
                i += 1
                push!(instr, CHNOs[3, :])
            elseif cs[i] == 'w'
                push!(instr, CHNOs[4, :])
            elseif cs[i] == 's' && cs[i+1] == 'w'
                i += 1
                push!(instr, CHNOs[5, :])
            elseif cs[i] == 's' && cs[i+1] == 'e'
                i += 1
                push!(instr, CHNOs[6, :])
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
        pos = foldl(+, steps, init = [0, 0, 0])
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

blacksideups(tiles) = count(values(tiles))


# First Half

puzzletestinput = readlines("inputs/day24-test.txt")
puzzleinput = readlines("inputs/day24.txt")

blacksideups(placetiles(readinput(puzzletestinput)))


# Second half

function flipall!(tiles, times)

    for _ = 1:times
        toflip = []

        blacktiles = filter(t -> t[2], tiles)
        for (tile, _) in blacktiles
            neighbors = Hexagons.neighbors(tile)
            blacks = count(n -> get!(tiles, n, false), neighbors)
            # For every black neighbor of a tile count it if exists,
            # if not then add it to tiles as white

            if blacks == 0 || blacks > 2
                # Any black tile with zero or more than 2 black tiles immediately
                # adjacent to it is flipped to white.

                push!(toflip, tile)
            end
        end

        whitetiles = filter(t -> !t[2], tiles)
        for (tile, _) in whitetiles
            neighbors = Hexagons.neighbors(tile)
            blacks = count(n -> get(tiles, n, false), neighbors)
            # For every black neighbor of a tile count it if exists,
            # if not then add it to tiles as white

            if blacks == 2
                # Any white tile with exactly 2 black tiles immediately
                # adjacent to it is flipped to black.

                push!(toflip, tile)
            end
        end

        for t in toflip
            # The rules are applied simultaneously to every tile
            
            tiles[t] = !tiles[t]
        end
    end
    tiles
end

function plotfloor(tiles)
    Plots.default(overwrite_figure = false)
    whites = map(t -> Hexagons.center(t[1]), collect(filter(t -> !t[2], tiles)))
    blacks = map(t -> Hexagons.center(t[1]), collect(filter(t -> t[2], tiles)))
    p1 = scatter(
        whites,
        color = "gray",
        reuse = false,
        markershape = :hexagon,
        markersize = 20,
        xlim = (-10, 10),
        ylim = (-10, 10),
    )
    scatter!(
        p1,
        blacks,
        color = "black",
        reuse = false,
        markershape = :hexagon,
        markersize = 20,
        xlim = (-10, 10),
        ylim = (-10, 10),
    )
    display(p1)
end

puzzletestinput = readlines("inputs/day24-test.txt")
puzzleinput = readlines("inputs/day24.txt")

blacksideups(flipall!(placetiles(readinput(puzzleinput)), 100))
