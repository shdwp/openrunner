--- @class SelectFromSlotDecision: Decision
--- @field slot string
--- @field amount number
--- @field cb function
SelectFromSlotDecision = class(Decision, { Type = "select_from_slot"})

--- @param side string
--- @param slot string
--- @param amount number
--- @param cb function
function SelectFromSlotDecision:New(side, slot, amount, cb)
    return construct(self, Decision:New(self.Type, side), {
        slot = slot,
        amount = amount,
        cb = cb,
    })
end
