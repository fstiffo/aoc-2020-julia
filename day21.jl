Ingredient = String
Allergen = String

Ingredients = Set{Ingredient}
Allergens = Set{Ingredient}
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
    foundsin
end

puzzleinput = readlines("inputs/day21.txt")
(ingredients, allergens, foods) = readinput(puzzleinput)

foundsin = foundsin!(allergens, foods)
cantcontain = setdiff(ingredients, foundsin)

sum(s -> length(s.ingrs ∩ cantcontain), foods )
