const TreesMap = BitArray{2}

function readinput(strs)
    TreesMap(transpose(hcat([[c == '#' for c in l] for l in strs]...)))
end


# First Half

function treesencountered1(tmap)
    # The trees map of the problem can be projected on cilindrical discrete plane
    # where cilinder's height and perimeter are respectively mapₕ and mapₗ.
    # The movement happens on a line on a discrete plane.
    # The equation for a line starting at (0,0) in a cilindrical semi-infinite
    # discrete plane is x = m * y mod mapₗ, where x, y are integers,
    # slope m is a rational and m * y is rounded to the nearest integer.
    # In our case m = mₕ / mᵥ (right slope / down slope) and the path is not
    # this line, #but only the dots# on this line with vertical coordinate
    # multiple of dm (jumping).

    mₕ = 3
    mᵥ = 1
    m = mₕ // mᵥ
    mapₕ, mapₗ = size(tmap)
    f(y) = tmap[y, Int(m * (y - 1))%mapₗ+1] # Arrays in Julia start from 1
    count(f, 1:mᵥ:mapₕ)
end

puzzleinput = readlines("inputs/day03.txt")
treesmap = readinput(puzzleinput)

treesencountered1(treesmap)
