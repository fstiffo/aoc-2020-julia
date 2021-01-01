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

struct D8
    tile::Tile
end

Base.iterate(S::D8) = (S.tile, (1, S.tile))

function Base.iterate(S::D8, state)

    if state[1] > 8
        nothing
    elseif isodd(state[1])
        (state[2], (state[1] + 1, state[2]))
    else
        (reverse(state[2], dims=2), (state[1] + 1, rotr90(state[2])))
    end
end

function Base.match(tile₁, tile₂)
    for tile in D8(tile₂)
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


G = SimpleGraph(length(tiles))
combs = collect(Iterators.product(tiles, tiles))
for i in CartesianIndices(combs)
    if i[1] > i[2] && !isnothing(match(combs[i][1], combs[i][2]))
        add_edge!(G, i[1], i[2])
    end
end

bigimg = Matrix{Int}(undef, 12, 12)

function placecorners!(G, bigimg)
    # Find and place corners of the grapgh on the corners of the big picture Matrix

    corners = vertices(G)[degree(G) .== 2]
    opps = [] # Opposite corners
    for (i, v₁) ∈ enumerate(corners)
        for v₂ ∈ corners[i + 1:end]
            if length(a_star(G, v₁, v₂)) > 11
                # The opposite corners are connected with a larger path

                push!(opps, (v₁, v₂))
            end
        end
    end
    bigimg[1,1], bigimg[end,end] = opps[1][1], opps[1][2]
    bigimg[1,end], bigimg[end, 1] = opps[2][1], opps[2][2]
end

function placesides!(G, bigimg)
    # Find vertex that connect corners in the shortes path and 
    # place them on the sides of the big picture Matrix

    side = src.(a_star(G, bigimg[1,1], bigimg[1,end]))
    push!(side, bigimg[1,end])
    bigimg[1,:] = side
    # North side  
    
    side = src.(a_star(G, bigimg[1,end], bigimg[end,end]))
    push!(side, bigimg[end,end])
    bigimg[:,end] = side
    # East side  
    
    side = src.(a_star(G, bigimg[end,1], bigimg[end,end]))
    push!(side, bigimg[end,end])
    bigimg[end,:] = side
    # South side
    
    side = src.(a_star(G, bigimg[1,1], bigimg[end,1]))
    push!(side, bigimg[end,1])
    bigimg[:,1] = side
    # West side  

end

function placeinsides!(G, bigimg)
    # Fill the inside of the big picture matrix starting with the vertex connected 
    # to the north side and proceding with neighbors checking to the south side 

    maxr, maxc = size(bigimg)
    for c ∈ 2:maxc - 1
        we = [bigimg[1,c - 1],bigimg[1,c + 1]]            
        bigimg[2,c] = filter(x -> x ∉ we, neighbors(G, bigimg[1,c]))[1]
    end
    # First row

    for r ∈ 2:maxr - 2
        for c ∈ 2:maxc - 1
            nwe = [bigimg[r - 1,c],bigimg[r,c - 1],bigimg[r,c + 1]]            
            bigimg[r + 1,c] = filter(x -> x ∉ nwe, neighbors(G, bigimg[r,c]))[1]
        end
    end
end


placecorners!(G,bigimg)
placesides!(G,bigimg)
placeinsides!(G,bigimg)







# @enum Dir N = 1 E = 2 S = 3 W = 4

# const edge = [[1, 1:10], [1:10, 10], [10, 1:10], [1:10, 1]]
# # N, E, S, W edges of a tile

# const offset = [(-1, 0), (0, 1), (1, 0), (0, -1)]
# # N, E, S ,W offset of facing tiles

# const opposite = [S,W,N,E]
# # N, E, S, W opposites

# Location = Tuple{Int,Int}
# Arrangement = Dict{Location,Tuple{Int,Tile}}

# mutable struct OpenEdge
#     edge::BitArray{1}  # The open edge is a slice of the tile
#     facingloc::Location   # The location that the open edge is facing
#     dir::Dir           # The direction (N/E/S/W) of the open edge
# end

# function solve(images)
#     # Returns a/the(?) tile arragement that solves the puzzle

#     function push_openedges!(oedges, arrgmt, loc)

#         _, tile = arrgmt[loc]
#         for (dir, off) in enumerate(offset)
#             facingloc = loc .+ off
#             if !haskey(arrgmt, facingloc)
#                 # If there is no tile on facing location

#                 oe = OpenEdge(tile[edge[dir]...], facingloc, Dir(dir))
#                 push!(oedges, oe)
#             end
#         end
#     end

#     function searchmatch(nonused, openedge)

#         for (id, tile) in nonused
#             for t in D8(tile)
#                 oppdir = opposite[Int(openedge.dir)]
#                 if openedge.edge == t[edge[Int(oppdir)]...]
#                     # Mathing must be beetween the opposite edges of tiles

#                     return id, tile
#                 end
#             end
#         end
#         nothing, nothing
#     end

#     nonused = deepcopy(images)
#     arrgmt = Arrangement()

#     id, tile = first(nonused)
#     pop!(nonused, id)
#     arrgmt[(0, 0)] = (id, tile)
#     openedges = OpenEdge[]
#     push_openedges!(openedges, arrgmt, (0, 0))
#     # Every tile is good for start, and any location ( 0, 0 in this case )

#     while !isempty(openedges)
#         oe = popfirst!(openedges)
#         # Pop an open edge off of the queue

#         id, tile = searchmatch(nonused, oe)
#         # Search to see if any non-used tiles have any mactching edge

#         if !isnothing(id)
#             # If there is one

#             pop!(nonused, id)
#             # Remove it from non-used

#             loc = oe.facingloc
#             arrgmt[loc] = (id, tile)
#             # Place the tile at the indicated location

#             push_openedges!(openedges, arrgmt, loc)
#             # Place all of its free edges into the queue
#         end
#     end


#     arrgmt
# end

# puzzleinput = open("inputs/day20-test.txt") do file
#     strip(read(file, String))
# end
# images = readinput(puzzleinput)

# Juno.@enter solve(images)
# sort(unique(keys(s)))    