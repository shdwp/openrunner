--- @class FreeRezDecision: Decision
FreeRezDecision = class(Decision, { Type = "free_rez"})

--- @param side string
--- @param cb function returning bool
--- @return FreeRezDecision
function FreeRezDecision:New(side, cb)
    return construct(self, Decision:New(self.Type, side), {
        cb = cb and cb or function () return true end,
    })
end
