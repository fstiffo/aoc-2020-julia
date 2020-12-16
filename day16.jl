using DelimitedFiles

puzzleinput = readlines("inputs/day16.txt")

Ranges = NamedTuple{(:fld, :rng),Tuple{String,Array{UnitRange{Int}}}}

function readinput(inpt::Vector{String})

    ranges = []

    function torange(s1, s2)::UnitRange{Int}
        atoi(s) = parse(Int, s)
        UnitRange(atoi(s1), atoi(s2))
    end

    for l in inpt[1:20]
        m = match(r"([^:]+): (\d+)-(\d+) or (\d+)-(\d+)", l)
        rng = [torange(m[2], m[3]), torange(m[4], m[5])]
        push!(ranges, (fld = m[1], rng = rng))
    end

    yourtkt = parse.(Int,split(inpt[23],","))

    nearbytix = []
    for l in inpt[26:end]
        push!(nearbytix, parse.(Int,split(l,",")))
    end

    return ranges,yourtkt,nearbytix
end

ranges, yourtkt, neartix = readinput(puzzleinput)


# First Half

function tkt_scan_err_rate(tix, rngs)
    # Returns the ticket scanning error for tickets in tix and
    # rules of ticket fields in rngs

    isvalid(fval) = foldl(|,[ fval ∈ rs.rng[1] || fval ∈ rs.rng[2] for rs in rngs ])
    # The field in a ticket is invalid nearby if contains values
    # that are not valid for any field

    sumofnotvalid(tkt) = sum(push!([fval for fval in tkt if !isvalid(fval)],0))
    # Sum of tha values in invalid fields for a ticket

    sum(sumofnotvalid.(tix))
end

tkt_scan_err_rate(neartix, ranges)


# Second Half

function fldspos(tix, rngs, fldrngs)
    # Returns an array with the positions in the ticket
    # for the fields in field ranges

    isvalid(fval) = foldl(|,[ fval ∈ rs.rng[1] || fval ∈ rs.rng[2] for rs in rngs ])
    isok(ticket) = foldl(&, [isvalid(fval) for fval in ticket])
    # True if the ticket does not contain invalid values

    tixok = tix[isok.(tix)]
    # Valid tickets


    function check(c, f, tickets)
        # For every value in column c of ticket matrix checks
        # if satisfy the ranges for field f

        col = hcat(tickets...)[c,:]
        #Select column c of the matrix

        foldl(&,[ v ∈ f.rng[1] || v ∈ f.rng[2] for v in col ])
    end

    colsgoodforfld = Dict{String,Set{Int}}()
    numofcols = length((hcat(tix...)[:,1]))
    for f in rngs
        # For every field in the rules collects, in a set, the columns
        # in the ticket matrix that have all values valid

        colsgoodforfld[f.fld] = Set()
        for c in 1:numofcols
            if check(c, f, tixok)
                push!(colsgoodforfld[f.fld],c)
            end
        end
    end

    function sievecols(colsgoodforfld)
        # Filter the cols good for a field untils only one remains for field

        function sieve_(todo, done)
            if length(todo) == 0
                return done
            end
            s = findfirst(x->length(x)==1, todo)
            if (isnothing(s))
                return done
            else
               singleton = todo[s]
               u = unique(singleton)[1]
               done[s] = u
               delete!(todo, s)
               for (f,cols) in todo
                   delete!(cols, u)
               end
               sieve_(todo,done)
           end
        end
        ∅ = Dict()
        sieve_(colsgoodforfld,∅)
    end

    positions = sievecols(colsgoodforfld)

    [ unique(positions[f.fld])[1] for f in fldrngs if haskey(positions, f.fld) ]
end

@time prod(yourtkt[fldspos(neartix, ranges, ranges[1:6])])
