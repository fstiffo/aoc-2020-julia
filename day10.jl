using DelimitedFiles

# Second Half

input = readdlm("inputs/day10.txt", ' ', Int, '\n')
# sort joltages
input = sort(vec(input))

# add lowest (0) and highest (max jolt in input + 3) jolts
input = append!([0], input)
input = append!(input, [last(input) + 3])
len = length(input)

# Create a diagonal array for the cartesian product of joltages
# but where (i, j) value is
#   1 if joltage(i) - joltage(j) < 3, there is a possible electrical connection
#   0 otherwise, no possible connection
paths = BitArray(
    abs(input[i] - input[j]) < 4 && abs(input[i] - input[j]) != 0 && j > i
    for i = 1:len, j = 1:len
)

# For every joltage calculates hoe many possible connections,
# of course min 1 and max 3
sums = sum(paths, dims = 2)[:, 1]

# Removes last value, always 0
pop!(sums)

# Convert the vector of numbers in a string for pattern search
sums = prod(string.(sums))

# Because the nodes was ordered the string repesents a sequence
# of the number of paths starting from every node
# The pattern "332" is a graph with 7 possible paths
sums = replace(sums, "332" => "7")
# The pattern "32" is a graph with 4 possible paths
sums = replace(sums, "32" => "4")
# Other partterns are not a problem because the preceding and the following
# has only 1 possible path
# Is not possible to have the "31" pattern, think it about it :) !

# Convert strings in array of integers
sums = collect.(sums)
sums = map(x -> Int(x) - 48, sums)

# From the combinatorial calculus, the number of possible paths is
# the product of the possible paths between the subseguent joltages
prod(sums)
