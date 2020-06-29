function GameState:testState()
    self.board:append(SLOT_CORP_HQ, Db:card(1093))
    
    local rnd_deck = Db:deck([[
3 Hostile Takeover
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
3 Shadow]]
    )
    rnd_deck:shuffle()
    
    self.board:append(SLOT_CORP_RND, rnd_deck)
    self.board:append(SLOT_CORP_ARCHIVES, Deck())
    
    -- RUNNER
    self.board:append(SLOT_RUNNER_ID, Db:card(1033))
    local stack = Db:deck([[
3 Diesel
3 Easy Mark
3 Infiltration
2 Modded
3 Sure Gamble
3 The Maker's Eye
2 Tinkering
2 Akamatsu Mem Chip
3 Cyberfeeder
2 Rabbit Hole
2 The Personal Touch
1 The Toolbox
3 Armitage Codebusting
2 Sacrificial Construct
2 Corroder
2 Crypsis
1 Femme Fatale
2 Gordian Blade
2 Ninja
2 Magnum Opus
]])
    
    stack:shuffle()
    self.board:append(SLOT_RUNNER_STACK, stack)
    self.board:append(SLOT_RUNNER_HEAP, Deck())
    
    self.board:append(remoteSlot(1), Db:card("Hostile Takeover", {faceup = false}))
    self.board:append(remoteIceSlot(1), Db:card("Enigma", {faceup = false}))
    
    self.board:append(SLOT_RUNNER_PROGRAMS, Db:card(1043))
    self.board:append(SLOT_RUNNER_PROGRAMS, Db:card(1027))
    self.board:append(SLOT_RUNNER_PROGRAMS, Db:card(1051))
    
    -- Hands
    --self.board:append(SLOT_CORP_HAND, Db:card("Hostile Takeover"))
    --self.board:append(SLOT_CORP_HAND, Db:card("Adonis Campaign"))
    --self.board:append(SLOT_CORP_HAND, Db:card("Melange Mining Corp."))
    --self.board:append(SLOT_CORP_HAND, Db:card("Ice Wall"))
    
    self.board:append(SLOT_RUNNER_HAND, Db:card("Cyberfeeder"))
    self.board:append(SLOT_RUNNER_HAND, Db:card("Diesel"))
    self.board:append(SLOT_RUNNER_HAND, Db:card("Infiltration"))
    self.board:append(SLOT_RUNNER_HAND, Db:card("The Personal Touch"))
    self.board:append(SLOT_RUNNER_HAND, Db:card("Femme Fatale"))
    self.board:append(SLOT_RUNNER_HAND, Db:card("The Maker\'s Eye"))
end