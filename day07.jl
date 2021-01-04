using LightGraphs
using DataStructures

function readinput(strs)

    function parse_contents(s)::Dict{String,Int}
        contents = Dict{String,Int}()
        bs = split(s, ",")
        if bs[1] == "no other bags"
            return contents
        else
            for b in bs
                m = match(r".*(\d+)\s(.+) bag.*", b)
                contents[m[2]] = parse(Int, m[1])
            end
        end
        contents
    end

    function parse_rules!(rules, vertex, s)
        m = match(r"(.+) bags contain (.+).", s)
        rules[m[1]] = (vertex = vertex, contents = parse_contents(m[2]))
        m[1]
    end

    rules = Dict{String,@NamedTuple{vertex::Int, contents::Dict{String,Int64}}}()
    vtxclr = Vector{String}(undef, length(strs))

    for (i, s) in enumerate(strs)
        vtxclr[i] = parse_rules!(rules, i, s)
    end

    rulesgrf = SimpleDiGraph(length(strs))

    for (_, r) in rules
        rv = r.vertex
        cs = r.contents
        for (color, _) in pairs(r.contents)
            add_edge!(rulesgrf, rv, rules[color].vertex)
        end
    end

    return rules, vtxclr, rulesgrf
end


# First Half

function howmany_contains(rules, vtxclr, rulesgrf, color)

    function add_predecessors!(v, preds)

        inns = inneighbors(rulesgrf, v)

        if isempty(inns)
            return
        end
        push!(preds, inns...)

        for nv in inns
            add_predecessors!(nv, preds)
        end
        return
    end

    v = rules[color].vertex
    containers = Set()
    add_predecessors!(v, containers)
    length(containers)
end

puzzleinput = readlines("inputs/day07-test.txt")
(rules, vtxclr, rulesgrf) = readinput(puzzleinput)

howmany_contains(rules, vtxclr, rulesgrf, "shiny gold")


# Second Half

function howmany_inside(rules, color)

    function howmany_inside(color)

        contents = rules[color].contents

        if isempty(contents)
            return 0
        end
        count = sum(counter(contents))

        for (c, q) in contents
            count += q * howmany_inside(c)
        end
        return count
    end

    howmany_inside(color)
end


puzzleinput = readlines("inputs/day07.txt")
(rules, vtxclr, rulesgrf) = readinput(puzzleinput)

howmany_inside(rules, "shiny gold")
