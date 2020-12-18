puzzleinput = readlines("inputs/day18.txt")

# First Half

struct My1
    val::Int
end
# Define my numbers that follow different rules


import Base.+, Base.-

+(x::My1, y::My1) = My1(x.val + y.val)
# My numbers adds like regular ones

-(x::My1, y::My1) = My1(x.val * y.val)
# For my numbers '*' has the same precedence of '-'
# so to mantain precedence rules the '*' operator is replaced by '-'

function my1(s)
    s = replace(s, r"(\d)" => s"My1(\1)")
    replace(s, r"\*" => s"-")
end
# Replace in the expression numbers with my numbers
# and operators with my operators

evaluate1(s) = eval(Meta.parse(my1(s))).val
# After reaplacement evaluation is maed with our rules

sum(evaluate1.(puzzleinput))


# Second Half

# As the firs half only rules change: now for my numbers '+' has the
# precedence rule of '*' and viceversa

import Base.*

struct My2
    val::Int
end

+(x::My2, y::My2) = My2(x.val * y.val)
*(x::My2, y::My2) = My2(x.val + y.val)

function my2(s)
    s = replace(s, r"(\d)" => s"My2(\1)")
    s = replace(s, r"\*" => s".")
    s = replace(s, r"\+" => s"*")
    replace(s, r"\." => s"+")
end

evaluate2(s) = eval(Meta.parse(my2(s))).val

sum(evaluate2.(puzzleinput))
