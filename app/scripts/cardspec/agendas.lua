agendas = {
    [1094] = { -- Hostile Takeover
        onScore = function ()
            game.corp.credits = game.corp.credits + 7
            game.corp.bad_publicity = game.corp.bad_publicity + 1
        end,
    }
}
