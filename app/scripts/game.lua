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

    last_ui_update = 0,
}

--- @param player string const
--- @return PlayerController
function game:controllerFor(player)
    return self.player_controllers[player]
end

function game:cycle()
    info("Game cycle")
    if game.interaction_stack:empty() then
        game:newTurn()
    end

    local phase = self.interaction_stack:top()
    local ctrl = self:controllerFor(phase.side)

    ctrl:handle(phase)
end

--- @param phase InteractionPhase
function game:pushPhase(phase)
    self.interaction_stack:push(phase)
end

function game:popPhase(phase)
    if phase == nil then
        self.interaction_stack:pop()
    else
        self.interaction_stack:remove(phase)
    end
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

function game:newTurn()
    local clicks = 0
    local discard_amount = 0
    local max_hand = 0

    if self.current_side == nil or self.current_side == SIDE_RUNNER then
        -- corp next
        self.current_side = SIDE_CORP
        clicks = self.corp.max_clicks
        max_hand = self.corp.max_hand
    else
        -- runner next
        self.current_side = SIDE_RUNNER
        clicks = self.runner.max_clicks
        max_hand = self.runner.max_hand
    end


    -- @TODO: remove
    self.current_side = SIDE_CORP
    discard_amount = board:count(SLOT_CORP_HAND) - max_hand

    if discard_amount > 0 then
        self.interaction_stack:push(TurnEndPhase:New(self.current_side, discard_amount))
    end

    if self.current_side == SIDE_CORP then
        self.corp:newTurn()
        ui:focusCorp()
    else
        self.runner:newTurn()
        ui:focusRunner()
    end

    for _ = 0, clicks do
        self.interaction_stack:prepend(TurnBasePhase:New(self.current_side))
    end

    local slots = {
        "corp_remote_1",
        "corp_remote_2",
        "corp_remote_3",
        "corp_remote_4",
        "corp_remote_5",
        "corp_remote_6",
        "corp_hq",
    }

    for _, slot in pairs(slots) do
        for i = 0, board:count(slot) do
            local card = board:cardGet(slot, i)
            if card and card.faceup then
                if cardspec:onNewTurn(card.meta) then
                    board:cardPop(slot, card)
                end
            end
        end
    end

    self.turn_n = self.turn_n + 1
end

function game:onInit()
    info("Game init")
    self.corp = Corp:New()
    self.runner = Runner:New()
    self.runner:newTurn()

    self.corp:alterCredits(12)

    self.player_controllers[SIDE_CORP] = HumanController:New(SIDE_CORP)
    self.player_controllers[SIDE_RUNNER] = HumanController:New(SIDE_RUNNER)

    host:register(self.player_controllers[SIDE_CORP])

    self.interaction_stack = InteractionStack:New()

    if board:cardGet("corp_hq", 0) == nil then
        info("Dealing initial cards...");
        board:cardAppend("corp_hq", cardspec:card(1093))

        local deck = cardspec:deck([[
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

        board:cardAppend("corp_hand", cardspec:card(1064))
    end

    info("Game ready!")
    self:cycle()
end

function game:onTick(dt)
    if dt - self.last_ui_update > 1 then
        local text = ""
        for _, v in pairs(self.interaction_stack.stack) do
            text = string.format("%s\n%s [%s]", text, v.type, v.side)
        end

        alert_label:setText(text)
        self.last_ui_update = dt
    end
end

host:register(game)
