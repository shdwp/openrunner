--- @class FreeAdvanceDecision: Decision
--- @field card Card
--- @field slot string
FreeAdvanceDecision = class("FreeAdvanceDecision", Decision, { Type = "free_advance"})

--- @param state GameState
--- @param side string
--- @param cb function returning bool
--- @return FreeAdvanceDecision
function FreeAdvanceDecision:New(state, side, cb)
    return construct(self, Decision:New(self.Type, state, side), {
        cb = cb and cb or function () return true end,
    })
end
