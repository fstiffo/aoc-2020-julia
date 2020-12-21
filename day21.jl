Food = String
Allergen = String

Usedin = Set{Food}

function readinput!(foods,possiblyusedin,foodlist)
    for l in foodlist
        m = match(r"(.+) \(contains (.+)\)",l)
        newfoods = Set(split(m[1], " "))
        union!(foods, newfoods)
        allergens = split(m[2], ", ")
        for i in allergens
            usedin = get(possiblyusedin,i,[])
            push!(usedin, newfoods)
            possiblyusedin[i] = usedin
        end
    end
end



puzzleinput = readlines("inputs/day21.txt")

possiblyusedin = Dict{Allergen,Vector{Usedin}}()
foods = Usedin()

readinput!(foods, possiblyusedin,puzzleinput)

function appearances(foods, possiblyusedin, foodlist)
    foods_with_allergens = union([intersect(fs...) for (i,fs) in possiblyusedin]...)
    foods_with_noallergens = setdiff(foods,foods_with_allergens)
    sum(sum([occursin.(f, foodlist) for f in foods_with_noallergens]))
end

appearances(foods, possiblyusedin, puzzleinput)
