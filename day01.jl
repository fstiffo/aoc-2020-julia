using DelimitedFiles


# First Half

exprpt = readdlm("inputs/day01.txt", Int)
[i * j for (i, j) in Iterators.product(exprpt, exprpt) if i + j == 2020][1]


# Second Half
exprpt = readdlm("inputs/day01.txt", Int)
[i * j * k for (i, j, k) in Iterators.product(exprpt, exprpt, exprpt) if i + j + k == 2020][1]
