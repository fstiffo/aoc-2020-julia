Actions = Dict('N' => [0, 1], 'S' => [0, -1], 'E' => [1, 0], 'W' => [-1, 0])

struct Instr
    act::Char
    val::Int
end

puzzleinput = readlines("inputs/day12.txt")
puzzleinput = map(s -> Instr(s[1], parse(Int, s[2:end])), puzzleinput)


# First Half


struct Ship
    pos::Vector{Int} # Ship position on the plane (x, y)
    dir::Vector{Int} # Ship direction as unit vector (eg. ovest = (-1,0))
end
# The ship status

ship = Ship([0, 0], [1, 0]) # The ship starts by facing east.

function handle1(s::Ship, i::Instr)
    # From a ship status s, handles an instruction i returning the new ship status

    val = i.val
    if act == 'L' || act == 'R'
        val = (act == 'R' ? -1 : 1) * val
        # Right means clockwise rotation eq to negatives angles

        theta = deg2rad(val)
        rotmat = [cos(theta) -sin(theta); sin(theta) cos(theta)]
        rotmat = map(x -> trunc(Int, x), rotmat)
        return Ship(s.pos, rotmat * s.dir)
        # Rotation matrix multiplication to perform rotation
    end
    if act == 'F'
        v = val * s.dir
    else
        v = val * getindex(Actions, act)
    end
    Ship(s.pos + v, s.dir)
end

wherelead = reduce(handle1, puzzleinput, init = ship)

sum(map(abs, wherelead.pos))


# Second Half

waypoint = ship.pos + [10, 1]
#The waypoint starts 10 units east and 1 unit north relative to the ship.

function handle2(sw::Tuple{Ship,Array{Int,1}}, i::Instr)
    # From a ship status s and a waypoint w,
    # handles an instruction i returning the new ship status and waypoint

    s = sw[1]
    w = sw[2]
    act = i.act
    val = i.val
    if act == 'L' || act == 'R'
        val = (act == 'R' ? -1 : 1) * val
        # Right means clockwise rotation eq to negatives angles

        theta = deg2rad(val)
        rotmat = [cos(theta) -sin(theta); sin(theta) cos(theta)]
        rotmat = map(x -> trunc(Int, x), rotmat)
        return (s, rotmat * w)
        # Rotation matrix multiplication to perform rotation
    end
    if act == 'F'
        v = val * w
        s = Ship(s.pos + v, s.dir)
    else
        v = val * getindex(Actions, act)
        w = w + v
    end
    (s, w)
end

wherelead = reduce(handle2, puzzleinput, init = (ship, waypoint))

sum(map(abs, wherelead[1].pos))
