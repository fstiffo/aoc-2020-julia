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


# First Half

function combat!(player1::Deck, player2::Deck)

    round = 1
    while !(isempty(player1) || isempty(player2))
        # Games end wheh the deck of one of the players is empty

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
        round += 1
        println()
    end

    println("== Post-game results ==")
    println("Player 1's deck: $player1")
    println("Player 2's deck: $player2")
    winner = isempty(player1) ? player2 : player1
    score = sum(reverse(collect(1:length(winner))) .* winner)
    println("Score = $score")
end

combat!(player1, player2)

function recursivecombat!(player1::Deck, player2::Deck)

    function playgame(calling_game, p1, p2)

        local game = calling_game + 1
        # println("=== Game $game ===")
        round = 1
        local history = []
        while !(isempty(p1) || isempty(p2))
            # println()
            # println("--- Round $round (Game $game)--")
            # println("Player 1's deck: $p1")
            # println("Player 2's deck: $p2")
            if (p1, p2) ∈ history
                # Check if there was a previous round in this game that had
                # exactly the same cards in the same order in the same players' decks

                # println("Previous round in the game with same cards.")
                # println("The winner of game $game is player 1!")
                # println()
                # println("...anyway, back to game $calling_game")
                return 1 # If the case, player 1 wins
            end
            push!(history, (deepcopy(p1), deepcopy(p2)))

            # println("Plater 1 plays: $d1")
            # println("Plater 2 plays: $d2")
            d1 = popfirst!(p1)
            d2 = popfirst!(p2)

            winner = if length(p1) >= d1 && length(p2) >= d2
                # If both players have at least as many cards remaining in their
                # deck as the value of the card they just drew, the winner of
                # the round is determined by playing a new game of Recursive Combat

                local p1copy = deepcopy(p1[1:d1])
                local p2copy = deepcopy(p2[1:d2])
                # To play a sub-game of Recursive Combat, each player creates
                # a new deck by making a copy of the next cards in their deck
                # (the quantity of cards copied is equal to the number on the card
                #  they drew to trigger the sub-game).

                # println("Playing a sub-game to determine the winner...")
                # println()
                playgame(game, p1copy, p2copy)
                # The winner is the winner of the sub-game

            else
                # The winner is the player with the higher-value card

                d1 > d2 ? 1 : 2
            end
            if winner == 1
                p1 = [p1; d1; d2]
            else
                p2 = [p2; d2; d1]
            end
            # println("Player $winner wins round $round of game $game !")
            round += 1
        end
        winner = isempty(p1) ? 2 : 1
        if game > 1
            # println("The winner of game $game is player $winner !")
            # println()
            # println("...anyway, back to game $calling_game.")
            return winner
        else
            println()
            println()
            println("== Post-game results ==")
            println("Player 1's deck: $p1")
            println("Player 2's deck: $p2")
            wdeck = winner == 1 ? p1 : p2
            score = sum(reverse(collect(1:length(wdeck))) .* wdeck)
            println("Score = $score")
        end
    end


    game = 0
    playgame(game, player1, player2)

end


player1, player2 = readinput(puzzleinput)


@time recursivecombat!(player1, player2)
