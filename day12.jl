
# First Half

struct Instr
    act::Char
    val::Int
end

Actions = Dict('N' => [0, 1], 'S' => [0, -1], 'E' => [1, 0], 'W' => [-1, 0])

puzzleinput = readlines("inputs/day12.txt")
puzzleinput = map(s -> Instr(s[1], parse(Int, s[2:end])), puzzleinput)

# The ship status
struct Ship
    pos::Vector{Int} # Ship position on the plane (x, y)
    dir::Vector{Int} # Ship direction as unit vector (eg. ovest = (-1,0))
end

ship = Ship([0, 0], [1, 0]) # The ship starts by facing east.

# From a ship status s, handles an instruction i returning the new ship status
function handle(s::Ship, i::Instr)
    act = i.act
    val = i.val
    if act == 'L' || act == 'R'
        # Right means clockwise rotation eq to negatives angles
        val = (act == 'R' ? -1 : 1) * val
        theta = deg2rad(val)
        rotmat = [cos(theta) -sin(theta); sin(theta) cos(theta)]
        rotmat = map(x -> trunc(Int, x), rotmat)
        # Rotation matrix multiplication to perform rotation
        return Ship(s.pos, rotmat * s.dir)
    end
    if act == 'F'
        v = val * s.dir
    else
        v = val * getindex(Actions, act)
    end
    Ship(s.pos + v, s.dir)
end

wherelead = reduce(handle, puzzleinput, init=ship)

print(sum(map(abs,wherelead.pos)))
