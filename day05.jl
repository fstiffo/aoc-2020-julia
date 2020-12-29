function binparts(s)
    rowbinpart = s[1:7]
    rowbinpart = replace(rowbinpart,"B" => "1")
    rowbinpart = replace(rowbinpart, "F" => "0")
    colbinpart = s[8:end]
    colbinpart = replace(colbinpart,"R"=>"1")
    colbinpart = replace(colbinpart,"L"=>"0")
    parse(UInt8, rowbinpart, base = 2), parse(UInt8, colbinpart, base = 2)
end


# First Half

function highestid(strs)
    binarypartions = map(binparts, strs)

    function seatid((rowbinpart, colbinpart))
        (row, col) = rowbinpart & UInt(127), colbinpart & UInt(7)
        # Find row and col of the seatid

        Int(row) * 8 + Int(col)
        # Every seat also has a unique seat ID:  multiply the row by 8,
        # then add the column

    end

    maximum(map(seatid, binarypartions))
end

puzzeinput = readlines("inputs/day05.txt")
highestid(puzzeinput)
