puzzleinput = readlines("inputs/day22.txt")

Deck = Vector{Int}

function readinput(lines)

    player₁ = map(lines[2:26]) do s
        parse(Int, s)
    end
    player₂ = map(lines[29:53]) do s
        parse(Int, s)
    end

    return player₁, player₂
end


# First Half

function combat!(player₁::Deck, player₂::Deck)

    round = 1
    while !(isempty(player₁) || isempty(player₂))
        # Games end wheh the deck of one of the players is empty

        println("--- Round $round --")
        println("Player 1's deck: $player₁")
        println("Player 2's deck: $player₂")
        draw₁ = popfirst!(player₁)
        draw₂ = popfirst!(player₂)
        println("Plater 1 plays: $draw₁")
        println("Plater 2 plays: $draw2")
        if draw₁ > draw₂
            player₁ = [player₁; draw₁; draw₂]
            println("Player 1 wins the round!")
        else
            player₂ = [player₂; draw₂; draw₁]
            println("Player 2 wins the round!")
        end
        round += 1
        println()
    end

    println("== Post-game results ==")
    println("Player 1's deck: $player₁")
    println("Player 2's deck: $player₂")
    winner = isempty(player₁) ? player₂ : player₁
    score = sum(reverse(collect(1:length(winner))) .* winner)
    println("Score = $score")
end

player₁, player₂ = readinput(puzzleinput)
combat!(player1, player2)


# Second Half

function recursivecombat!(player₁::Deck, player₂::Deck)

    function playgame(calling_game, p₁, p₂)

        local game = calling_game + 1

        round = 1
        local history = []
        while !(isempty(p₁) || isempty(p₂))
            if (p₁, p₂) ∈ history
                # Check if there was a previous round in this game that had
                # exactly the same cards in the same order in the same players' decks

                return 1 # If the case, player 1 wins
            end
            push!(history, (deepcopy(p₁), deepcopy(p₂)))

            d₁ = popfirst!(p₁)
            d₂ = popfirst!(p₂)

            winner = if length(p1) >= d₁ && length(p₂) >= d₂
                # If both players have at least as many cards remaining in their
                # deck as the value of the card they just drew, the winner of
                # the round is determined by playing a new game of Recursive Combat

                local p₁copy = deepcopy(p1[1:d₁])
                local p₂copy = deepcopy(p₂[1:d₂])
                # To play a sub-game of Recursive Combat, each player creates
                # a new deck by making a copy of the next cards in their deck
                # (the quantity of cards copied is equal to the number on the card
                #  they drew to trigger the sub-game).

                playgame(game, p₁copy, p₂copy)
                # The winner is the winner of the sub-game

            else
                # The winner is the player with the higher-value card

                d₁ > d₂ ? 1 : 2
            end

            if winner == 1
                p₁ = [p₁; d₁; d₂]
            else
                p₂ = [p₂; d₂; d₁]
            end
            round += 1
        end

        winner = isempty(p₁) ? 2 : 1
        if game > 1
            return winner 
        else
            println()
            println()
            println("== Post-game results ==")
            println("Player 1's deck: $p₁")
            println("Player 2's deck: $p₂")
            wdeck = winner == 1 ? p₁ : p₂
            score = sum(reverse(collect(1:length(wdeck))) .* wdeck)
            println("Score = $score")
        end
    end

    game = 0
    playgame(game, player₁, player₂)

end


player₁, player₂ = readinput(puzzleinput)
@time recursivecombat!(player₁, player₂)
