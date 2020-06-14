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
            game:alterClicks(SIDE_CORP, 2)
        end
    },

    ["01060"] = { -- Shipment from MirrorMorph
        onPlay = function (meta)
            for _ = 0, 2 do
                make_interaction:promptSlotSelect(SIDE_CORP, SLOT_CORP_HAND, 1, function (card)
                    if not cardspec:canInstall(card.meta) then
                        return false
                    end

                    make_interaction:promptFreeInstall(SIDE_CORP, SLOT_CORP_HAND, card)
                    return true
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
            make_interaction:promptDeckSelect(SIDE_CORP, SLOT_CORP_RND, 5, 5, function (card)
                card.faceup = false
                local deck = board:deckGet(SLOT_CORP_RND, 0)
                deck:append(card)
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
                make_interaction:promptFreeAdvance(SIDE_CORP)
            end
        end
    },

    ["01086"] = { -- SEA Source
        canPlay = function (meta) return game.turn_n -1 == game.last_successfull_run_turn_n end,
        onPlay = function (meta)
            if game.runner:trace(3) then
                game.runner:alterTags(1)
            end
        end
    },

    ["01097"] = { -- Aggressive Negotiation
        canPlay = function (meta) return game.turn_n == game.last_agenda_scored_turn_n end,
        onPlay = function (meta)
            make_interaction:promptDeckSelect(SIDE_CORP, SLOT_CORP_RND, -1, 1, function (card)
                card.faceup = true
                board:cardAppend(SLOT_CORP_HAND, card)
                board:deckGet(SLOT_CORP_RND, 0):shuffle()
                return true
            end)
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
                if prev_card and prev_card.uid == card.uid then
                    return false
                end

                prev_card = card
                return true
            end

            make_interaction:promptFreeAdvance(SIDE_CORP, fn)
            make_interaction:promptFreeAdvance(SIDE_CORP, fn)
        end,
    },

    ["01110"] = { -- Hedge fund
        canPlay = function (meta) return game.corp.credits > 5 end,
        onPlay = function (meta)
            game.corp:alterCredits(9)
        end,
    },
}
