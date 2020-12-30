using DataStructures

Ingredient = String
Allergen = String

Ingredients = Set{Ingredient}
Allergens = Set{Allergen}
Foods = Vector{@NamedTuple{ingrs::Ingredients, allrgs::Allergens}}

function readinput(strs)

    ingredients = Ingredients()
    allergens = Allergens()
    foods = []

    for s in strs
        m = match(r"(.+) \(contains (.+)\)", s)
        ingrs = Ingredients(split(m[1], " "))
        allrgs = Allergens(split(m[2], ", "))
        union!(ingredients, ingrs)
        union!(allergens, allrgs)
        t = (ingrs = ingrs, allrgs = allrgs)
        push!(foods, t)
    end
    return ingredients, allergens, foods
end


# Firts Half

function foundsin!(allergens, foods)
    foundsin = Ingredients()
    prevlen = -1
    while prevlen < length(foundsin)
        prevlen = length(foundsin)
        possiblyin = Dict()
        for a in allergens
            contains_a = [ingrs for (ingrs, allrgs) in foods if a ∈ allrgs]
            p = intersect(contains_a...)
            possiblyin[a] = p
        end
        only1ingr =
            Set([collect(ingrs)[1] for (_, ingrs) in possiblyin if length(ingrs) == 1])
        union!(foundsin, only1ingr)
        for (ingrs, _) in foods
            setdiff!(ingrs, foundsin)
        end
    end
    return foundsin
end

puzzleinput = readlines("inputs/day21.txt")
ingredients, allergens, foods = readinput(puzzleinput)

cancontain = foundsin!(allergens, foods)
cantcontain = setdiff(ingredients, cancontain)

sum(s -> length(s.ingrs ∩ cantcontain), foods)


# Second Half

function whichinwhich!(allergens, foods)
    whichinwhich = SortedDict()
    foundsin = Ingredients()
    prevlen = -1
    while prevlen < length(foundsin)
        prevlen = length(foundsin)
        possiblyin = OrderedDict()
        for a in allergens
            contains_a = [ingrs for (ingrs, allrgs) in foods if a ∈ allrgs]
            p = intersect(contains_a...)
            possiblyin[a] = p
        end
        only1ingr = Set()
        for (a, ingrs) in possiblyin
            if length(ingrs) == 1
                ingr = collect(ingrs)[1]
                push!(only1ingr, ingr)
                insert!(whichinwhich, a, ingr)
            end
        end
        union!(foundsin, only1ingr)
        for (ingrs, _) in foods
            setdiff!(ingrs, foundsin)
        end
    end
    whichinwhich
end

puzzleinput = readlines("inputs/day21.txt")
_, allergens, foods = readinput(puzzleinput)

cancontain = whichinwhich!(allergens, foods)
join(getfield.(collect(cancontain), 2), ",")
