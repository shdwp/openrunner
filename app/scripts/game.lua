--- @class game
--- @field interaction_stack InteractionStack
--- @field current_side string
--- @field corp Corp
--- @field runner Runner
game = {
    turn_n = 1,
    current_side,

    player_controllers = {},
    interaction_stack,

    last_run_turn_n = 0,
    last_successfull_run_turn_n = 0,
    last_agenda_scored_turn_n = 0,
}

--- @param player string const
--- @return PlayerController
function game:controllerFor(player)
    return self.player_controllers[player]
end

function game:cycle()
    info("Game cycle")
    if game.interaction_stack:empty() then
        if self.turn_n > 1 then
            self.corp:newTurn()
            self.runner:newTurn()
        end

        local clicks = 0
        if self.current_side == nil or self.current_side == SIDE_RUNNER then
            self.current_side = SIDE_CORP
            clicks = self.corp.max_clicks
        else
            self.current_side = SIDE_RUNNER
            clicks = self.runner.max_clicks
        end

        -- @TODO: remove
        self.current_side = SIDE_CORP

        for _ = 0, clicks do
            self.interaction_stack:push(TurnBasePhase:New(self.current_side))
        end

        self.turn_n = self.turn_n + 1
    end

    local phase = self.interaction_stack:top()
    local ctrl = self:controllerFor(phase.side)

    ctrl:handle(phase)
end

--- @param phase InteractionPhase
function game:pushPhase(phase)
    self.interaction_stack:push(phase)
end

function game:popPhase()
    self.interaction_stack:pop()
end

--- @param phase InteractionPhase
--- @return boolean
function game:popIfTop(phase)
    if self.interaction_stack:top() == phase then
        self:popPhase()
        return true
    end

    return false
end

--- @param side string
--- @return number
function game:countClicks(side)
    return self.interaction_stack:countClicks(side)
end

--- @param side string
--- @param amount number
function game:alterClicks(side, amount)
    if amount >= 0 then
        self.interaction_stack:addClicks(side, amount)
    elseif amount < 0 then
        self.interaction_stack:removeClicks(side, amount)
    end
end

function game:onInit()
    info("Game init")
    self.corp = Corp:New()
    self.runner = Runner:New()
    self.runner:newTurn()

    self.corp:alterCredits(12)

    self.player_controllers[SIDE_CORP] = HumanController:New()
    self.player_controllers[SIDE_RUNNER] = HumanController:New()

    host:register(self.player_controllers[SIDE_CORP])

    self.interaction_stack = InteractionStack:New()

    info("Loading packs...");
    db:loadPack("core")

    if board:cardGet("corp_hq", 0) == nil then
        info("Dealing initial cards...");
        board:cardAppend("corp_hq", db:card(1093))

        local deck = db:deck([[
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
        board:cardAppend("corp_hand", db:card(1060))
        board:cardAppend("corp_hand", db:card(1073))
    end

    info("Game ready!")
    self:cycle()
end

host:register(game)
