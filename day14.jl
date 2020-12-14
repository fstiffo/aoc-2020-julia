using DelimitedFiles
using Printf

puzzleinput = readdlm("inputs/day14.txt", ' ')
puzzleinput = hcat(puzzleinput[:, 1], puzzleinput[:, 3])

struct Program
    mask::String
    instrs::Vector{NamedTuple{(:adr, :val),Tuple{UInt64,UInt64}}}
end

function readinput(a::Array{Any,2})
    # Parse the input filling an array of Program structures

    progs = Program[]

    for (lbl, val) in eachrow(a)
        if lbl == "mask"
            push!(progs, Program(val, []))
        else
            adr = parse(Int, lbl[5:end-1])
            push!(progs[end].instrs, (adr = adr, val = val))
        end
    end
    progs
end

progs = readinput(puzzleinput)


# First Half

Base.:|(mc::Char, c::Char) = (mc == 'X') ? c : mc
# Redefines | operator on chars to work as the mask
# described in the 1st half of the puzzle

function execute1(progs)
    # Executes all the programs in progs filling the memory,then returns it

    function masked(mask::String, n::UInt64)
        s = collect(bitstring(n)[29:end])
        parse(UInt64, String(collect(mask) .| s), base = 2)
    end

    mem = Dict()
    for p in progs
        for i in p.instrs
            mem[i.adr] = masked(p.mask, i.val)
        end
    end
    mem
end


mem = execute1(progs)

sumofvals = let acc = 0
    for (adr, val) in mem
        acc += val
    end
    acc
end

@sprintf("%d", sumofvals)


# Seconf Half


function Base.:&(mc::Char, c::Char)
    if mc == 'X'
        'X'
    else
        mc == '0' ? c : '1'
    end
end
# Redefines & operator on chars to work as the mask
# described in the 2nd half of the puzzle

function execute2(progs)
    # Executes all the programs in progs filling the memory,then returns it

    function apply(mask::String, n::UInt64)
        # Apply the mask to the address n and generate an
        # array of address with all possible values of floating bits

        s = collect(bitstring(n)[29:end])
        masked = String(collect(mask) .& s)
        nX = count("X", masked)

        pool = []
        for b in 0:(2^nX - 1)
            # Every possible combination of bits of length nX is
            # all the binary number from 0 to 2^nX - 1

            d = bitstring(b)[(end - nX + 1):end]
            # Converts the binary number in a
            s = masked
            i = 1
            while true
                # For every possible combination builds the address
                # replacing every floating bit (X) with the corresponding
                # bit in the combination

                pos = findnext('X', s, 1)
                if isnothing(pos)
                    break
                end
                s = s[1:pos-1] * "$(d[i])" * s[pos+1:end]
                i += 1
            end
            push!(pool, parse(UInt64, s, base = 2))
            # The built address is added to the pool

        end
        pool
    end

    mem = Dict()
    for p in progs
        println(p.mask)
        for i in p.instrs
            adrs = apply(p.mask, i.adr)
            for a in adrs
                mem[a] = i.val
            end
        end
    end
    mem
end

mem = execute2(progs)

sumofvals = let acc = 0
    for (adr, val) in mem
        acc += val
    end
    acc
end

@sprintf("%d", sumofvals)

52+23
