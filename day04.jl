const Passport = Dict{String,String}

function readinput(filepath)

    function parsepassport(str)
        p = Passport()
        ss = split(str, r"\s")
        for s in ss
            m = match(r"([a-z]{3}):(.+)$",s)
            p[m[1]] = m[2]
        end
        p
    end

    strs = open(filepath) do file
        split(strip(read(file, String)),"\n\n")
    end
    map(parsepassport, strs)
end


# First Half

isvalid1(p) = length(keys(p)) == (haskey(p, "cid") ? 8 : 7)
# Valid passports - those that have all required fields. Treat cid as optional.

passports = readinput("inputs/day04.txt")
count(isvalid1, passports)
