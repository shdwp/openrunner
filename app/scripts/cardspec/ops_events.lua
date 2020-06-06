operations = {
    [1083] = { -- Anonymous Tip
        onPlay = function ()
            game.corp:drawCard()
            game.corp:drawCard()
            game.corp:drawCard()
        end,
    },

    [1098] = { -- Beanstalk Royalties
        onPlay = function ()
            game.corp.credits = game.corp.credits + 3
        end,
    },

    [1110] = { -- Hedge fund
        canPlay = function () return game.corp.credits > 5 end,
        onPlay = function ()
            game.corp.credits = game.corp.credits + 9
        end,
    },

    [1100] = { -- Shipmen from Kaguya
        onPlay = function ()

        end,
    }
}
