assets = {
    [1056] = { -- Adonis Campaign
        onRez = function (card)
            card.meta["credits_pool"] = 12
        end,

        onNewTurn = function (card)
            card.meta["credits_pool"] = card.meta["credits_pool"] - 3
            game.corp.credits = game.corp_credits + 3
        end,
    },

    [1108] = { -- Melange Mining Corp
        canAction = function () return game.corp.clicks >= 3 end,

        onAction = function (card)
            game.corp.clicks = game.corp.clicks - 3
            game.corp.credits = game.corp.credits + 7
        end
    },
}
