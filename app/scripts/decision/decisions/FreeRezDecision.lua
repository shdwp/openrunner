--- @class FreeRezDecision: Decision
FreeRezDecision = class("FreeRezDecision", Decision, { Type = "free_rez"})

--- @param state GameState
--- @param side string
--- @param cb function returning bool
--- @return FreeRezDecision
function FreeRezDecision:New(state, side, cb)
    return construct(self, Decision:New(self.Type, state, side), {
        cb = cb and cb or function () return true end,
    })
end
