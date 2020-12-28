puzzleinput = readlines("inputs/day13.txt")

earliesttimestamp = parse(Int, puzzleinput[1])

timetable = map(x -> tryparse(Int64, x), split(puzzleinput[2], ","))


# Firt Half

dt(id::Nothing, ets) = typemax(Int64)
dt(id::Int64, ets) = ((ets ÷ id + 1) * id) - ets
# Calculates the time to next bus id from an earliest time stamp ets


waittimes = [[t dt(t, earliesttimestamp)] for t in timetable]
waittimes = reduce(vcat, waittimes)
# Matrix with in first column bus ids and
# in second colums wait times from the earliest time stamp

waittimes = waittimes[sortperm(waittimes[:, 2]), :]
# Sort by wait times

waittimes[1, 1] * waittimes[1, 2]


# Second Half

function findets(tt)
    ids = filter((!) ∘ isnothing, tt)

    departs = [i - 1 for i = 1:length(tt) if !isnothing(tt[i])]
    # Minutes after 0 at which each bus in the time table has to depart

    dt = 1
    t = ids[1]

    for (i,id) in enumerate(ids)
        while true
            if (t + departs[i]) % id == 0
                dt *= id
                # Given the fact that ids are all prime numbers:
                # if the depart of bus ids[i] is ok a this time stamp t
                # then the times stamp for the subsequent in
                # the time table (eg. ids[i+1]) has to be necessarily
                # t + n * ids[i] * ids[i+1] + departs[i],
                # if we want it to be ok also for the previous ids

                break
            else
                t += dt
            end
        end
    end

    return t
end

@time findets(timetable)

# With input:
# 17,x,x,x,x,x,x,41,x,x,x,37,x,x,x,x,x,367,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19,x,x,x,23,x,x,x,x,x,29,x,613,x,x,x,x,x,x,x,x,x,x,x,x,13
# in Wolfram Alpha you could type this to obtain the solution
#  {41x_2-17x_1=7;37x_3-17x_1=11;367x_4-17 x_1=17;19x_5- 17x_1=36;23x_6-17x_1=40;29x_7-17 x_1=46;613 x_8-17x_1=48;13 x_9-17x_1=61} integer solution
