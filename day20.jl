#= ==========================================================================
This solution is the translation from Python to Julia
of the wondeful solution by Søren Fuglede Jørgensen:

https://github.com/fuglede/adventofcode/blob/master/2020/day20/solutions.py

Thx Søren!
========================================================================== =#

using LinearAlgebra
using LightGraphs

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

struct D8
    tile::Tile
end

Base.iterate(S::D8) = (S.tile, (1, S.tile))

function Base.iterate(S::D8, state)

    if state[1] == 8
        nothing
    elseif isodd(state[1])
        (reverse(state[2], dims=2), (state[1] + 1, rotr90(state[2])))        
    else
        (state[2], (state[1] + 1, state[2]))
    end
end

Base.length(S::D8) = 8

const N, E, S, W = 1, 2, 3, 4
const opposite = [S,W,N,E]

const edge = [[1, :], [:, 10], [10, :], [:, 1]]
# N, E, S, W edges of a tile

const offset = [(-1, 0), (0, 1), (1, 0), (0, -1)]
# N, E, S ,W offset of facing tiles

function Base.match(tile₁, tile₂)
    for tile ∈ D8(tile₂)
        for dir ∈ [N,E,S,W]
            if tile₁[edge[dir]...] == tile[edge[opposite[dir]]...]
                return offset[dir], tile
            end
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
combs = collect(Iterators.product(tiles, tiles))
for i in CartesianIndices(combs)
    if i[1] > i[2] && !isnothing(match(combs[i][1], combs[i][2]))
        add_edge!(G, i[1], i[2])
    end
end

prod(ids[degree(G) .== 2])


# Second Half

puzzleinput = open("inputs/day20.txt") do file
    strip(read(file, String))
end

images = readinput(puzzleinput)

ids = collect(keys(images))
tiles = collect(values(images))
vrtcs = Dict([id => v for (v, id) ∈ enumerate(ids)])

G = SimpleGraph(length(tiles))
combs = collect(Iterators.product(tiles, tiles))
for i in CartesianIndices(combs)
    if i[1] > i[2] && !isnothing(match(combs[i][1], combs[i][2]))
        add_edge!(G, i[1], i[2])
    end
end

root, _ = first(images)
stack = [(root, (0, 0))]
locs = Dict((0, 0) => root)

while !isempty(stack)
    id₁, loc = pop!(stack)
    v₁ = vrtcs[id₁]
    for v₂ ∈ neighbors(G, v₁)
        id₂ = ids[v₂]
        if id₂ ∈ values(locs)
            continue
        end
        off, tile = match(images[id₁], images[id₂])
        images[id₂] = tile # Make sure to update the values of images as we apply a D8 transformation
        newloc = loc .+ off
        push!(stack, (id₂, newloc)) 
        locs[newloc] = id₂
    end
end

bigsz = Int(sqrt(length(images)))
bigimg = BitArray(undef, bigsz * 8, bigsz * 8) 
# 8 and not 10 because the borders of each tile are not part of the actual image

offsetrc = (minimum([r for (r, _) ∈ keys(locs)]), minimum([c for (_, c) ∈ keys(locs)]))

for i ∈ 0:bigsz - 1
    for j ∈ 0:bigsz - 1
        id = locs[(i, j) .+ offsetrc]

        tile = images[id][2:end - 1,2:end - 1]
        bigimg[1 + i * 8:(i + 1) * 8, 1 + j * 8:(j + 1) * 8] = tile
        # The borders of each tile are not part of the actual image

    end
end

# using Images
# using ImageView

# imshow(.!(bigimg))

monster = """
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   """
monster = hcat((collect.(split(monster, "\n")))...) |> rotr90
mask = BitArray(map(c -> c == '#', hcat(monster)))

# imshow(.!(mask))

function countmonsters(big)
    s = 0
    masksz = size(mask)
    max = size(big) .- masksz .+ 1
    for i in 1:max[1]
        for j in 1:max[2]
            masked = big[i:i + masksz[1] - 1,j:j + masksz[2] - 1]
            m = (masked .>= mask)
            if all(masked .>= mask)
                s += 1
            end
        end
    end
    s
end

count = maximum(map(countmonsters, [b for b ∈ D8(bigimg)]))
sum(bigimg) - count * sum(mask)