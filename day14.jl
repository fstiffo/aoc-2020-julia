using DelimitedFiles
using Printf

puzzleinput = readdlm("inputs/day14.txt", ' ')
puzzleinput = hcat(puzzleinput[:, 1], puzzleinput[:, 3])

struct Program
    mask::instrs::Vector{NamedTuple{(:adr, :val),Tuple{Int,UInt64}}}
end

function Base.:|(mc::Char, c::Char)
    (mc == 'X') ? c : mc
end

function readinput(a::Array{Any,2})
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
    function masked(mask::String, n::UInt64)
        s = collect(bitstring(n)[29:end])
        parse(UInt64, String(collect(mask) .| s), base = 2)
    end

    mem = Dict()
    for p in progs
        mask = p.mask
        for i in p.instrs
            mem[i.adr] = masked(mask, i.val)
        end
    end
    mem
end

progs = readinput(puzzleinput)
mem = execute(progs)

valsum = let acc = 0
    for (adr, val) in mem
        acc += val
    end
    a
end

@sprintf("%d", valsum)
