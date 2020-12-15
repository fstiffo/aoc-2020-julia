using DelimitedFiles

puzzleinput = readdlm("inputs/day15.txt", ',', Int)

spoken = Dict{UInt32,UInt32}()
for i in eachindex(puzzleinput[1:end-1])
    spoken[puzzleinput[i]] = i
end
# Preparation of the game: every elf says is number, that is the puzzleinput.

lstspkn = last(puzzleinput)
start = length(spoken) + 1
stop = 29999999 # For first half set stop to 2019

@time for turn = start:stop
    # Game loop

    if (haskey(spoken, lstspkn))
        # Had the last number spoken also been spoken before?

        spknbfr = spoken[lstspkn]
        newnumber = turn - spknbfr

        # Yes, then he next number to speak is the difference between
        # the turn number when it was last spoken (actual turn - 1) and the
        # turn number the time it was most recently spoken before then

        # The elf says the next number
    else
        newnumber = 0
        # No, is a new numbers then the elf says "0"

    end
    spoken[lstspkn] = turn
    global lstspkn = newnumber
end

lstspkn
