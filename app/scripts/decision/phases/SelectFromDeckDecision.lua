--- @class SelectFromDeckDecision: Decision
--- @field slot string
--- @field limit number
--- @field amount number
--- @field cb function
SelectFromDeckDecision = class(Decision, { Type = "deck_select"})

--- @param side string
--- @param slot string slot of the deck
--- @param limit number limit query to first N cards
--- @param amount number amount of cards to pick
--- @param cb function callback
--- @return SelectFromDeckDecision
function SelectFromDeckDecision:New(side, slot, limit, amount, cb)
    return construct(self, Decision:New(self.Type, side), {
        slot = slot,
        limit = limit,
        amount = amount,
        cb = cb
    })
end
