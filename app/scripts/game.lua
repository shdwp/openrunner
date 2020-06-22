--- @class game
--- @field decision_stack DecisionStack
--- @field current_side string
--- @field corp Corp
--- @field runner Runner
--- @field player_controllers table<number, PlayerController>
game = {
    turn_n = 1,
    player_controllers = {},

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
    if game.decision_stack:empty() then
        game:newTurn()
    end

    for _, c in pairs(self.player_controllers) do
        c:clear()
    end

    local decision = self.decision_stack:top()
    if self.current_side ~= decision.side.id then
        self.current_side = decision.side.id
        ui:focusCurrentPlayer()
    end

    if decision:autoHandle() then
        return
    end

    local ctrl = self:controllerFor(decision.side.id)
    ctrl:handle(decision)
end

--- @param side string
--- @param amount number
--- @return boolean
function game:alterClicks(side, amount)
    if amount >= 0 then
        self.decision_stack:addClicks(side, amount)
        return true
    elseif amount < 0 then
        return self.decision_stack:removeClicks(side, amount)
    end
end

function game:newTurn()
    local clicks = 0
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
    self.current_side = SIDE_RUNNER

    -- call newTurn for appropriate side
    if self.current_side == SIDE_CORP then
        self.corp:newTurn()
    else
        self.runner:newTurn()
    end

    -- construct decision stack for new player
    self.decision_stack:push(HandDiscardDecision:New(self.current_side))
    for _ = 0, clicks do
        self.decision_stack:push(TurnBaseDecision:New(self.current_side))
    end

    -- call onNewTurn on rezzed cards
    for card in self:boardCardsIter() do
        if card.meta.rezzed then
            if card.meta:onNewTurn() then
                board:cardPop(slot, card)
            end
        end
    end

    self.turn_n = self.turn_n + 1

    -- process UI
    ui:focusCurrentPlayer()
end

--- @return fun(): Card
function game:boardCardsIter()
    local slots = {
        remoteSlot(1),
        remoteSlot(2),
        remoteSlot(3),
        remoteSlot(4),
        remoteSlot(5),
        remoteSlot(6),
        remoteIceSlot(1),
        remoteIceSlot(2),
        remoteIceSlot(3),
        remoteIceSlot(4),
        remoteIceSlot(5),
        remoteIceSlot(6),
        SLOT_CORP_HQ,
        SLOT_RUNNER_PROGRAMS,
        SLOT_RUNNER_HARDWARE,
        SLOT_RUNNER_RESOURCES,
        SLOT_RUNNER_CONSOLE,
    }

    local cards = {}

    for _, slot in pairs(slots) do
        for i = 0, board:count(slot) do
            local card = board:cardGet(slot, i)
            if card then
                table.insert(cards, card)
            end
        end
    end

    local i = 0

    return function ()
        i = i + 1
        if i > #cards then
            return nil
        else
            return cards[i]
        end
    end
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
    host:register(self.player_controllers[SIDE_RUNNER])

    self.decision_stack = DecisionStack:New()

    if board:cardGet("corp_hq", 0) == nil then
        info("Dealing initial cards...");
        board:cardAppend("corp_hq", Db:card(1093))

        local deck = Db:deck([[
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

        board:cardAppend("runner_id", Db:card(1033))

        deck = Db:deck([[
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

        deck:shuffle()

        board:deckAppend(SLOT_RUNNER_STACK, deck)

        board:cardAppend(remoteSlot(1), Db:card(1094))
        board:cardAppend(remoteIceSlot(1), Db:card(1101))
        board:cardAppend(remoteIceSlot(1), Db:card(1111))
        ui:cardInstalled(nil, remoteIceSlot(1))

        board:cardAppend(SLOT_RUNNER_PROGRAMS, Db:card(1043))
        board:cardAppend(SLOT_RUNNER_PROGRAMS, Db:card(1027))
        board:cardAppend(SLOT_RUNNER_PROGRAMS, Db:card(1051))
        ui:cardInstalled(nil, SLOT_RUNNER_PROGRAMS)

        board:cardAppend(SLOT_CORP_HAND, Db:card(1094))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card(1039))
        board:cardAppend(SLOT_RUNNER_HAND, Db:card(1005))
    end

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
