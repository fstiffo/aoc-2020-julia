# First Half

function isvalid1(line)
    m = match(r"^(\d+)-(\d+) ([a-z]{1}): (.*)$", line)
    lwst, high = parse(Int, m[1]), parse(Int, m[2])
    letter = m[3]
    pw = m[4]
    eachmatch(Regex(letter), pw) |> collect |> length ∈ lwst:high
end

puzzleinput = readlines("inputs/day02.txt")
count(isvalid1, puzzleinput)


# Second Half

function isvalid2(line)
    m = match(r"^(\d+)-(\d+) ([a-z]{1}): (.*)$", line)
    p1, p2 = parse(Int, m[1]), parse(Int, m[2])
    letter = m[3][1]
    pw = m[4]
    (pw[p1] == letter) ⊻ (pw[p2] == letter)
end


puzzleinput = readlines("inputs/day02.txt")
count(isvalid2, puzzleinput)
