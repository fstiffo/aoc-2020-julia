puzzleinput = readlines("inputs/day13.txt")

earliesttimestamp = parse(Int, puzzleinput[1])

timetable = map(x -> tryparse(Int64, x), split(puzzleinput[2], ","))


# Firt Half

dt(id::Nothing,ets) = typemax(Int64)
dt(id::Int64, ets) =   ((ets ÷ id + 1) * id) - ets
# Calculates the time to next bus id from an earliest time stamp ets


waittimes = [[t dt(t, earliesttimestamp)] for t in timetable]
waittimes = reduce(vcat, waittimes)
# Matrix with in first column bus ids and second colums wait times from
# the earliest time stamp

waittimes = waittimes[sortperm(waittimes[:,2]),:]
# Sort by wait times

waittimes[1,1] * waittimes[1,2]


# Second Half
