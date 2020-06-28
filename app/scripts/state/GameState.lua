--- @class GameState
--- @field current_side string
--- @field prompt_factory PromptFactory
--- @field board IGameBoardView
--- @field stack DecisionStack
--- @field corp Corp
--- @field runner Runner
GameState = class("GameState")

--- @param board IGameBoardView
function GameState:New(board)
    local t = construct(self, {
        turn_n = 1,
    
        last_run_turn_n = 0,
        last_successfull_run_turn_n = 0,
        last_agenda_scored_turn_n = 0,
        
        board = board,
        stack = DecisionStack:New(),
    })
    
    t.factory = PromptFactory:New(t)
    t.corp = Corp:New(t)
    t.runner = Runner:New(t)
    
    return t
end

function GameState:sideObject(id)
    if id == SIDE_CORP then
        return self.corp
    else
        return self.runner
    end
end

function GameState:cycle()
    -- @TODO: ref
end

--- @param side string
--- @param amount number
--- @return boolean
function GameState:alterClicks(side, amount)
    if amount >= 0 then
        self.stack:addClicks(side, amount)
        return true
    elseif amount < 0 then
        return self.stack:removeClicks(side, amount)
    end
end

function GameState:endInFavor(side_id)

end

function GameState:newTurn()
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
    self.stack:push(HandDiscardDecision:New(self, self.current_side))
    for _ = 1, clicks do
        self.stack:push(TurnBaseDecision:New(self, self.current_side))
    end
    
    -- call onNewTurn on rezzed cards
    for card in self.board:boardCardsIter() do
        if card.meta.rezzed then
            card.meta:onNewTurn(card)
        end
    end
    
    self.turn_n = self.turn_n + 1
    
    for _, c in pairs(self.player_controllers) do
        c:newTurn(self.current_side)
    end
end

--- @return fun(): Card
function GameState:boardCardsIter()
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
        for i = 0, self.board:count(slot) do
            local card = self.board:card(slot, i)
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


function GameState:save()
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
    host.meta.current_clicks = self.stack:countClicks(self.current_side)
end

function GameState:load()
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
    
    self.stack:push(HandDiscardDecision:New(self.current_side))
    for _ = 1, host.meta.current_clicks do
        self.stack:push(TurnBaseDecision:New(self.current_side))
    end
end

