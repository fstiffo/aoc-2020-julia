puzzleinput_a = readlines("inputs/day19a.txt")

Symbl = Union{Int,Char}
Rule = Array{Array{Symbl,1},1}

import Base.parse

parse(::Type{Symbl}, str::AbstractString) = '"' ∈ str ? str[2] : parse(Int, str) + 1

function parse(::Type{Rule}, str::AbstractString)
    f(s) = parse.(Symbl, split(strip(s), " "))
    f.(split(str, "|"))
end

function parse_line!(rules, l)
    s = split(l, ":")
    rules[parse(Int, s[1]) + 1] = parse(Rule, s[2])
end

mutable struct State
    symlst::Vector{Symbl}
    ltrpos::Int
end

function topdown(rules, str)
    # Top down parser 
    
    posslst = [State([1], 1)]
    # Set up possibility list

    while true
        if isempty(posslst)
            # If possibility list is empty the parsing is no possible

            return false
        end
        c = pop!(posslst)
        # Get the state c: first element of the possibility list

        if c.ltrpos == length(str) + 1 && !isempty(c.symlst)
            # If the algorithm reached the last char but the possibility
            # list is not empty the parsing is not possible

            return false
        end

        if isempty(c.symlst)
            if c.ltrpos == length(str) + 1
                # If the symbol list in state c is is empty and algorithm
                # reached the last char in string then parsing succeeds

                return true
            end
        else
            fstsym = popfirst!(c.symlst)
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


# First Half

rules1 = fill(Rule(), 132)
for l in puzzleinput_a
    parse_line!(rules1, l)
end

puzzleinput_b = readlines("inputs/day19b.txt")
sum([topdown(rules1, s) for s in puzzleinput_b])


# Second Half

rules2 = fill(Rule(), 132)
for l in puzzleinput_a
    parse_line!(rules2, l)
end

rules2[9] = [[43], [43, 9]]
rules2[12] = [[43, 32], [43, 12, 32]]

sum([topdown(rules2, s) for s in puzzleinput_b])
