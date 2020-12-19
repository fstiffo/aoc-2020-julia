using DataStructures

puzzleinput = readlines("inputs/day07.txt")

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

function parse_rules!(rules::Dict{String,Accumulator{String,Int64}}, s::String)
    m = match(r"(.+) bags contain (.+).", s)
    rules[m[1]] = Accumulator(parse_contents(m[2]))
end

rules = Dict{String,Accumulator{String,Int64}}()
(s -> parse_rules!(rules, s)).(puzzleinput)

function test()
    can_contain = Set()
    for (color, contents) in rules
        if isempty(contents) || color == "shiny gold"
            continue
        end
        no_more = false
        considered = Set()
        println(color)
        cont = deepcopy(contents)
        while !no_more
            if cont["shiny gold"] > 0
                no_more = true
                push!(can_contain, color)
            else
                for (c, n) in cont
                    no_more = true
                    if !(c ∈ considered)
                        no_more = false
                        push!(considered, c)
                        merge!(cont, rules[c])
                    end
                end
            end
        end
    end
    can_contain
end

test()

count(r -> r[2]["shiny gold"] > 0, rules)riu
