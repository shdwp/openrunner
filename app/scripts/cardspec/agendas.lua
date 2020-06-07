agendas = {
    ["01094"] = { -- Hostile Takeover
        onScore = function (meta)
            game.corp:alterCredits(7)
            game.corp:alterBadPublicity(1)
            game.corp:alterScore(meta.info.agenda_points)
        end,
    },

    ["01095"] = {
        onScore = function (meta)
            game.corp:alterScore(meta.info.agenda_points)
        end,
    },
}
