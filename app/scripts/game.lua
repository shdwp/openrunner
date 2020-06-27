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

    if decision.type == TurnBaseDecision.Type then
        self:save()
    end

    local ctrl = self:controllerFor(decision.side.id)
    ctrl:handle(decision)
end

function game:endInFavor(side_id)
    game.decision_stack:push(GameEndDecision:New(side_id))
    game.decision_stack:pop()
    game:cycle()
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
    self.current_side = SIDE_CORP

    -- call newTurn for appropriate side
    if self.current_side == SIDE_CORP then
        self.corp:newTurn()
    else
        self.runner:newTurn()
    end

    -- construct decision stack for new player
    self.decision_stack:push(HandDiscardDecision:New(self.current_side))
    for _ = 1, clicks do
        self.decision_stack:push(TurnBaseDecision:New(self.current_side))
    end

    -- call onNewTurn on rezzed cards
    for card in self:boardCardsIter() do
        if card.meta.rezzed then
            card.meta:onNewTurn(card)
        end
    end

    self.turn_n = self.turn_n + 1

    for _, c in pairs(self.player_controllers) do
        c:newTurn(self.current_side)
    end

    -- process UI
    ui:focusCurrentPlayer()
end

function game:save()
    local f = function (side)
        return {
            id = side.id,
            max_clicks = side.max_clicks,
            max_hand = side.max_hand,
            score = side.score,
            credits = side.credits,
        }
    end

    host.meta.corp = f(self.corp)
    host.meta.corp.bad_publicity = self.corp.bad_publicity

    host.meta.runner = f(self.runner)
    host.meta.runner.tags = self.runner.tags
    host.meta.runner.memory = self.runner.memory
    host.meta.runner.link = self.runner.link

    host.meta.current_side = self.current_side
    host.meta.current_clicks = self.decision_stack:countClicks(self.current_side)
end

function game:load()
    local f = function (t, s)
        t.id = s.id
        t.max_clicks = s.max_clicks
        t.max_hand = s.max_hand
        t.score = s.score
        t.credits = s.credits
        t.bad_publicity = s.bad_publicity
    end

    f(self.corp, host.meta.corp)
    f(self.runner, host.meta.runner)

    self.corp.bad_publicity = host.meta.corp.bad_publicity

    self.runner.tags = host.meta.runner.tags
    self.runner.memory = host.meta.runner.memory
    self.runner.link = host.meta.runner.link

    self.current_side = host.meta.current_side

    self.decision_stack:push(HandDiscardDecision:New(self.current_side))
    for _ = 1, host.meta.current_clicks do
        self.decision_stack:push(TurnBaseDecision:New(self.current_side))
    end
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

    self.player_controllers[SIDE_CORP] = AIController:New(SIDE_CORP)
    self.player_controllers[SIDE_RUNNER] = HumanController:New(SIDE_RUNNER)

    host:register(self.player_controllers[SIDE_CORP])
    host:register(self.player_controllers[SIDE_RUNNER])

    self.decision_stack = DecisionStack:New()

    if board:cardGet("corp_hq", 0) == nil then
        info("Dealing initial cards...");

        -- CORP
        board:cardAppend(SLOT_CORP_HQ, Db:card(1093))
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
3 Shadow
]]
        )
        rnd_deck:shuffle()
        board:deckAppend(SLOT_CORP_RND, rnd_deck)
        board:deckAppend(SLOT_CORP_ARCHIVES, Deck())

        -- RUNNER
        board:cardAppend(SLOT_RUNNER_ID, Db:card(1033))
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
