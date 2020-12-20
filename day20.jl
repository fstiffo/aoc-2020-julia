
mutable struct Tile
    id::Int
    👇::UInt16
    👉::UInt16
    👆::UInt16
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

    t.👇, t.👉, t.👆, t.👈 = t.👈, t.👇, t.👉, t.👆

    t.👆 = tile_side_reverse(t.👆)
    t.👇 = tile_side_reverse(t.👇)
    # Reverse is necessary because sides are read as binary number
    # from left to right on the 👆 and 👇 sides and
    # from top to bottom on the 👈 and 👉
end

board = Matrix{Tile}(undef, 3, 3)

puzzleinput = readlines("inputs/day20-test.txt")

function readinput!(board, inp)
    l = 1
    i = 1
    while true
        match(r"Tile: (\d+):", inp[l])
        board[i].id = parse(int,m[1])
        l += 1
        top = inp[l]
        left = top[1:1]
        right = top[end:end]
        l +=1
        for j in l:l+8
            push!(left, inp[l][1])
            push!(right, inp[l][end])
        end
        l += 9
        bot = inp[l]
        push!(left, bot[1])
        push!(right, bot[end])
        board[i].

    end
end
