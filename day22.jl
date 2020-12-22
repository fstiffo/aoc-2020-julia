using DataStructures

puzzleinput = readlines("inputs/day22.txt")

Deck = Vector{Int}

function readinput(lines)

    player1 = map(lines[2:26]) do s
        parse(Int, s)
    end
    player2 = map(lines[29:53]) do s
        parse(Int, s)
    end

    return player1, player2
end

player1, player2 = readinput(puzzleinput)

function play(player1::Deck, player2::Deck)
    round = 1
    while !(isempty(player1) || isempty(player2))
        # Games end wheh the deck of one og the players is empty
        println("--- Round $round --")
        println("Player 1's deck: $player1")
        println("Player 2's deck: $player2")
        draw1 = popfirst!(player1)
        draw2 = popfirst!(player2)
        println("Plater 1 plays: $draw1")
        println("Plater 2 plays: $draw2")
        if draw1 > draw2
            player1 = [player1; draw1; draw2]
            println("Player 1 wins the round!")
        else
            player2 = [player2; draw2; draw1]
            println("Player 2 wins the round!")
        end
        println()
    end
    println("== Post-game results ==")
    println("Player 1's deck: $player1")
    println("Player 2's deck: $player2")
    winner = isempty(player1) ? player2 : player1
    score = sum(reverse(collect(1:length(winner))) .* winner)
    println("Score = $score")
end

play(player1, player2)

collect([length(player2):1])

length(player2)

collect(1:10)

[12:1]

[1:12]
