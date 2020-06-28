_end_the_run_description = "End the run"

--- @param ctx Ctx
_end_the_run_subroutine = function (ctx)
    ctx.state.stack:popUpTo(RunEndDecision.Type)
end

Db.cards[1005] = {
    code = "01005",
    cost = 2,
    deck_limit = 3,
    faction_code = "anarch",
    faction_cost = 1,
    flavor = "I feel almost naked without it",
    illustrator = "Gong Studios",
    keywords = "Chip",
    pack_code = "core",
    position = 5,
    quantity = 3,
    side_code = "runner",
    text = "1[recurring-credit]\nUse this credit to pay for using <strong>icebreakers</strong> or for installing <strong>virus</strong> programs.",
    title = "Cyberfeeder",
    type_code = "hardware",
    uniqueness = false,

    --- @param ctx Ctx
    onNewTurn = function (ctx)
        ctx.runner.bank:addRecurring(CREDITS_FOR_ICEBREAKERS_OR_VIRUS, 1)
        return true
    end,

    --- @param ctx Ctx
    onInstall = function (ctx)
        ctx.runner.bank:subtractRecurring(CREDITS_FOR_ICEBREAKERS_OR_VIRUS, -1)
        return true
    end

}
Db.card_titles["Cyberfeeder"] = 1005

Db.cards[1007] = {
    code = "01007",
    cost = 2,
    deck_limit = 3,
    faction_code = "anarch",
    faction_cost = 2,
    flavor = "\"If at first you don\'t succeed, boost its strength and try again.\" -g00ru",
    illustrator = "Mike Nesbitt",
    keywords = "Icebreaker - Fracter",
    memory_cost = 1,
    pack_code = "core",
    position = 7,
    quantity = 2,
    side_code = "runner",
    strength = 2,
    text = "1[credit]: Break <strong>barrier</strong> subroutine.\n1[credit]: +1 strength.",
    title = "Corroder",
    type_code = "program",
    uniqueness = false,

    --- @param ctx Ctx
    onPowerUp = function (ctx)
        if ctx.runner.bank:debit(SPENDING_ICEBRBREAKER_POWERUP, 1) then
            ctx.meta.until_use.additional_strength = (ctx.meta.until_use.additional_strength or 0) + 1
            return true
        end
    end,

    --- @param ctx Ctx
    --- @param ice_meta CardMeta
    onBreakIce = function (ctx, ice_meta)
        if ctx.runner.bank:debig(SPENDING_ICEBRBREAKER_BREAK, 1) then
            return ice_meta:keywordsInclude("Barrier")
        end
    end,
}
Db.card_titles["Corroder"] = 1007

Db.cards[1019] = {
    code = "01019",
    cost = 0,
    deck_limit = 3,
    faction_code = "criminal",
    faction_cost = 1,
    flavor = "\"Hey kid, you fire that up now, bound to be vamped real bad. Some real pathetic individuals around here. But thankfully I got just the ticket…\"",
    illustrator = "Matt Zeilinger",
    keywords = "Job",
    pack_code = "core",
    position = 19,
    quantity = 3,
    side_code = "runner",
    text = "Gain 3[credit].",
    title = "Easy Mark",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.runner.bank:credit(3)
        return true
    end
}
Db.card_titles["Easy Mark"] = 1019

Db.cards[1026] = {
    code = "01026",
    cost = 9,
    deck_limit = 3,
    faction_code = "criminal",
    faction_cost = 1,
    illustrator = "Kate Niemczyk",
    keywords = "Icebreaker - Killer",
    memory_cost = 1,
    pack_code = "core",
    position = 26,
    quantity = 2,
    side_code = "runner",
    strength = 2,
    text = "1[credit]: Break <strong>sentry</strong> subroutine.\n2[credit]: +1 strength.\nWhen you install Femme Fatale, choose an installed piece of ice. When you encounter that ice, you may pay 1[credit] per subroutine on that ice to bypass it.",
    title = "Femme Fatale",
    type_code = "program",
    uniqueness = false,

    --- @param ctx Ctx
    --- @param ice CardMeta
    onBreakIce = function (ctx, ice)
        if ctx.runner.bank:debit(SPENDING_ICEBREAKER_BREAK, 1) then
            if ctx.meta.selected_ice == ice then
                return true
            else
                return ice:keywordsInclude("Sentry")
            end
        end
    end,

    --- @param ctx Ctx
    onPowerUp = function (ctx)
        if ctx.runner.bank:debit(SPENDING_ICEBRBREAKER_POWERUP, 2) then
            ctx.meta.until_use.additional_strength = (ctx.meta.until_use.additional_strength or 0) + 1
            return true
        end
    end,

    --- @param ctx Ctx
    onInstall = function (ctx)
        ctx.prompt:promptSlotSelect(SIDE_RUNNER, isSlotIce, 1, function (decision, card, slot)
            ctx.meta.selected_ice = card.meta
            return true
        end)
        return true
    end
}
Db.card_titles["Femme Fatale"] = 1026

Db.cards[1027] = {
    code = "01027",
    cost = 4,
    deck_limit = 3,
    faction_code = "criminal",
    faction_cost = 2,
    flavor = "You feel Ninja before you see Ninja, if you see Ninja at all.",
    illustrator = "Andrew Mar",
    keywords = "Icebreaker - Killer",
    memory_cost = 1,
    pack_code = "core",
    position = 27,
    quantity = 2,
    side_code = "runner",
    strength = 0,
    text = "1[credit]: Break <strong>sentry</strong> subroutine.\n3[credit]: +5 strength.",
    title = "Ninja",
    type_code = "program",
    uniqueness = false,

    --- @param ctx Ctx
    onPowerUp = function (ctx)
        if ctx.runner.bank:debit(SPENDING_ICEBRBREAKER_POWERUP, 3) then
            ctx.meta.until_use.additional_strength = (ctx.meta.until_use.additional_strength or 0) + 5
            return true
        end

        return false
    end,

    --- @param ctx Ctx
    --- @param ice_meta CardMeta
    --- @return boolean
    onBreakIce = function (ctx, ice_meta)
        return ice_meta:keywordsInclude({"Sentry"}) and ctx.runner.bank:debit(SPENDING_ICEBREAKER_BREAK, 1)
    end,
}
Db.card_titles["Ninja"] = 1027

Db.cards[1034] = {
    code = "01034",
    cost = 0,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 2,
    flavor = "Diesel gives you flames.",
    illustrator = "Tim Durning",
    pack_code = "core",
    position = 34,
    quantity = 3,
    side_code = "runner",
    text = "Draw 3 cards.",
    title = "Diesel",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.runner:actionDrawCard()
        ctx.runner:actionDrawCard()
        ctx.runner:actionDrawCard()
        return true
    end,
}
Db.card_titles["Diesel"] = 1034

Db.cards[1035] = {
    code = "01035",
    cost = 0,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 2,
    flavor = "There\'s no replacement for a home-grown program. Fed on late nights, oaty bars and single-minded determination. Cheaper, too.",
    illustrator = "Ralph Beisner",
    keywords = "Mod",
    pack_code = "core",
    position = 35,
    quantity = 2,
    side_code = "runner",
    text = "Install a program or piece of hardware, lowering the install cost by 3.",
    title = "Modded",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function(ctx)
        ctx.prompt:promptSlotSelect(SIDE_RUNNER, SLOT_RUNNER_HAND, 1, function (decision, card, slot)
            ctx.prompt:promptDiscountedInstall(SIDE_RUNNER, SLOT_RUNNER_HARDWARE, card, -3)
            return true
        end)
    end
}
Db.card_titles["Modded"] = 1035

Db.cards[1036] = {
    code = "01036",
    cost = 2,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 2,
    flavor = "\"Some of the professionals have good instincts, but they can\'t see beyond the data. They can\'t see the matrix.\" -Ele \"Smoke\" Scovak",
    illustrator = "Yue Wang",
    keywords = "Run",
    pack_code = "core",
    position = 36,
    quantity = 3,
    side_code = "runner",
    text = "Make a run on R&D. If successful, access 2 additional cards from R&D.",
    title = "The Maker\'s Eye",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        TurnBaseDecision.InitiateRun(ctx.state, SLOT_CORP_RND, 2)
        return true
    end
}
Db.card_titles["The Maker\'s Eye"] = 1036

Db.cards[1037] = {
    code = "01037",
    cost = 0,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 4,
    flavor = "\"There\'s that moment, you know, when the whole world seems to fall away and it is only you and your mod, and the mod is the world.\"",
    illustrator = "Christina Davis",
    keywords = "Mod",
    pack_code = "core",
    position = 37,
    quantity = 3,
    side_code = "runner",
    text = "Choose a piece of ice. That ice gains <strong>sentry</strong>, <strong>code gate</strong>, and <strong>barrier</strong> until the end of the turn.",
    title = "Tinkering",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.prompt:promptSlotSelect(SIDE_RUNNER, isSlotIce, 1, function (decision, card, slot)
            card.meta.until_turn_end.additional_keywords = "Sentry Code Gate Barrier"
            return true
        end)
    end
}
Db.card_titles["Tinkering"] = 1037

Db.cards[1038] = {
    code = "01038",
    cost = 1,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 1,
    flavor = "The Akamatsu company was founded on three principles: first, to make the fastest mem chips on the market, second, to turn a profit, and third, to serve as a front for the manufacture of illegal neural-stimulants. It is the last principle that perhaps explains their rabid brand loyalty.",
    illustrator = "Outland Entertainment LLC",
    keywords = "Chip",
    pack_code = "core",
    position = 38,
    quantity = 2,
    side_code = "runner",
    text = "+1[mu]",
    title = "Akamatsu Mem Chip",
    type_code = "hardware",
    uniqueness = false,

    --- @param ctx Ctx
    onInstall = function (ctx)
        ctx.runner:alterMemory(1)
        return true
    end,

    --- @param ctx Ctx
    onRemoval = function (ctx)
        ctx.runner:alterMemory(-1)
        return true
    end
}
Db.card_titles["Akamatsu Mem Chip"] = 1038

Db.cards[1039] = {
    code = "01039",
    cost = 2,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 1,
    flavor = "It\'s not endless, it just feels that way.",
    illustrator = "Mark Anthony Taduran",
    keywords = "Link",
    pack_code = "core",
    position = 39,
    quantity = 2,
    side_code = "runner",
    text = "+1[link]\nWhen Rabbit Hole is installed, you may search your stack for another copy of Rabbit Hole and install it by paying its install cost. Shuffle your stack.",
    title = "Rabbit Hole",
    type_code = "hardware",
    uniqueness = false,

    --- @param ctx Ctx
    onInstall = function (ctx)
        ctx.prompt:promptDeckSelect(SIDE_RUNNER, SLOT_RUNNER_STACK, -1, 1, function (card)
            if card.uid == 1039 and ctx.runner:actionInstall(card, SLOT_RUNNER_STACK, SLOT_RUNNER_HARDWARE, true) then
                return true
            end
        end)
        return true
    end,
}
Db.card_titles["Rabbit Hole"] = 1039

Db.cards[1040] = {
    code = "01040",
    cost = 2,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 2,
    flavor = "A z-loop here, a cortical wave there…",
    illustrator = "Bruno Balixa",
    keywords = "Mod",
    pack_code = "core",
    position = 40,
    quantity = 2,
    side_code = "runner",
    text = "Install The Personal Touch only on an <strong>icebreaker.</strong>\nHost <strong>icebreaker</strong> has +1 strength.",
    title = "The Personal Touch",
    type_code = "hardware",
    uniqueness = false,

    --- @param ctx Ctx
    onInstall = function (ctx)
        ctx.prompt:promptSlotSelect(SIDE_RUNNER, SLOT_RUNNER_PROGRAMS, 1, function (decision, card, slot)
            if card.meta:isIcebreaker() then
                ctx.meta.installed_into = card.meta
                card.meta.until_forever.additional_strength = (card.meta.until_forever.additional_strength or 0) + 1
                return true
            else
                return false
            end
        end)
        return true
    end,

    --- @param ctx Ctx
    onRemoval = function (ctx)
        local value = ctx.meta.installed_into.until_forever.additional_strength
        ctx.meta.installed_into.until_forever.additional_strength = (value or 1) - 1
    end,
}
Db.card_titles["The Personal Touch"] = 1040

Db.cards[1041] = {
    code = "01041",
    cost = 9,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 2,
    illustrator = "Michael Hamlett",
    keywords = "Console",
    pack_code = "core",
    position = 41,
    quantity = 1,
    side_code = "runner",
    text = "+2[mu] +2[link]\n2[recurring-credit]\nUse these credits to pay for using <strong>icebreakers</strong>.\nLimit 1 <strong>console</strong> per player.",
    title = "The Toolbox",
    type_code = "hardware",
    uniqueness = true,

    --- @param ctx Ctx
    onInstall = function (ctx)
        ctx.runner:alterMemory(2)
        ctx.runner:alterLink(2)
        ctx.runner.bank:addRecurring(CREDITS_FOR_ICEBREAKERS, 2)
        return true
    end,

    --- @param ctx Ctx
    onRemoval = function (ctx)
        ctx.runner:alterMemory(-2)
        ctx.runner:alterLink(-2)
        ctx.runner.bank:subtractRecurring(CREDITS_FOR_ICEBREAKERS, -2)
        return true
    end
}
Db.card_titles["The Toolbox"] = 1041

Db.cards[1043] = {
    code = "01043",
    cost = 4,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 3,
    flavor = "It can slice through the thickest knots of data.",
    illustrator = "Mike Nesbitt",
    keywords = "Icebreaker - Decoder",
    memory_cost = 1,
    pack_code = "core",
    position = 43,
    quantity = 3,
    side_code = "runner",
    strength = 2,
    text = "1[credit]: Break <strong>code gate</strong> subroutine.\n1[credit]: +1 strength for the remainder of this run.",
    title = "Gordian Blade",
    type_code = "program",
    uniqueness = false,

    --- @param ctx Ctx
    --- @param ice_meta CardMeta
    --- @return boolean
    onBreakIce = function (ctx, ice_meta)
        return ice_meta:keywordsInclude({"Code Gate"}) and ctx.runner.bank:debit(SPENDING_ICEBREAKER_BREAK, 1)
    end,

    --- @param ctx Ctx
    --- @return boolean
    onPowerUp = function (ctx)
        if ctx.runner.bank:debit(SPENDING_ICEBRBREAKER_POWERUP, 1) then
            ctx.meta.until_run_end.additional_strength = (ctx.meta.until_run_end.additional_strength or 0) + 1
            return true
        end

        return false
    end
}
Db.card_titles["Gordian Blade"] = 1043

Db.cards[1044] = {
    code = "01044",
    cost = 5,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 2,
    flavor = "The Great Work was completed on a rainy Thursday afternoon. There were no seismic shifts, no solar flares, no sign from the earth or heavens that the world had changed. But upstalk in Heinlein, on a single Cybsoft manufactured datacore, the flickering data quantums of an account began to fill with creds. Real, honest-to-goodness UN certified creds.",
    illustrator = "Outland Entertainment LLC",
    memory_cost = 2,
    pack_code = "core",
    position = 44,
    quantity = 2,
    side_code = "runner",
    text = "[click]: Gain 2[credit].",
    title = "Magnum Opus",
    type_code = "program",
    uniqueness = false,

    action_click_cost = 1,

    --- @param ctx Ctx
    onAction = function (ctx)
        ctx.runner.bank:credit(2)
        return true
    end
}
Db.card_titles["Magnum Opus"] = 1044

Db.cards[1048] = {
    code = "01048",
    cost = 0,
    deck_limit = 3,
    faction_code = "shaper",
    faction_cost = 1,
    flavor = "The life expectancy of a jacked construct is about that of a mayfly. In other words, short.",
    illustrator = "Matt Zeilinger",
    keywords = "Remote",
    pack_code = "core",
    position = 48,
    quantity = 2,
    side_code = "runner",
    text = "[trash]: Prevent an installed program or an installed piece of hardware from being trashed.",
    title = "Sacrificial Construct",
    type_code = "resource",
    uniqueness = false,

    --- @param ctx Ctx
    --- @param card Card
    canBeSacrificed = function (ctx, card, slot)
        return slot == SLOT_RUNNER_PROGRAMS or slot == SLOT_RUNNER_HARDWARE
    end,
}
Db.card_titles["Sacrificial Construct"] = 1048

Db.cards[1049] = {
    code = "01049",
    cost = 0,
    deck_limit = 3,
    faction_code = "neutral-runner",
    faction_cost = 0,
    flavor = "\"Bring back any memories, Monica?\" -John \"Animal\" McEvoy",
    illustrator = "Imaginary FS Pte Ltd",
    pack_code = "core",
    position = 49,
    quantity = 3,
    side_code = "runner",
    text = "Gain 2[credit] or expose 1 card.",
    title = "Infiltration",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        local options = {
            ["credits"] = "Gain 2[credit]",
            ["expose"] = "Expose 1 card",
        }

        ctx.prompt:promptOptionSelect(SIDE_RUNNER, options, function (opt_id)
            if opt_id == "credits" then
                ctx.runner.bank:credit(2)
            elseif opt_id == "expose" then
                ctx.prompt:promptSlotSelect(SIDE_RUNNER, function () return true end, 1, function (decision, card, slot)
                    if not card.faceup then
                        ctx.prompt:displayFaceup(SIDE_RUNNER, card)
                        return true
                    end

                    return false
                end)
            else
                return false
            end

            return true
        end)
    end,
}
Db.card_titles["Infiltration"] = 1049

Db.cards[1050] = {
    code = "01050",
    cost = 5,
    deck_limit = 3,
    faction_code = "neutral-runner",
    faction_cost = 0,
    flavor = "Lady Luck took the form of a hifi quantum manipulation ring that she wore on her middle finger.",
    illustrator = "Kate Niemczyk",
    pack_code = "core",
    position = 50,
    quantity = 3,
    side_code = "runner",
    text = "Gain 9[credit].",
    title = "Sure Gamble",
    type_code = "event",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.runner.bank:credit(9)
        return true
    end
}
Db.card_titles["Sure Gamble"] = 1050

Db.cards[1051] = {
    code = "01051",
    cost = 5,
    deck_limit = 3,
    faction_code = "neutral-runner",
    faction_cost = 0,
    illustrator = "Mauricio Herrera",
    keywords = "Icebreaker - AI - Virus",
    memory_cost = 1,
    pack_code = "core",
    position = 51,
    quantity = 3,
    side_code = "runner",
    strength = 0,
    text = "1[credit]: Break ice subroutine.\n1[credit]: +1 strength.\n[click]: Place 1 virus counter on Crypsis.\nWhen an encounter with a piece of ice in which you used Crypsis to break a subroutine ends, remove 1 hosted virus counter or trash Crypsis.",
    title = "Crypsis",
    type_code = "program",
    uniqueness = false,

    --- @param ctx Ctx
    onPowerUp = function (ctx)
        if ctx.runner.bank:debit(SPENDING_ICEBRBREAKER_POWERUP, 1) then
            ctx.meta.until_use.additional_strength = (ctx.meta.until_use.additional_strength or 0) + 1
            return true
        end
    end,

    --- @param ctx Ctx
    onAction = function (ctx)
        ctx.meta.virus_counter = (ctx.meta.virus_counter or 0) + 1
        return true
    end,

    --- @param ctx Ctx
    --- @param ice_meta CardMeta
    --- @return boolean
    onBreakIce = function (ctx, ice_meta)
        if ctx.runner.bank:debit(SPENDING_ICEBREAKER_BREAK, 1) then
            ctx.meta.virus_tagged = true
            return true
        end
    end,

    --- @param ctx Ctx
    onIceEncounterEnd = function (ctx)
        if ctx.meta.virus_tagged then
            if (ctx.meta.virus_counter or 0) > 0 then
                ctx.meta.virus_counter = ctx.meta.virus_counter - 1
            else
                ctx.runner:discard(ctx.card)
            end
        end

        return true
    end
}

Db.card_titles["Crypsis"] = 1051

Db.cards[1053] = {
    code = "01053",
    cost = 1,
    deck_limit = 3,
    faction_code = "neutral-runner",
    faction_cost = 0,
    flavor = "Drudge work, but it pays the bills.",
    illustrator = "Mauricio Herrera",
    keywords = "Job",
    pack_code = "core",
    position = 53,
    quantity = 3,
    side_code = "runner",
    text = "Place 12[credit] from the bank on Armitage Codebusting when it is installed. When there are no credits left on Armitage Codebusting, trash it.\n[click]: Take 2[credit] from Armitage Codebusting.",
    title = "Armitage Codebusting",
    type_code = "resource",
    uniqueness = false,

    --- @param ctx Ctx
    onInstall = function(ctx)
        ctx.meta.credits = 12
        return true
    end,

    --- @param ctx Ctx
    onAction = function (ctx)
        ctx.runner.bank:credit(2)
        ctx.meta.credits = ctx.meta.credits - 2
        if ctx.meta.credits <= 0 then
            ctx.runner:discard(ctx.card)
        end
        return true
    end,
}
Db.card_titles["Armitage Codebusting"] = 1053

Db.cards[1056] = {
    code = "01056",
    cost = 4,
    deck_limit = 3,
    faction_code = "haas-bioroid",
    faction_cost = 2,
    illustrator = "Mark Anthony Taduran",
    keywords = "Advertisement",
    pack_code = "core",
    position = 56,
    quantity = 3,
    side_code = "corp",
    text = "Put 12[credit] from the bank on Adonis Campaign when rezzed. When there are no credits left on Adonis Campaign, trash it.\nTake 3[credit] from Adonis Campaign when your turn begins.",
    title = "Adonis Campaign",
    trash_cost = 3,
    type_code = "asset",
    uniqueness = false,

    --- @param ctx Ctx
    onRez = function (ctx)
        ctx.meta.credits_pool = 12
        return true
    end,

    --- @param ctx Ctx
    onNewTurn = function (ctx)
        ctx.meta.credits_pool = ctx.meta.credits_pool - 3
        ctx.corp.bank:credit(3)
        if ctx.meta.credits_pool <= 0 then
            ctx.corp:discard(ctx.card)
        end

        return true
    end,
}
Db.card_titles["Adonis Campaign"] = 1056

Db.cards[1064] = {
    code = "01064",
    cost = 4,
    deck_limit = 3,
    faction_code = "haas-bioroid",
    faction_cost = 1,
    flavor = "Whrrrrr!",
    illustrator = "Ed Mattinian",
    keywords = "Sentry - Destroyer",
    pack_code = "core",
    position = 64,
    quantity = 2,
    side_code = "corp",
    strength = 0,
    text = "[subroutine] Trash 1 program.\n[subroutine] End the run.",
    title = "Rototurret",
    type_code = "ice",
    uniqueness = false,

    subroutine_descriptions = {
        "Trash 1 program",
        _end_the_run_description,
    },

    subroutines = {
        --- @param ctx Ctx
        function (ctx)
            ctx.prompt:promptSlotSelect(SIDE_RUNNER, SLOT_RUNNER_PROGRAMS, 1, function (decision, card, slot)
                ctx.runner:discard(card)
                return true
            end, true)
        end,

        _end_the_run_subroutine,
    },
}
Db.card_titles["Rototurret"] = 1064

Db.cards[1083] = {
    code = "01083",
    cost = 0,
    deck_limit = 3,
    faction_code = "nbn",
    faction_cost = 1,
    flavor = "\"Please stay connected. Priority transfer in progress. An operator will shortly verif-\"",
    illustrator = "Mike Nesbitt",
    pack_code = "core",
    position = 83,
    quantity = 2,
    side_code = "corp",
    text = "Draw 3 cards.",
    title = "Anonymous Tip",
    type_code = "operation",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.corp:drawCard()
        ctx.corp:drawCard()
        ctx.corp:drawCard()
        return true
    end,
}
Db.card_titles["Anonymous Tip"] = 1083

Db.cards[1090] = {
    code = "01090",
    cost = 8,
    deck_limit = 3,
    faction_code = "nbn",
    faction_cost = 2,
    flavor = "\"Ever heard of a catch-22?\"\n\"Remind me to forget it.\"",
    illustrator = "Outland Entertainment LLC",
    keywords = "Code Gate",
    pack_code = "core",
    position = 90,
    quantity = 3,
    side_code = "corp",
    strength = 5,
    text = "When the Runner encounters Tollbooth, he or she must pay 3[credit], if able. If the Runner cannot pay 3[credit], end the run.\n[subroutine] End the run.",
    title = "Tollbooth",
    type_code = "ice",
    uniqueness = false,

    --- @param ctx Ctx
    onIceEncounterStart = function (ctx)
        if not ctx.runner.bank:debit(SPENDING_INVOLUNTARY, 3) then
            ctx.state.stack:popUpTo(RunEndDecision.Type)
        end

        return true
    end,

    subroutine_descriptions = {
        _end_the_run_description,
    },

    subroutines = {
        _end_the_run_subroutine,
    }
}
Db.card_titles["Tollbooth"] = 1090

Db.cards[1094] = {
    advancement_cost = 2,
    agenda_points = 1,
    code = "01094",
    deck_limit = 3,
    faction_code = "weyland-consortium",
    flavor = "There are going to be some changes around here.",
    illustrator = "Mauricio Herrera",
    keywords = "Expansion",
    pack_code = "core",
    position = 94,
    quantity = 3,
    side_code = "corp",
    text = "When you score Hostile takeover, gain 7[credit] and take 1 bad publicity.",
    title = "Hostile Takeover",
    type_code = "agenda",
    uniqueness = false,

    --- @param ctx Ctx
    onScore = function (ctx)
        ctx.corp.bank:credit(7)
        ctx.corp:alterBadPublicity(1)
        return true
    end,
}
Db.card_titles["Hostile Takeover"] = 1094

Db.cards[1095] = {
    advancement_cost = 3,
    agenda_points = 1,
    code = "01095",
    deck_limit = 3,
    faction_code = "weyland-consortium",
    flavor = "\"If some two-cred newsy picks it up, even better. The scum could be in the alleys of Guayaquil of the slums of BosWash. Not to mention off-planet.\"",
    illustrator = "Mauricio Herrera",
    keywords = "Security",
    pack_code = "core",
    position = 95,
    quantity = 2,
    side_code = "corp",
    text = "When you score Posted Bounty, you may forfeit it to give the Runner 1 tag and take 1 bad publicity.",
    title = "Posted Bounty",
    type_code = "agenda",
    uniqueness = false,

    --- @param ctx Ctx
    onScore = function (ctx)
        local options = {
            ["forfeit"] = "Forfeit",
            ["score"] = "Score",
        }
        ctx.prompt:promptOptionSelect(SIDE_CORP, options, function (opt)
            if opt == "forfeit" then
                ctx.runner:alterTags(1)
                ctx.corp:alterBadPublicity(1)
                return true
            elseif opt == "score" then
                ctx.corp:alterScore(ctx.meta.info.agenda_points)
                return true
            end
        end)
        return false
    end,
}
Db.card_titles["Posted Bounty"] = 1095

Db.cards[1098] = {
    code = "01098",
    cost = 0,
    deck_limit = 3,
    faction_code = "weyland-consortium",
    faction_cost = 1,
    flavor = "The New Angeles Space Elevator, better known as the Beanstalk, is the single greatest triumph of human engineering and ingenuity in history. The Beanstalk makes Earth orbit accessible to everyone…for a small fee.",
    illustrator = "Jonathan Lee",
    keywords = "Transaction",
    pack_code = "core",
    position = 98,
    quantity = 3,
    side_code = "corp",
    text = "Gain 3[credit].",
    title = "Beanstalk Royalties",
    type_code = "operation",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.corp.bank:credit(3)
        return true
    end,
}
Db.card_titles["Beanstalk Royalties"] = 1098

Db.cards[1100] = {
    code = "01100",
    cost = 0,
    deck_limit = 3,
    faction_code = "weyland-consortium",
    faction_cost = 1,
    flavor = "\"And then there\'s these two crates. No eID.\"\n\"Just leave those with me and forget you ever saw them.\"",
    illustrator = "Andrew Mar",
    pack_code = "core",
    position = 100,
    quantity = 2,
    side_code = "corp",
    text = "Place 1 advancement token on each of up to 2 different installed cards that can be advanced.",
    title = "Shipment from Kaguya",
    type_code = "operation",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        local prev_card = nil
        local fn = function (card)
            if prev_card and prev_card.uid == card.uid then
                return false
            end

            prev_card = card
            return true
        end

        ctx.prompt:promptFreeAdvance(SIDE_CORP, fn)
        ctx.prompt:promptFreeAdvance(SIDE_CORP, fn)
        return true
    end,
}
Db.card_titles["Shipment from Kaguya"] = 1100

--- @param ctx Ctx
_archer_trash_program_subroutine = function (ctx)
    ctx.prompt:promptSlotSelect(
            SIDE_RUNNER,
            function (slot) return slot == SLOT_RUNNER_PROGRAMS or slot == SLOT_RUNNER_RESOURCES end,
            1,
            function (decision, card, slot)
                if card.meta:canBeSacrificed(ctx.state, card, ctx.card, SLOT_RUNNER_PROGRAMS) then
                    ctx.runner:discard(card)
                    return true
                elseif slot == SLOT_RUNNER_PROGRAMS then
                    ctx.runner:discard(card)
                    return true
                end

                return false
            end,
            true)
    return true
end

Db.cards[1101] = {
    code = "01101",
    cost = 4,
    deck_limit = 3,
    faction_code = "weyland-consortium",
    faction_cost = 2,
    flavor = "Next time, read the Terms of Service more carefully. Or you might find yourself in the danger zone.",
    illustrator = "Mike Nesbitt",
    keywords = "Sentry - Destroyer",
    pack_code = "core",
    position = 101,
    quantity = 2,
    side_code = "corp",
    strength = 6,
    text = "As an additional cost to rez Archer, the Corp must forfeit an agenda.\n[subroutine] The Corp gains 2[credit].\n[subroutine] Trash 1 program.\n[subroutine] Trash 1 program.\n[subroutine] End the run.",
    title = "Archer",
    type_code = "ice",
    uniqueness = false,

    --- @param ctx Ctx
    onRez = function (ctx)
        ctx.prompt:promptSlotSelect(SIDE_CORP, SLOT_CORP_HAND, 1, function (decision, card, slot)
            if card.meta:isAgenda() and ctx.corp:payPrice(ctx.meta, SPENDING_ICE_REZ) then
                ctx.corp:rez(ctx.card)
                ctx.corp:discard(card)
                decision:handledTop()
                return true
            end
        end)
        return true
    end,

    subroutine_descriptions = {
        "The Corp gains 2[credit]",
        "Trash 1 program",
        "Trash 1 program",
        _end_the_run_description,
    },

    subroutines = {
        --- @param ctx Ctx
        function (ctx)
            ctx.corp.bank:credit(2)
        end,

        _archer_trash_program_subroutine,
        _archer_trash_program_subroutine,

        _end_the_run_subroutine,
    },
}
Db.card_titles["Archer"] = 1101

Db.cards[1102] = {
    code = "01102",
    cost = 10,
    deck_limit = 3,
    faction_code = "weyland-consortium",
    faction_cost = 3,
    flavor = "\"He had a bit of an ego, ol\' Hadrian. His constructs live up to it though.\" -g00ru",
    illustrator = "Bruno Balixa",
    keywords = "Barrier",
    pack_code = "core",
    position = 102,
    quantity = 2,
    side_code = "corp",
    strength = 7,
    text = "Hadrian\'s Wall can be advanced and has +1 strength for each advancement token on it.\n[subroutine] End the run.\n[subroutine] End the run.",
    title = "Hadrian\'s Wall",
    type_code = "ice",
    uniqueness = false,

    subroutine_descriptions = {
        _end_the_run_description,
        _end_the_run_description,
    },

    subroutines = {
        _end_the_run_subroutine,
        _end_the_run_subroutine,
    }
}
Db.card_titles["Hadrian\'s Wall"] = 1102

Db.cards[1103] = {
    code = "01103",
    cost = 1,
    deck_limit = 3,
    faction_code = "weyland-consortium",
    faction_cost = 1,
    flavor = "\"I asked for ice as impenetrable as a wall. I can\'t decide if someone down in R&D has a warped sense of humor or just a very literal mind.\" -Liz Campbell, VP Project Security",
    illustrator = "Matt Zeilinger",
    keywords = "Barrier",
    pack_code = "core",
    position = 103,
    quantity = 3,
    side_code = "corp",
    strength = 1,
    text = "Ice Wall can be advanced and has +1 strength for each advancement token on it.\n[subroutine] End the run.",
    title = "Ice Wall",
    type_code = "ice",
    uniqueness = false,

    --- @param ctx Ctx
    canBeAdvanced = function (ctx) return true end,

    --- @param ctx Ctx
    onAdvance = function (ctx)
        ctx.meta.until_forever.additional_strength = (ctx.meta.until_forever.additional_strength or 0) + 1
        return true
    end,

    subroutine_descriptions = {
        _end_the_run_description,
    },

    subroutines = {
        _end_the_run_subroutine,
    },
}
Db.card_titles["Ice Wall"] = 1103

Db.cards[1104] = {
    code = "01104",
    cost = 3,
    deck_limit = 3,
    faction_code = "weyland-consortium",
    faction_cost = 1,
    flavor = "Who knows what evil lurks in the memory diamonds of men? Weyland knows. -unsigned cyber-graffiti",
    illustrator = "Adam S. Doyle",
    keywords = "Sentry - Tracer",
    pack_code = "core",
    position = 104,
    quantity = 3,
    side_code = "corp",
    strength = 1,
    text = "Shadow can be advanced and has +1 strength for each advancement token on it.\n[subroutine] The Corp gains 2[credit].\n[subroutine] <trace>Trace 3</trace> If successful, give the Runner 1 tag.",
    title = "Shadow",
    type_code = "ice",
    uniqueness = false,

    --- @param ctx Ctx
    canBeAdvanced = function (ctx) return true end,

    --- @param ctx Ctx
    onAdvance = function (ctx)
        ctx.meta.until_forever.additional_strength = (ctx.meta.until_forever.additional_strength or 0) + 1
        return true
    end,

    subroutine_descriptions = {
        "The Corp gains 2[credit]",
        "<trace>Trace 3</trace> If successful, give the Runner 1 tag",
    },

    subroutines = {
        --- @param ctx Ctx
        function (ctx)
            ctx.corp.bank:credit(2)
        end,

        --- @param ctx Ctx
        function (ctx)
            if ctx.runner:trace(3) then
                ctx.runner:alterTags(1)
            end
        end,
    },

}
Db.card_titles["Shadow"] = 1104

Db.cards[1106] = {
    advancement_cost = 5,
    agenda_points = 3,
    code = "01106",
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "\"If it isn\'t in my terminal by six p.m., heads are going to roll!\"",
    illustrator = "Gong Studios",
    keywords = "Security",
    pack_code = "core",
    position = 106,
    quantity = 3,
    side_code = "corp",
    text = "When you score Priority Requisition, you may rez a piece of ice ignoring all costs.",
    title = "Priority Requisition",
    type_code = "agenda",
    uniqueness = false,

    --- @param ctx Ctx
    onScore = function (ctx)
        ctx.prompt:promptSlotSelect(SIDE_CORP, isSlotIce, 1, function (decision, card, slot)
            return ctx.corp:actionRez(card, slot, -99)
        end)

        return true
    end
}
Db.card_titles["Priority Requisition"] = 1106

Db.cards[1107] = {
    advancement_cost = 4,
    agenda_points = 2,
    code = "01107",
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "\"Expensive? Not when you\'re protecting a fortune as large as ours.\"",
    illustrator = "Mauricio Herrera",
    keywords = "Security",
    pack_code = "core",
    position = 107,
    quantity = 3,
    side_code = "corp",
    text = "If the Runner is tagged, Private Security Force gains: \"[click]: Do 1 meat damage.\"",
    title = "Private Security Force",
    type_code = "agenda",
    uniqueness = false,

    --- @param ctx Ctx
    onAction = function (ctx)
        if ctx.runner:isTagged() then
            ctx.runner:meatDamage(1)
            return true
        end
    end,
}
Db.card_titles["Private Security Force"] = 1107

Db.cards[1108] = {
    code = "01108",
    cost = 1,
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "\"The mining bosses are worse than any downstalk crime lords. Tri-Maf, 4K, Yak, I don\'t care what gangs you got down there. In Heinlein there\'s just one law: the He3 must flow.\" -\"Old\" Rick Henry, escaped clone.",
    illustrator = "Henning Ludvigsen",
    pack_code = "core",
    position = 108,
    quantity = 2,
    side_code = "corp",
    text = "[click], [click], [click]: Gain 7[credit].",
    title = "Melange Mining Corp.",
    trash_cost = 1,
    type_code = "asset",
    uniqueness = false,

    --- @param ctx Ctx
    canAction = function (ctx) return game.corp.clicks >= 3 end,

    --- @param ctx Ctx
    onAction = function (ctx)
        if ctx.state:alterClicks(SIDE_CORP, -2) then
            ctx.corp.bank:credit(7)
            return true
        end
    end
}
Db.card_titles["Melange Mining Corp."] = 1108

Db.cards[1109] = {
    code = "01109",
    cost = 2,
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "It is like the one you just bought, only better.",
    illustrator = "Alexandra Douglass",
    keywords = "Advertisement",
    pack_code = "core",
    position = 109,
    quantity = 3,
    side_code = "corp",
    text = "Gain 1[credit] when your turn begins.",
    title = "PAD Campaign",
    trash_cost = 4,
    type_code = "asset",
    uniqueness = false,

    --- @param ctx Ctx
    onNewTurn = function (ctx)
        ctx.corp.bank:credit(1)
        return true
    end,
}
Db.card_titles["PAD Campaign"] = 1109

Db.cards[1110] = {
    code = "01110",
    cost = 5,
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "Hedge Fund. Noun. An ingenious device by which the rich get richer even while every other poor SOB is losing his shirt. -The Anarch\'s Dictionary, Volume Who\'s Counting?",
    illustrator = "Gong Studios",
    keywords = "Transaction",
    pack_code = "core",
    position = 110,
    quantity = 3,
    side_code = "corp",
    text = "Gain 9[credit].",
    title = "Hedge Fund",
    type_code = "operation",
    uniqueness = false,

    --- @param ctx Ctx
    onPlay = function (ctx)
        ctx.corp.bank:credit(9)
        return true
    end,
}
Db.card_titles["Hedge Fund"] = 1110

Db.cards[1111] = {
    code = "01111",
    cost = 3,
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "\"Hey, hey! Wake up man. You were under a long time. What\'d you see?\"\n\"I…don\'t remember.\"",
    illustrator = "Liiga Smilshkalne",
    keywords = "Code Gate",
    pack_code = "core",
    position = 111,
    quantity = 3,
    side_code = "corp",
    strength = 2,
    text = "[subroutine] The Runner loses [click], if able.\n[subroutine] End the run.",
    title = "Enigma",
    type_code = "ice",
    uniqueness = false,

    subroutine_descriptions = {
        "The Runner loses [click], if able",
        _end_the_run_description,
    },

    subroutines = {
        --- @param ctx Ctx
        function (ctx)
            ctx.state:alterClicks(SIDE_RUNNER, -1)
        end,

        _end_the_run_subroutine,
    }
}
Db.card_titles["Enigma"] = 1111

Db.cards[1113] = {
    code = "01113",
    cost = 3,
    deck_limit = 3,
    faction_code = "neutral-corp",
    faction_cost = 0,
    flavor = "\"There\'s nothing worse than seeing that beautiful blue ball of data just out of reach as your connection derezzes. I think they do it just to taunt us.\" -Ele \"Smoke\" Scovak",
    illustrator = "Adam S. Doyle",
    keywords = "Barrier",
    pack_code = "core",
    position = 113,
    quantity = 3,
    side_code = "corp",
    strength = 3,
    text = "[subroutine] End the run.",
    title = "Wall of Static",
    type_code = "ice",
    uniqueness = false,

    subroutine_descriptions = {
        _end_the_run_description,
    },

    subroutines = {
        _end_the_run_subroutine,
    },
}
Db.card_titles["Wall of Static"] = 1113
Db.cards[1033] = {
    base_link = 1,
    code = "01033",
    deck_limit = 1,
    faction_code = "shaper",
    flavor = "\"Are you listening?\"",
    illustrator = "Ralph Beisner",
    influence_limit = 15,
    keywords = "Natural",
    minimum_deck_size = 45,
    pack_code = "core",
    position = 33,
    quantity = 1,
    side_code = "runner",
    text = "Lower the install cost of the first program or piece of hardware you install each turn by 1.",
    title = "Kate \"Mac\" McCaffrey: Digital Tinker",
    type_code = "identity",
    uniqueness = false,
}
Db.card_titles["Kate \"Mac\" McCaffrey: Digital Tinker"] = 1033

Db.cards[1093] = {
    code = "01093",
    deck_limit = 1,
    faction_code = "weyland-consortium",
    flavor = "Moving Upwards.",
    influence_limit = 15,
    keywords = "Megacorp",
    minimum_deck_size = 45,
    pack_code = "core",
    position = 93,
    quantity = 1,
    side_code = "corp",
    text = "Gain 1[credit] whenever you play a <strong>transaction</strong> operation.",
    title = "Weyland Consortium: Building a Better World",
    type_code = "identity",
    uniqueness = false,
}
Db.card_titles["Weyland Consortium: Building a Better World"] = 1093
