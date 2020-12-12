using DelimitedFiles

# Second Half

puzzleinput = readdlm("inputs/day10.txt", ' ', Int, '\n')
# Sort joltages
puzzleinput = sort(vec(puzzleinput))

# Add lowest (0) and highest (max jolt in puzzle input + 3) jolts
puzzleinput = append!([0], puzzleinput)
puzzleinput = append!(puzzleinput, [last(puzzleinput) + 3])
len = length(puzzleinput)

# Create a diagonal matrix for the cartesian product of joltages
# but where (i, j) value is
#   1 if joltage(i) - joltage(j) < 3, there is a possible electrical connection
#   0 otherwise, no possible connection
# Lower part of the diagonal matrix is set to 0 (condition j > i)
paths = BitArray(
    abs(puzzleinput[i] - puzzleinput[j]) < 4 && abs(puzzleinput[i] - puzzleinput[j]) != 0 && j > i
    for i = 1:len, j = 1:len
)

# For every joltage calculates how many possible connections,
# of course the min is 1 and the max is 3 (condition of max 3 jolt o diff)
sums = sum(paths, dims = 2)[:, 1]

# Removes last value, always 0
pop!(sums)

# Convert the vector of numbers in a string for pattern search
sums = prod(string.(sums))

# Because the nodes was ordered the string repesents a sequence
# of the number of paths starting from every node.

# The sequence of nodes with a pattern "332" is a graph with 7 possible paths
sums = replace(sums, "332" => "7")
# The pattern "32" is a graph with 4 possible paths
sums = replace(sums, "32" => "4")

# Other patterns (eg, 121 or 111) are not a problem because the preceding
# and the following has only 1 possible path.
# Is not possible to have the "31" pattern, why? think it about it :)

# Convert strings in array of integers
sums = collect.(sums)
sums = map(x -> Int(x) - 48, sums)

# From the combinatorial calculus, the number of possible paths is
# the product of the possible paths between the subseguent joltages
prod(sums)
