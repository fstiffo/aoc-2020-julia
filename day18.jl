puzzleinput = readlines("inputs/day18.txt")

# First Half

struct My1
    val::Int
end
# Define MY numbers that follow different rules


import Base.+, Base.-

+(x::My1, y::My1) = My1(x.val + y.val)
# For MY numbers '+' acts like the regular one

-(x::My1, y::My1) = My1(x.val * y.val)
# For MY numbers '*' has the same precedence of '-' so to mantain
# conventional precedence rules, the '*' operator is replaced by '-'

function my1(s)
    s = replace(s, r"(\d)" => s"My1(\1)")
    replace(s, r"\*" => s"-")
end
# Replace in the expression numbers with MY numbers
# and operators with MY operators

evaluate1(s) = eval(Meta.parse(my1(s))).val
# After reaplacement evaluation is done with MY rules

sum(evaluate1.(puzzleinput))


# Second Half

# As the firs half only rules change: now for MY numbers '+' has the
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
