# First Half

filter_lf(s) = filter(c -> c ≠ '\n', collect(s))

sumcounts1(strs) = map(length ∘ unique ∘ sort ∘ filter_lf, strs) |> sum
# For each group, count the number of questions ANYONE answered "yes"
# and then sum those counts

puzzleinput = open("inputs/day06.txt") do f
    split(read(f, String), "\n\n")
end

sumcounts1(puzzleinput)


# Second Half

spliton_lf(s) = split(s, "\n") |> collect
intersect_qs(cs) = foldl(intersect, cs, init=collect('a':'z'))

sumcounts2(strs) = map(length ∘ intersect_qs ∘ spliton_lf, strs) |> sum
# For each group, count the number of questions EVERYONE answered "yes"
# and then sum those counts

puzzleinput = open("inputs/day06.txt") do f
    split(read(f, String), "\n\n")
end

sumcounts2(puzzleinput)
