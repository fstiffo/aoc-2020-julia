using DataStructures


puzzleinput_a = readlines("inputs/day19a.txt")


Symbl = Union{Int,Char}
Rule = Array{Array{Symbl,1},1}


import Base.parse

parse(::Type{Symbl}, str::AbstractString) = '"' ∈ str ? str[2] : parse(Int, str) + 1

function parse(::Type{Rule}, str::AbstractString)
    f(s) = parse.(Symbl, split(strip(s), " "))
    f.(split(str, "|"))
end

rules = fill(Rule(), 132)
function parse_line!(rules, l)
    s = split(l, ":")
    rules[parse(Int, s[1])+1] = parse(Rule, s[2])
end


for l in puzzleinput_a
    parse_line!(rules, l)
end

mutable struct State
    symlst::Vector{Symbl}
    ltrpos::Int
end


function topdown(rules, str)

    posslst = [State([1], 1)]
    # Set up possibility list

    while true
        if isempty(posslst)
            # If possibility list is empty the parsing is no possbile

            return false
        end
        c = pop!(posslst)
        # Get the state c: first element of the possibility list

        if isempty(c.symlst)
            if c.ltrpos == length(str) + 1
                # If the symbol list in state c is is empty and algorithm
                # reached the last char in string then parsing succeeds

                return true
            end
        else
            fstsym = c.symlst[1]
            deleteat!(c.symlst, 1)
            if isa(fstsym, Char)
                if fstsym == str[c.ltrpos]
                    # The first symbol is a lexical symbol

                    newc = State(c.symlst, c.ltrpos + 1)
                    push!(posslst, newc)
                end
            else
                # The first symbol is a nom-terminal

                for r in rules[fstsym]
                    newc = State([r; c.symlst], c.ltrpos)
                    push!(posslst, newc)
                end
            end
        end
    end
end

puzzleinput_b = readlines("inputs/day19b.txt")
sum([topdown(rules, s) for s in puzzleinput_b])
