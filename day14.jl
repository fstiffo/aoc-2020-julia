using DelimitedFiles
using Printf

puzzleinput = readdlm("inputs/day14.txt", ' ')
puzzleinput = hcat(puzzleinput[:, 1], puzzleinput[:, 3])

struct Program
    mask::String
    instrs::Vector{NamedTuple{(:adr, :val),Tuple{Int,UInt64}}}
end

Base.:|(mc::Char, c::Char) = (mc == 'X') ? c : mc
# Redefines | operator on chars to work as the mask described in the puzzle

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

function execute(progs)
    # Esecutes all the programs in progs filling the memory end returing it

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

progs = readinput(puzzleinput)
mem = execute(progs)

sumofvals = let acc = 0
    for (adr, val) in mem
        acc += val
    end
    acc
end

@sprintf("%d", sumofvals)
