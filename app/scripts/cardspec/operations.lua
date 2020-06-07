operations = {
    ["01058"] = { -- Archived Memories
        onPlay = function (meta)
            event:promptDeckSelect("corp_archives", -1, 1, function (card)
                board:cardAppend("corp_hand", card)
            end)
        end,
    },

    ["01059"] = { -- Biotic Labor
        onPlay = function (meta)
            game.corp:alterClicks(2)
        end
    },

    ["01060"] = { -- Shipment from MirrorMorph
        onPlay = function (meta)
            for _ = 0, 2 do
                return intr:promptStackSelect("corp_hand", function (card)
                    return intr:promptInstall(card)
                end)
            end
        end
    },

    ["01072"] = { -- Neural EMP
        canPlay = function (meta)
            return game.turn_n - 1 == game.last_run_turn_n
        end,

        onPlay = function (meta)
            game.runner:alterNetDamage(-1)
        end,
    },

    ["01073"] = { -- Precognition
        onPlay = function (meta)
            intr:promptDeckSelect("corp_rnd", 5, 5, function (card)
                card.faceup = false
                board:deckAppend("corp_rnd", card)
                return true
            end)
        end
    },

    ["01083"] = { -- Anonymous Tip
        onPlay = function (meta)
            game.corp:drawCard()
            game.corp:drawCard()
            game.corp:drawCard()
        end,
    },

    ["01084"] = { -- Closed Accounts
        canPlay = function (meta)
            return game.runner.tags > 0
        end,

        onPlay = function (meta)
            game.runner.credits = 0
        end
    },

    ["01085"] = { -- Psychographics
        canPlay = function (meta) return game.runner.tags > 0 end,
        onPlay = function (meta)
            for _ = 0, game.runner.tags do
                intr:promptAdvance()
            end
        end
    },

    ["01086"] = { -- SEA Source
        canPlay = function (meta) return game.turn_n -1 == game.last_successfull_run_turn_n end,
        onPlay = function (meta)
            if game.runner:trace(3) then
                game.runner:alterTags(1);
            end
        end
    },

    ["01097"] = { -- Aggressive Negotiation
        canPlay = function (meta) return game.turn_n == game.last_agenda_scored_turn_n end,
        onPlay = function (meta)
            intr:promptDeckSelect("corp_rnd", -1, 1, function (card)
                card.faceup = true
                board:cardAppend("corp_hand", card)
            end)

            board:getDeck("corp_rnd"):shuffle()
        end
    },

    ["01098"] = { -- Beanstalk Royalties
        onPlay = function (meta)
            game.corp:alterCredits(3)
        end,
    },

    ["01099"] = { -- Scorched Earth
        canPlay = function (meta) return game.runner.tags > 0 end,
        onPlay = function (meta)
            game.runner:alterMeatDamage(4)
        end
    },

    ["01100"] = { -- Shipment from Kaguya
        onPlay = function (meta)
            local prev_card = nil
            local fn = function (card)
                if prev_card == card then
                    return false
                else
                    card.meta.adv = card.meta.adv + 1
                end
            end

            intr:promptInstalled(fn)
            intr:promptInstalled(fn)
        end,
    },

    ["01110"] = { -- Hedge fund
        canPlay = function (meta) return game.corp.credits > 5 end,
        onPlay = function (meta)
            game.corp:alterCredits(9)
        end,
    },
}
