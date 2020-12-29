using DelimitedFiles

function givessum(list, sum)
    # Returns the first pair of numbers in the list that summed gives sum,
    # returns nothing is there is no one that satisfies

    for (i, n) in enumerate(list)
        for m in list[i+1:end]
            if n + m == sum
                return n, m
            end
        end
    end
    nothing
end


# First Half

function firstinvalid(list, preamble_len)
    # Return first invalid number, if none returns nothing.

    for (i, n) in enumerate(list[preamble_len+1:end])
        if isnothing(givessum(list[i:i+preamble_len - 1], n))
            # XMAS starts by transmitting a preamble of preamble_len numbers.
            # After that, each number you receive should be the sum of any two of
            # the preamble_len immediately previous numbers.

            return n
        end
    end
    nothing
end

puzzleinput = readdlm("inputs/day09.txt", Int)
firstinvalid(puzzleinput, 25)
