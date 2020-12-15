using DelimitedFiles

puzzleinput = readdlm("inputs/day15.txt", ',', Int)

function play(startingnums, numofturns)

    spoken = fill(-1, numofturns)

    for i in eachindex(startingnums[1:end-1])
        spoken[startingnums[i]+1] = i
    end
    # Preparation of the game: every elf says is number, that is the puzzleinput.

    lstspkn = last(startingnums)
    turn = length(startingnums)
    stop = numofturns - 1
    while true
        # Game loop

        newnumber = spoken[lstspkn+1] > 0 ? turn - spoken[lstspkn+1] : 0
        # Had the last number spoken also been spoken before?

        # Yes, then the next number to speak is the difference between
        # the turn number when it was last spoken (actual turn - 1) and
        # the turn number the time it was most recently spoken before then

        # No, is a new numbers then the elf says "0"

        spoken[lstspkn+1] = turn
        lstspkn = newnumber
        # Now the elf says the number

        if turn < stop
            turn += 1
        else
            return lstspkn
        end
    end

end


# First Half

@time play(puzzleinput, 2020)


# Second Half

@time play(puzzleinput, 30000000)
