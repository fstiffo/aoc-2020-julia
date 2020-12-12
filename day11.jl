puzzleinput = map(collect, readlines("inputs/day11.txt"))
puzzleinput = hcat(puzzleinput...)
puzzleinput = map(c -> c == 'L' ? 1 : 0, puzzleinput)
puzzleinput = permutedims(puzzleinput)


# First Half

shiftl(a) = hcat(a[:, 2:end], fill(0, (size(a)[1], 1)))
shiftr(a) = hcat(fill(0, (size(a)[1], 1)), a[:, 1:end-1])
shiftu(a) = vcat(a[2:end, :], fill(0, (1, size(a)[2])))
shiftd(a) = vcat(fill(0, (1, size(a)[2])), a[1:end-1, :])
# Shift left, right, up and down an array a filling the new cells with 0

function newoccupied1(o, l)
    # Starting from occupied o, returns new occupied after one round of the rules
    # The seat layout is l

    ao =
        shiftl(o) +
        shiftr(o) +
        shiftu(o) +
        shiftd(o) +
        shiftl(shiftd(o)) +
        shiftr(shiftd(o)) +
        shiftr(shiftu(o)) +
        shiftl(shiftu(o))
    # Calculates how many adjacent are occupied for all the places

    function rule(i)
        if o[i] == 0 && l[i] == 1 && ao[i] == 0
            # If a seat is empty (0) and there are no occupied seats adjacent to it,
            # the seat becomes occupied.
            1
        elseif o[i] == 1 && ao[i] > 3
            # If a seat is occupied (1) and four or more seats adjacent to it are
            # also occupied, the seat becomes empty.
            0
        else
            # Otherwise, the seat's state does not change.
            o[i]
        end
    end

    map(rule, CartesianIndices(l))
    # Apply the rule to all the places
end

occupied = fill(0, size(puzzleinput))
while true
    no = newoccupied1(occupied, puzzleinput)
    if no == occupied
        # Exit when further applications of the rules cause no seats to change state
        break
    end
    global occupied = no
end

sum(occupied)


# Second Half

function newoccupied2(o, l)
    # Starting from occupied o, returns new occupied after one round of the rules
    # The seat layout is l
    function sees(i)
        # Calculates how many first seats in each direction from place i
        # are occupied
        ij = [0; 0]
        ij[1] = i[1]
        ij[2] = i[2]
        m = [size(o)[1]; size(o)[2]]
        occ = 0
        for di = -1:1
            for dj = -1:1
                if di == 0 && dj == 0
                    continue
                end
                d = [di; dj]
                dij = ij + [di; dj]
                while dij[1] > 0 && dij[2] > 0 && dij[1] <= m[1] && dij[2] <= m[2]
                    if l[dij[1], dij[2]] == 1 # There is a seat in the layout
                        if o[dij[1], dij[2]] == 1 # And is occupied
                            occ = occ + 1
                        end
                        break
                    end
                    dij = dij + d
                end
            end
        end
        occ
    end

    ao = map(sees, CartesianIndices(l))
    # Calculates how many first seat in each direction are occupied
    # for all the places

    function rule(i)
        if o[i] == 0 && l[i] == 1 && ao[i] == 0
            # If a seat is empty (0) and there are no occupied seats adjacent to it,
            # the seat becomes occupied.
            1
        elseif o[i] == 1 && ao[i] > 4
            # If a seat is occupied (1) and five or more visible occupied seats are
            # also occupied, the seat becomes empty.
            0
        else
            # Otherwise, the seat's state does not change.
            o[i]
        end
    end

    map(rule, CartesianIndices(l))
    # Apply the rule to all the places
end

occupied = fill(0, size(puzzleinput))
while true
    no = newoccupied2(occupied, puzzleinput)
    if no == occupied
        # Exit when further applications of the rules cause no seats to change state
        break
    end
    global occupied = no
end

sum(occupied)
