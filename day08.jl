using DelimitedFiles

puzzleinput = readdlm("inputs/day08.txt")

mutable struct CPU
    pc::Int
    a::Int
end

program = hcat(puzzleinput, fill(false, (size(puzzleinput)[1], 1)))
# The program is a 3 cols array where col 1 is the ops, col 2 the arg
# and col 3 a flag to check if the instruction has been executed

function execute(cpu, prg)
    eop = length(prg[:, 1:1])
    # address of the last line of the program

    while true
        # Execution loop

        pc = cpu.pc
        if pc == eop + 1 # Program ended correctly
            return cpu
        elseif pc > eop + 1 # Programs jumped to a wrong address
            cpu.pc = 0 # Error code for bad address
            return cpu
        end

        ops = prg[pc, 1]
        arg = prg[pc, 2]
        flg = prg[pc, 3]

        if flg
            # If the code is going to execute an instruction already execute
            # the code is in an infinite loop then exit execution loop

            cpu.pc = -1 # Error code for loop
            return cpu
        end

        if ops == "acc"
            cpu.a += arg
            cpu.pc += 1
        elseif ops == "jmp"
            cpu.pc += arg
        elseif ops == "nop"
            cpu.pc += 1
        else
            error("Unknown ops")
        end
        prg[pc, 3] = true
        # After execution the instrucion in the program is marked as executed

    end
end

cpu = execute(CPU(1, 0), program)
cpu.a


# Second Half

function fix(prg)
    eop = length(prg[:, 1:1])
    # Address of the last line of the program

    nops = [i for i = 1:eop if program[i, 1] == "nop" && program[i, 2] != 0]
    # Addresses of lines of program with ops = nop and arg != 0

    jmps = [i for i = 1:eop if program[i, 1] == "jmp"]
    # Addresses of lines of program with ops = jmp

    for i in nops
        # Try to change every nop ops into a jmp to fix the program

        newprg = copy(prg)
        newprg[i, 1] = "jmp"
        cpu = execute(CPU(1, 0), newprg)
        if cpu.pc == eop + 1 # The program ended correctly, we have fixed it!
            return cpu.a
        end
    end

    for i in jmps
        # Try to change every nop ops into a jmp to fix the program

        newprg = copy(prg)
        newprg[i, 1] = "nop"
        cpu = execute(CPU(1, 0), newprg)
        if cpu.pc == eop + 1 # The program ended correctly, we have fixed it!
            return cpu.a
        end
    end
    0
end

fix(program)
