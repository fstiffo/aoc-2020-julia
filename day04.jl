const Passport = Dict{String,String}

function readinput(filepath)

    function parsepassport(str)
        p = Passport()
        ss = split(str, r"\s")
        for s in ss
            m = match(r"([a-z]{3}):(.+)$", s)
            p[m[1]] = m[2]
        end
        p
    end

    strs = open(filepath) do file
        split(strip(read(file, String)), "\n\n")
    end
    map(parsepassport, strs)
end


# First Half

allrqdflds(p) = length(keys(p)) == (haskey(p, "cid") ? 8 : 7) # Treat cid as optional.

passports = readinput("inputs/day04.txt")
count(allrqdflds, passports)
# Count valid passports - those that have all required fields.


# Second Half

function allvldflds(p)
    # True if all required fields are both present and valid

    if !allrqdflds(p)

        return false
    end

    if !(parse(Int, p["byr"]) ∈ 1920:2002)
        # byr (Birth Year) - four digits; at least 1920 and at most 2002

        return false
    end
    if !(parse(Int, p["iyr"]) ∈ 2010:2020)
        # iyr (Issue Year) - four digits; at least 2010 and at most 2020

        return false
    end
    if !(parse(Int, p["eyr"]) ∈ 2020:2030)
        # eyr (Expiration Year) - four digits; at least 2020 and at most 2030

        return false
    end
    m = match(r"^(\d+)(cm|in)$", p["hgt"])
    if isnothing(m)
        # hgt (Height) - a number followed by either cm or in

        return false
    elseif m[2] == "cm"
        if !(parse(Int, m[1]) ∈ 150:193)
            # If cm, the number must be at least 150 and at most 193

            return false
        end
    else
        if !(parse(Int, m[1]) ∈ 59:76)
            # If in, the number must be at least 59 and at most 76

            return false
        end
    end
    if isnothing(match(r"^#[0-9|a-f]{6}$", p["hcl"]))
        # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f

        return false
    end
    if isnothing(match(r"^(amb|blu|brn|gry|grn|hzl|oth){1}$", p["ecl"]))
        # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth

        return false
    end
    if isnothing(match(r"^\d{9}$", p["pid"]))
        # pid (Passport ID) - a nine-digit number, including leading zeroes

        return false
    end
    true
end

passports = readinput("inputs/day04.txt")
count(allvldflds, passports)
# Count the number of valid passports - those that have
# all required fields and valid values
