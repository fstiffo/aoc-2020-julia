using DelimitedFiles

function givessum(list, sum)
    # Returns the first pair of numbers in the list that summed gives sum,
    # returns nothing is there is no one that satisfies

    for (i, n) in enumerate(list)
        for m in list[i + 1:end]
            if n + m == sum
                return n, m
            end
        end
    end
    nothing
end

function firstinvalid(list, pmblsz)
    # Returns first invalid number, if none returns nothing.

    for (i, n) ∈ enumerate(list[pmblsz + 1:end])
        if isnothing(givessum(list[i:i + pmblsz - 1], n))
            # XMAS starts by transmitting a preamble of pmblsz numbers.
            # After that, each number you receive should be the sum of any two of
            # the pmblsz immediately previous numbers.

            return n
        end
    end
    nothing
end


# First Half

puzzleinput = readdlm("inputs/day09.txt", Int)
firstinvalid(puzzleinput, 25)


# Second Half

function findweakness(list, pmblsz)
    # Returns the encryption weakness in your XMAS-encrypted list of numbers,
    # if nonte returns nothing

    invalnum = firstinvalid(list, pmblsz)
    if !isnothing(invalnum)
        for i ∈ 1:length(list) - 1
            for j ∈ i + 1:length(list)
                contigset = list[i:j]
                if sum(contigset) == invalnum
                    # Find a contiguous set of at least two numbers in your list
                    # which sum to invalnum (the invalid number found before)

                    return minimum(contigset) + maximum(contigset)
                    # To find the encryption weakness, add together the smallest
                    # and largest number in this contiguous set

                end
            end
        end
    end
    nothing
end

puzzleinput = readdlm("inputs/day09.txt", Int)
findweakness(puzzleinput, 25)
