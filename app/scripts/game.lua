--- @class game
--- @field state GameState
--- @field current_side string
--- @field player_controllers table<number, PlayerController>
game = {
    player_controllers = {},
    last_ui_update = 0,
}

--- @param player string const
--- @return PlayerController
function game:controllerFor(player)
    return self.player_controllers[player]
end

function game:cycle()
    info("Game cycle")
    -- @TODO: ref
    if self.state.decision_stack:empty() then
        self:newTurn()
    end

    for _, c in pairs(self.player_controllers) do
        c:clear()
    end

    local decision = self.state.stack:top()
    if self.state.current_side ~= decision.side.id then
        self.state.current_side = decision.side.id
        ui:focusCurrentPlayer()
    end

    if decision:autoHandle() then
        return
    end

    if decision.type == TurnBaseDecision.Type then
        self:save()
    end

    local ctrl = self:controllerFor(decision.side.id)
    ctrl:handle(decision)
end

function game:endInFavor(side_id)
    -- @TODO: ref
    assert()
    game.decision_stack:push(GameEndDecision:New(side_id))
    game.decision_stack:pop()
    game:cycle()
end

function game:onInit()
    info("Game init")
    self.state = GameState:New(board)
    
    -- self.player_controllers[SIDE_CORP] = AIController:New(SIDE_CORP)
    self.player_controllers[SIDE_RUNNER] = HumanController:New(self.state, SIDE_RUNNER)

    host:register(self.player_controllers[SIDE_CORP])
    host:register(self.player_controllers[SIDE_RUNNER])

    --[[
    if board:cardGet("corp_hq", 0) == nil then
        info("Dealing initial cards...");

        -- CORP
        board:cardAppend(SLOT_CORP_HQ, Db:card(1093))
        local rnd_deck = Db:deck(
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
3 Shadow

        )
        rnd_deck:shuffle()
        board:deckAppend(SLOT_CORP_RND, rnd_deck)
        board:deckAppend(SLOT_CORP_ARCHIVES, Deck())

        -- RUNNER
        board:cardAppend(SLOT_RUNNER_ID, Db:card(1033))
        local stack = Db:deck(
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
)

        stack:shuffle()
        board:deckAppend(SLOT_RUNNER_STACK, stack)
        board:deckAppend(SLOT_RUNNER_HEAP, Deck())

        board:cardAppend(remoteSlot(1), Db:card("Hostile Takeover", {faceup = false}))
        board:cardAppend(remoteIceSlot(1), Db:card("Enigma", {faceup = false}))

        board:cardAppend(SLOT_RUNNER_PROGRAMS, Db:card(1043))
        board:cardAppend(SLOT_RUNNER_PROGRAMS, Db:card(1027))
        board:cardAppend(SLOT_RUNNER_PROGRAMS, Db:card(1051))

        -- Hands
        board:cardAppend(SLOT_CORP_HAND, Db:card("Hostile Takeover"))
        board:cardAppend(SLOT_CORP_HAND, Db:card("Adonis Campaign"))
        board:cardAppend(SLOT_CORP_HAND, Db:card("Melange Mining Corp."))
        board:cardAppend(SLOT_CORP_HAND, Db:card("Ice Wall"))

        board:cardAppend(SLOT_RUNNER_HAND, Db:card("Cyberfeeder"))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card("Diesel"))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card("Infiltration"))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card("The Personal Touch"))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card("Femme Fatale"))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card("The Maker\'s Eye"))
    else
        self:load()
    end
    --]]

    info("Game ready!")
    self:cycle()
    end

function game:onTick(dt)
    if dt - self.last_ui_update > 1 then
        local text = ""
        for _, v in pairs(self.decision_stack.stack) do
            text = string.format("%s\n%s %s", text, v.side.id, v.type)
        end

        alert_label:setText(text)
        self.last_ui_update = dt
    end
end

function game:onInteraction(type, descr)
    for _, ctrl in pairs(self.player_controllers) do
        if ctrl:interaction(type, descr) then
            break
        end
    end

    self.last_ui_update = 0
end

host:register(game)
