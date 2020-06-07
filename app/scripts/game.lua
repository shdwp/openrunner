inspect = dofile(libpath .. "inspect.lua/inspect.lua")

game = {
    turn = "corp",
    turn_n = 1,
    last_run_turn_n = 0,
    last_successfull_run_turn_n = 0,
    last_agenda_scored_turn_n = 0,
}

function game.onInit()
    game.corp = Corp.new()
    game.runner = {
        credits,
        tags,
    }

    host:info("Loading packs...");
    db:loadPack("core")

    host:info("Dealing initial cards...");
    board:cardAppend("corp_hq", db:card(1093))

    local deck = db:deck([[3 Hostile Takeover
2 Posted Bounty
3 Priority Requisition
3 Private Security Force
3 Adonis Campaign
2 Melange Mining Corp.
3 PAD Campaign
1 Anonymous Tip
3 Beanstalk Royalties
3 Hedge Fund
2 Shipment from Kaguya
2 Hadrian's Wall
3 Ice Wall
3 Wall of Static
3 Enigma
3 Tollbooth
2 Archer
2 Rototurret
3 Shadow
]]
    )
    deck:shuffle()

    board:deckAppend("corp_rnd", deck)
    board:cardAppend("corp_hand", db:card(1094))
    board:cardAppend("corp_hand", db:card(1095))
    board:cardAppend("corp_hand", db:card(1056))
    board:cardAppend("corp_hand", db:card(1083))
    board:cardAppend("corp_hand", db:card(1103))
    board:cardAppend("corp_hand", db:card(1098))

    host:info("Game ready!")
end

function game:sideEndedTurn()
    host:info("side " .. self.turn .. " ended turn")
    self.turn_n = self.turn_n + 1
    game.corp:newTurn()
end
