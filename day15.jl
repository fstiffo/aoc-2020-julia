using DelimitedFiles

puzzleinput = readdlm("inputs/day15.txt", ',', Int)

spoken = Base.Dict{UInt32,UInt32}()
for i in eachindex(puzzleinput[1:end-1])
    spoken[puzzleinput[i]] = i
end
# Preparation of the game: every elf says is number, that is the puzzleinput.

lstspkn = last(puzzleinput)
start = length(spoken) + 1
stop = 29999999 # For first half set stop to 2019

@time for turn = start:stop
    # Game loop

    spknbfr = get(spoken, lstspkn, 0)
    # Had the last number spoken also been spoken before?

    newnumber = spknbfr > 0 ? turn - spknbfr : 0
    # Yes, then he next number to speak is the difference between
    # the turn number when it was last spoken (actual turn - 1) and the
    # turn number the time it was most recently spoken before then

    # No, is a new numbers then the elf says "0"

    spoken[lstspkn] = turn
    global lstspkn = newnumber
    # Now the elf says the number
    
end

lstspkn
