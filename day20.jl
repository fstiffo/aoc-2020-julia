using LinearAlgebra
using LightGraphs
using GraphPlot

Tile = BitArray{2}
Tiles = Dict{Int,Tile}

function readinput(str)
    tiles = Tiles()

    blocks = split(str, "\n\n")
    for b in blocks
        bls = split(b, "\n")
        m = match(r"Tile (\d+):", bls[1])
        n = parse(Int, m[1])
        tiles[n] = Tile(transpose(hcat([[c == '#' for c in l] for l in bls[2:end]]...)))
    end
    tiles
end

struct Symmetries
    tile::Tile
end

Base.iterate(S::Symmetries) = (S.tile, (1, S.tile))

function Base.iterate(S::Symmetries, state)

    if state[1] > 8
        nothing
    elseif isodd(state[1])
        (state[2], (state[1] + 1, state[2]))
    else
        (reverse(state[2], dims = 2), (state[1] + 1, rotr90(state[2])))
    end
end

function Base.match(tile₁, tile₂)
    for tile in Symmetries(tile₂)
        if tile₁[1, :] == tile[end, :]
            return (-1, 0), tile
        elseif tile₁[end, :] == tile[1, :]
            return (1, 0), tile
        elseif tile₁[:, end] == tile[:, 1]
            return (0, 1), tile
        elseif tile₁[:, 1] == tile[:, end]
            return (0, -1), tile
        end
    end
    nothing
end


# First Half

puzzleinput = open("inputs/day20.txt") do file
    strip(read(file, String))
end

images = readinput(puzzleinput)

ids = collect(keys(images))
tiles = collect(values(images))


G = SimpleGraph(length(tiles))
combs = collect(Iterators.product(tiles,tiles))
for i in  CartesianIndices(combs)
    if i[1] > i[2] && !isnothing(match(combs[i][1],combs[i][2]))
        add_edge!(G, i[1], i[2])
    end
end

prod(ids[degree(G) .== 2])
