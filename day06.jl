filter_lf(s) = filter(c -> c ≠ '\n', collect(s))


# First Half

countsum(strs) = map(length ∘ unique ∘ sort ∘ filter_lf, strs) |> sum
# For each group, count the number of questions to which anyone answered "yes"
# and then sum those counts

puzzleinput = open("inputs/day06.txt") do f
    split(read(f, String),"\n\n")
end

countsum(puzzleinput)
