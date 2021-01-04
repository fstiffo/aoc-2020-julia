const TreesMap = BitArray{2}

function readinput(strs)
    TreesMap(transpose(hcat([[c == '#' for c ∈ l] for l ∈ strs]...)))
end


# First Half

function treesencountered₁(tmap)
    #= =========================================================================
    The trees map of the problem can be projected on cilindrical discrete plane
    where cilinder's height and perimeter are respectively mapₕ and mapₗ.
    The movement happens on a line on a discrete plane.
    The equation for a line starting at (0,0) in a cilindrical semi-infinite
    discrete plane is x = m * y mod mapₗ, where x, y are integers,
    slope m is a rational and m * y is rounded to the nearest integer.
    In our case m = mₕ / mᵥ (right slope / down slope) and the path is not
    this line, but only the dots on this line with vertical coordinate
    multiple of mᵥ (jumping).
    ========================================================================= =#
        
    mₕ = 3
    mᵥ = 1
    m = mₕ // mᵥ
    mapₕ, mapₗ = size(tmap)
    f(y) = tmap[y + 1, Int(m * y) % mapₗ + 1] # Arrays in Julia start from 1
    count(f, 0:mᵥ:mapₕ - 1) # Arrays in Julia start from 1
end

puzzleinput = readlines("inputs/day03.txt")
treesmap = readinput(puzzleinput)

treesencountered₁(treesmap)


# Second Half

function treesencountered₂(tmap)

    mₕ = [1, 3, 5, 7, 1]
    mᵥ = [1, 1, 1, 1, 2]
    M = collect(zip(mₕ, mᵥ))
    mapₕ, mapₗ = size(tmap)
    f(m) = y -> tmap[y + 1, Int(m[1] // m[2] * y) % mapₗ + 1]
    [count(f(m), 0:m[2]:mapₕ - 1) for m ∈ M]
end

puzzleinput = readlines("inputs/day03.txt")
treesmap = readinput(puzzleinput)

prod(treesencountered₂(treesmap))
# Multiply together the number of trees encountered on each of the listed slopes
