
mutable struct Tile
    id::Int
    👆::UInt16
    👉::UInt16
    👇::UInt16
    👈::UInt16
    score::Int
end

tile_side_reverse(n::UInt16) = bitreverse(n) >> 6
# The shift is necessary because tile size is 10 bits

function flip!(t::Tile)
    # Flip around up/down axe

    t.👈, t.👉 = t.👉, t.👈
    t.👆 = tile_side_reverse(t.👆)
    t.👇 = tile_side_reverse(t.👇)
end

function rotate!(t::Tile)
    # Rotate clockwise,

    t.👆, t.👉, t.👇, t.👈 = t.👈, t.👆, t.👉, t.👇

    t.👆 = tile_side_reverse(t.👆)
    t.👇 = tile_side_reverse(t.👇)
    # Reverse is necessary because sides are read as binary number
    # from left to right on the 👆 and 👇 sides and
    # from top to bottom on the 👈 and 👉
end

board = Matrix{Tile}(undef, 3, 3)

puzzleinput = readlines("inputs/day20-test.txt")

function readinput!(board, inp)
    function p2b(s)
        # Convert pattern of tje side of a tile in binary number

        s = replace(s, r"#" => "1")
        s = replace(s, r"\." => "0")
        parse(UInt16, s, base = 2)
    end

    l = 1
    i = 1
    while true
        m = match(r"Tile (\d+):", inp[l])
        id = parse(Int, m[1])
        l += 1
        👆 = inp[l]
        👈 = 👆[1:1]
        👉 = 👆[end:end]
        l += 1
        for j = l:l+8
            👈 *= inp[j][1]
            👉 *= inp[j][end]
        end
        l += 8
        👇 = inp[l]
        board[i] = Tile(id, p2b(👆), p2b(👉), p2b(👇), p2b(👈), 0)
        if i == 3 * 3
            break
        end
        i += 1
        l += 2
    end
    print(i)
end



b = board[1]

# flip!(b)
# println(
#     bitstring(b.👆)[7:end],
#     " ",
#     bitstring(b.👉)[7:end],
#     " ",
#     bitstring(b.👇)[7:end],
#     " ",
#     bitstring(b.👈)[7:end],
#     " ",
# )



function upscore!(b, t)
    # Update score of tile t in board begin

    sz = size(board, 1) # Board side size

    function neighbors_sides(t)
        # Returns the neighborhood of a tile

        (i, j) = Tuple(CartesianIndices(b)[t])
        if j > 1
            👈 = b[i, j-1].👉 #
        end
        if j < sz
            👉 = b[i, j+1].👈
        end
        if i > 1
            👆 = b[i-1, j].👇
        end
        if i < sz
            👇 = b[i+1, j].👆
        end
        if j == 1 # Left side tiles
            👈 = b[i, j].👈
        end
        if j == sz # Righ side tiles
            👉 = b[i, j].👉
        end
        if i == 1 # Top side tiles
            👆 = b[i, j].👆
        end
        if i == sz # Bottom side tiles
            👇 = b[i, j].👇
        end

        return (👆 = 👆, 👉 = 👉, 👇 = 👇, 👈 = 👈)
    end

    ns = neighbors_sides(t)
    b[t].score = sum([b[t].👆 == ns.👆, b[t].👉 == ns.👉, b[t].👇 == ns.👇, b[t].👈 == ns.👈])
end

function solve!(b)

    function manip!(t)
        # Try rotations and flip until a best score

        maxs = upscore!(b, t)
        for i = 1:3
            rotate!(b[t])
            if upscore!(b, t) == 4
                return b[t].score
            end
            if b[t].score > maxs
                maxs = b[t].score
            end
        end
        flip!(b[t])
        for i = 1:4
            if upscore!(b, t) == 4
                return b[t].score
            end
            if b[t].score > maxs
                maxs = b[t].score
            end
            rotate!(b[t])
        end

        return maxs
    end


    for t in eachindex(b)
        upscore!(b, t)
    end

    sz = length(board)
    again = true

    while again
        again = false
        for t in eachindex(b)
            for d = t+1:sz
                score = b[t].score + b[d].score
                if score < 8

                    old_t, old_d = deepcopy(b[t]), deepcopy(b[d])

                    b[t], b[d] = b[d], b[t]
                    newscore = manip!(t) + manip!(d)
                    if newscore <= score
                        b[t], b[d] = old_t, old_d
                    else
                        again = true
                        break
                    end
                end
            end
        end
        display(map(t -> t.score, b))
    end
end


readinput!(board, puzzleinput)
solve!(board)

for t in board
    println(t.score)
end
