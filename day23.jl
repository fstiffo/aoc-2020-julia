using CircularArrays

import Base.~


# First Half

const maxlbl1 = 9

~(x::Int, y::Int) = mod1(x - y, maxlbl1) # Circular subtraction

function simulate1!(cups, moves)

    function place(cups, pickup, destination)
        t = Vector(cups)
        for p in pickup
            pckpos = findfirst(x -> x == p, t)
            deleteat!(t, pckpos)
        end
        destpos = findfirst(x -> x == destination, t)
        CircularVector([t[1:destpos]; pickup; t[destpos+1:end]])
    end

    current = cups[1]
    destination = 0
    for m = 1:moves
        currpos = findfirst(x -> x == current, cups)
        pickup = cups[currpos+1:currpos+3]
        # Step 1 - The crab picks up the three cups that are immediately
        # clockwise of the current cup. They are removed from the circle;


        destination = current ~ 1
        # Step 2 - The crab selects a destination cup: the cup with a label
        # equal to the current cup's label minus one.

        while destination ∈ pickup
            # If this would select one of the cups that was just picked up,
            # the crab will keep subtracting one until it finds a cup that
            # wasn't just picked up.

            destination = destination ~ 1
        end

        println("-- move $m --")
        println("cups: $cups")
        println("current: $current")
        println("pick up: $pickup")
        println("destination: $destination")
        println()

        cups = place(cups, pickup, destination)
        # Step 3 - The crab places the cups it just picked up so that they are
        # immediately clockwise of the destination cup. They keep the same
        # order as when they were picked up.

        currpos = findfirst(x -> x == current, cups)
        current = cups[currpos+1]
        # Step 4 - The crab selects a new current cup: the cup which is
        # immediately clockwise of the current cup.
    end
    cups
end

puzzleinput = CircularVector([6, 8, 5, 9, 7, 4, 2, 1, 3])
puzzletestinput = CircularVector([3, 8, 9, 1, 2, 5, 4, 6, 7])
simulate1!(puzzleinput, 101)


# Second Half

const maxlbl2 = 1000000

~(x::Int, y::Int) = mod1(x - y, maxlbl2) # Circular subtraction

function simulate2!(cups, moves)

    function place(cups, pickup, destination)
        t = Vector(cups)
        for p in pickup
            pckpos = findfirst(x -> x == p, t)
            deleteat!(t, pckpos)
        end
        destpos = findfirst(x -> x == destination, t)
        CircularVector([t[1:destpos]; pickup; t[destpos+1:end]])
    end

    current = cups[1]
    destination = 0
    for m = 1:moves
        currpos = findfirst(x -> x == current, cups)
        pickup = cups[currpos+1:currpos+3]
        # Step 1 - The crab picks up the three cups that are immediately
        # clockwise of the current cup. They are removed from the circle;


        destination = current ~ 1
        # Step 2 - The crab selects a destination cup: the cup with a label
        # equal to the current cup's label minus one.

        while destination ∈ pickup
            # If this would select one of the cups that was just picked up,
            # the crab will keep subtracting one until it finds a cup that
            # wasn't just picked up.

            destination = destination ~ 1
        end

        cups = place(cups, pickup, destination)
        # Step 3 - The crab places the cups it just picked up so that they are
        # immediately clockwise of the destination cup. They keep the same
        # order as when they were picked up.

        currpos = findfirst(x -> x == current, cups)
        current = cups[currpos+1]
        # Step 4 - The crab selects a new current cup: the cup which is
        # immediately clockwise of the current cup.
    end
    cups
end

puzzleinput2 = CircularVector([[6, 8, 5, 9, 7, 4, 2, 1, 3]; collect([10:maxlbl2]...)])

simulate2!(puzzleinput2, 10000000)
