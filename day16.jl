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
    for l in inpt[27:end]
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

    notvalidsum(tkt) = sum(push!([fval for fval in tkt if !isvalid(fval)],0))
    # Sum of tha values in invalid fields for a ticket

    sum(notvalidsum.(tix))
end

tkt_scan_err_rate(neartix, ranges)


# Second Half


# struct TicketRanges
#     deploc::Ranges
#     depsta::Ranges
#     depplt::Ranges
#     deptrk::Ranges
#     depdat::Ranges
#     deptim::Ranges
#     arrloc::Ranges
#     arrsta::Ranges
#     arrplt::Ranges
#     arrtrk::Ranges
#     class::Ranges
#     durat::Ranges
#     price::Ranges
#     route::Ranges
#     row::Ranges
#     seat::Ranges
#     train::Ranges
#     type::Ranges
#     wagon::Ranges
#     zone::Ranges
# end
