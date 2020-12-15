using DelimitedFiles

puzzleinput = readdlm("inputs/day15.txt", ',', Int)

function play(startingnums, numofturns)

    spoken = Array{Int,1}

    for i in eachindex(startingnums[1:end-1])
        spoken[startingnums[i]] = i
    end
    # Preparation of the game: every elf says is number, that is the puzzleinput.

    lstspkn = last(startingnums)
    display(lstspkn)
    start = length(startingnums)
    stop = numofturns - 1

    turn = start
    while true
        # Game loop


        spknbfr = get(spoken, lstspkn, 0)
        # Had the last number spoken also been spoken before?

        newnumber = spknbfr > 0 ? turn - spknbfr : 0
        # Yes, then he next number to speak is the difference between
        # the turn number when it was last spoken (actual turn - 1) and resize!the
        # turn number the time it was most recently spoken before then

        # No, is a new numbers then the elf says "0"

        spoken[lstspkn] = turn
        lstspkn = newnumber
        # Now the elf says the number
        if turn < stop
            turn += 1
        else
            return lstspkn
        end
    end

end

@time play(puzzleinput, 30000000)


|
resize!
