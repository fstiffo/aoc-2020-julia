using DelimitedFiles
# First Half

puzzleinput = map(collect, readlines("inputs/day11.txt"))
puzzleinput = hcat(puzzleinput...)
puzzleinput = map(c -> c == 'L' ? 1 : 0, puzzleinput)
puzzleinput = permutedims(puzzleinput)

# Shift left, right, up and down an array filling the new cells with 0
shiftl(a) = hcat(a[:, 2:end], fill(0, (size(a)[1], 1)))
shiftr(a) = hcat(fill(0, (size(a)[1], 1)), a[:, 1:end-1])
shiftu(a) = vcat(a[2:end, :], fill(0, (1, size(a)[2])))
shiftd(a) = vcat(fill(0, (1, size(a)[2])), a[1:end-1, :])

# Starting from occupied o, returns new occupied after one round of the rules
# The seat layout is l
function newoccupied1(o, l)
    # Calculates how many adjacent are occupied for all the places
    ao =
        shiftl(o) +
        shiftr(o) +
        shiftu(o) +
        shiftd(o) +
        shiftl(shiftd(o)) +
        shiftr(shiftd(o)) +
        shiftr(shiftu(o)) +
        shiftl(shiftu(o))
    function rule(i)
        # If a seat is empty (0) and there are no occupied seats adjacent to it,
        # the seat becomes occupied.
        if o[i] == 0 && l[i] == 1 && ao[i] == 0
            1
            # If a seat is occupied (1) and four or more seats adjacent to it are
            # also occupied, the seat becomes empty.
        elseif o[i] == 1 && ao[i] > 3
            0
            # Otherwise, the seat's state does not change.
        else
            o[i]
        end
    end
    # Apply the rule to all the places
    map(rule, CartesianIndices(l))
end

occupied = fill(0, size(puzzleinput))
while true
    no = newoccupied1(occupied, puzzleinput)
    # Exit when further applications of the rules cause no seats to change state
    if no == occupied
        break
    end
    global occupied = no
    global i = i + 1
end

sum(occupied)
