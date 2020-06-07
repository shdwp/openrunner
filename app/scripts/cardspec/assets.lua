assets = {
    ["01056"] = { -- Adonis Campaign
        onRez = function (meta)
            meta.credits_pool = 12
        end,

        onNewTurn = function (meta)
            meta.credits_pool = meta.credits_pool - 3
            game.corp.alterCredits(3)
        end,
    },

    ["01108"] = { -- Melange Mining Corp
        canAction = function (meta) return game.corp.clicks >= 3 end,

        onAction = function (meta)
            game.corp.clicks = game.corp.clicks - 3
            game.corp.credits = game.corp.credits + 7
        end
    },
}
