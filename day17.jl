puzzleinput = readlines("inputs/day17.txt")

initstate2D = map(reshape(vcat(collect.(puzzleinput)...), 8, 8)) do x
    x == '#'
end

const maxsz = 50

# First Half

const sum_states3D = (
    false,
    false,
    false,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
),
(
    false,
    false,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
)


initstate3D = reshape(fill(false, maxsz^3), maxsz, maxsz, maxsz)
view(initstate3D, maxsz÷2-4:maxsz÷2+3, maxsz÷2-4:maxsz÷2+3, maxsz ÷ 2) .= initstate2D
# Moves the initial state 8 x 8, as a 1-dim slice,
# to the center of the 3D initial state

function sim!(state, cycles)

    cartidx = CartesianIndices(state)
    # To convert a linear index in state to a cartesian one

    @inline function offsets()
        # Returns the Moore neighborhood in 3D as an iterable of offsets

        ((i, j, k) for k in -1:1, j in -1:1, i in -1:1 if (i, j, k) != (0, 0, 0))
    end

    function hood(grid, i)
        # Return the state of the Moore neighbors of cell i in grid

        c = Tuple(cartidx[i])
        [grid[CartesianIndex(c .+ i)] for i in offsets()]
    end

    life(hood, cstate) = sum_states3D[cstate+1][sum(hood)+1]

    for cycle = 1:cycles
        next = reshape(fill(false, maxsz^3), maxsz, maxsz, maxsz)
        for i in CartesianIndices((2:maxsz-1, 2:maxsz-1, 2:maxsz-1))
            # For every cell in the state calculates the life of next generation

            next[i] = life(hood(state, i), state[i])
        end
        next, state = state, next
    end
    state
end

sum(sim!(initstate3D, 6))


# Second Half

const sum_states3D = (
    false,
    false,
    false,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
),
(
    false,
    false,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
)

initstate4D = reshape(fill(false, maxsz^4), maxsz, maxsz, maxsz, maxsz)
view(initstate3D, maxsz÷2-4:maxsz÷2+3, maxsz÷2-4:maxsz÷2+3, maxsz÷2-4:maxsz÷2+3, maxsz ÷ 2) .= initstate2D
# Moves the initial state 8 x 8, as a 1-dim slice,
# to the center of the 3D initial state

function sim!(state, cycles)

    cartidx = CartesianIndices(state)
    # To convert a linear index in state to a cartesian one

    @inline function offsets()
        # Returns the Moore neighborhood in 3D as an iterable of offsets

        ((i, j, k) for k in -1:1, j in -1:1, i in -1:1 if (i, j, k) != (0, 0, 0))
    end

    function hood(grid, i)
        # Return the state of the Moore neighbors of cell i in grid

        c = Tuple(cartidx[i])
        [grid[CartesianIndex(c .+ i)] for i in offsets()]
    end

    life(hood, cstate) = sum_states3D[cstate+1][sum(hood)+1]

    for cycle = 1:cycles
        next = reshape(fill(false, maxsz^3), maxsz, maxsz, maxsz)
        for i in CartesianIndices((2:maxsz-1, 2:maxsz-1, 2:maxsz-1))
            # For every cell in the state calculates the life of next generation

            next[i] = life(hood(state, i), state[i])
        end
        next, state = state, next
    end
    state
end

sum(sim!(initstate3D, 6))
