Ingredient = String
Allergen = String

Allergens = Set{Allergen}

function readinput!(foodlist, textinput)
    for l in textinput
        m = match(r"(.+) \(contains (.+)\)", l)
        ingredients = split(m[1], " ")
        allergens = Set(split(m[2], ", "))
        contains = Dict([(i, allergens) for i in ingredients])
        push!(foodlist, contains)
    end
end



puzzleinput = readlines("inputs/day21.txt")

foodlist = Vector{Dict{Ingredient,Allergens}}()

readinput!(foodlist, puzzleinput)

foodlist

function freeofallergens!(foodlist)
    free = []
    for l = 2:length(foodlist)
        for (food, allergens) in foodlist[l]
            prevs = foodlist[1:l-1]
            for prev in prevs
                if haskey(prev, food)
                    intersect!(allergens, prev[food])
                    if isempty(allergens) # The food can't contain allergens
                        push!(free, food)
                        map(foodlist) do l
                            delete!(l, food)
                        end
                    else # Update the possible allergens contained by food
                        foodlist[l][food] = allergens
                        map(prevs) do p
                            p[food] = allergens
                        end
                    end
                end
                # print("Nay!")
            end
        end
    end
    free
end

freeofallergens = freeofallergens!(foodlist)

sum(sum([occursin.(f, puzzleinput) for f in freeofallergens]))
