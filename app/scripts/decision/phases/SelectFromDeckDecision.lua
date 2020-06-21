--- @class SelectFromDeckDecision: Decision
--- @field slot string
--- @field deck Deck
--- @field limit number
--- @field amount number
--- @field cb function
SelectFromDeckDecision = class("SelectFromDeckDecision", Decision, { Type = "deck_select"})

--- @param side string
--- @param slot string slot of the deck
--- @param limit number limit query to first N cards
--- @param amount number amount of cards to pick
--- @param cb function callback
--- @return SelectFromDeckDecision
function SelectFromDeckDecision:New(side, slot, limit, amount, cb)
    return construct(self, Decision:New(self.Type, side), {
        slot = slot,
        deck = board:deckGet(slot, 0),
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
