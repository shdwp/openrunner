--- @class HandDiscardDecision: Decision
HandDiscardDecision = class(Decision, {
    Type = "hand_discard_phase"
})

--- @param side string
--- @return HandDiscardDecision
function HandDiscardDecision:New(side)
    return construct(self, Decision:New(self.Type, side))
end
