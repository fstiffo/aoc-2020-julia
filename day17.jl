puzzleinput = readlines("inputs/day17-test.txt")

initstate2D = map(reshape(vcat(collect.(puzzleinput)...), 8, 8)) do x
    x == '#'
end

const maxsz = 26

# First Half

const sum_states3D = tuple(false, false, false, true, zeros(Bool, 23)...),
tuple(false, false, true, true, zeros(Bool, 23)...)

initstate3D = reshape(fill(false, maxsz^3), maxsz, maxsz, maxsz)
function view(
    initstate3D, (maxsz ÷ 2 - 4):(maxsz ÷ 2 + 3), (maxsz ÷ 2 - 4):(maxsz ÷ 2 + 3), maxsz ÷ 2
)
    return initstate2D
end
# Moves the initial state 8 x 8, as a 1-dim slice,
# to the center of the 3D initial state

function sim1(state, cycles)
    @inline function offsets()
        # Returns the Moore neighborhood in 3D as an iterable of offsets

        return ((i, j, k) for k in -1:1, j in -1:1, i in -1:1 if (i, j, k) != (0, 0, 0))
    end

    function hood(grid, i)
        # Return the state of the Moore neighbors of cell i in grid

        c = Tuple(i)
        return [grid[CartesianIndex(c .+ i)] for i in offsets()]
    end

    life(hood, cstate) = sum_states3D[cstate + 1][sum(hood) + 1]

    for cycle in 1:cycles
        next = reshape(fill(false, maxsz^3), maxsz, maxsz, maxsz)
        for i in CartesianIndices((2:(maxsz - 1), 2:(maxsz - 1), 2:(maxsz - 1)))
            # For every cell in the state calculates the life of next generation

            next[i] = life(hood(state, i), state[i])
        end
        next, state = state, next
    end
    return state
end

sum(sim1(initstate3D, 6))

# Second Half

const sum_states4D = tuple(false, false, false, true, zeros(Bool, 77)...),
tuple(false, false, true, true, zeros(Bool, 77)...)

initstate4D = reshape(fill(false, maxsz^4), maxsz, maxsz, maxsz, maxsz)
function view(
    initstate4D,
    (maxsz ÷ 2 - 4):(maxsz ÷ 2 + 3),
    (maxsz ÷ 2 - 4):(maxsz ÷ 2 + 3),
    (maxsz ÷ 2 - 4):(maxsz ÷ 2 + 3),
    maxsz ÷ 2,
)
    return initstate2D
end
# Moves the initial state 8 x 8, as a 1-dim slice,
# to the center of the 4D initial state

function sim2(state, cycles)
    @inline function offsets()
        # Returns the Moore neighborhood in 4D as an iterable of offsets

        return (
            (i, j, k, l) for
            l in -1:1, k in -1:1, j in -1:1, i in -1:1 if (i, j, k, l) != (0, 0, 0, 0)
        )
    end

    function hood(grid, i)
        # Return the state of the Moore neighbors of cell i in grid

        c = Tuple(i)
        return [grid[CartesianIndex(c .+ i)] for i in offsets()]
    end

    life(hood, cstate) = sum_states4D[cstate + 1][sum(hood) + 1]

    for cycle in 1:cycles
        next = reshape(fill(false, maxsz^4), maxsz, maxsz, maxsz, maxsz)
        for i in
            CartesianIndices((2:(maxsz - 1), 2:(maxsz - 1), 2:(maxsz - 1), 2:(maxsz - 1)))
            # For every cell in the state calculates the life of next generation

            next[i] = life(hood(state, i), state[i])
        end
        next, state = state, next
    end
    return state
end

sum(sim2(initstate4D, 6))
