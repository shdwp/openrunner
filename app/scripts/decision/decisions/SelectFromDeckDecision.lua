--- @class SelectFromDeckDecision: Decision
--- @field deck Deck
--- @field limit number
--- @field amount number
--- @field cb function
SelectFromDeckDecision = class("SelectFromDeckDecision", Decision, { Type = "deck_select"})

--- @param state GameState
--- @param side string
--- @param limit number limit query to first N cards
--- @param amount number amount of cards to pick
--- @param cb fun(card: Card): boolean
--- @return SelectFromDeckDecision
function SelectFromDeckDecision:New(state, side, deck, limit, amount, cb)
    return construct(self, Decision:New(self.Type, state, side), {
        deck = deck,
        limit = limit,
        amount = amount,
        cb = cb
    })
end

--- @param card Card
--- @return string
function SelectFromDeckDecision:selected(card)
    if self.cb(card) then
        self.deck:erase(card)

        self.amount = self.amount - 1
        if self.amount <= 0 then
            self.deck:shuffle()
            self:handledTop()
            return "done"
        else
            return "progress"
        end
    end
end

--- @return boolean
function SelectFromDeckDecision:cancelled()
    self.deck:shuffle()
    return self:handledTop()
end
