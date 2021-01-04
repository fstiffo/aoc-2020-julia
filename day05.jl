function rowcol(s)
    # Find row and col of the seatid

    rowpart = s[1:7]
    rowpart = replace(rowpart, "B" => "1")
    rowpart = replace(rowpart, "F" => "0")
    colpart = s[8:end]
    colpart = replace(colpart, "R" => "1")
    colpart = replace(colpart, "L" => "0")
    rowbin, colbin = parse(UInt8, rowpart, base=2), parse(UInt8, colpart, base=2)
    Int.((rowbin & UInt(127), colbin & UInt(7)))
end

seatid((row, col)) = row * 8 + col
# Every seat also has a unique seat ID: multiply the row by 8, then add the column



# First Half

puzzeinput = readlines("inputs/day05.txt")
maximum(map(seatid ∘ rowcol, puzzeinput))


# Second Half

function missingid(strs)

    rowcols = map(rowcol, strs)
    filter!(rc -> rc[1] > 0 && rc[1] < 127, rowcols)
    # Removes very front and very back rows, because your seat wasn't
    # at the very front or back

    sorted_ids = map(seatid, rowcols) |> sort
    for (i, id) in enumerate(sorted_ids)
        if sorted_ids[i + 1] ≠ id + 1
            # Missing ID found

            return id + 1
        end
    end
end

puzzeinput = readlines("inputs/day05.txt")
missingid(puzzeinput)
