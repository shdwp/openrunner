--- @class TurnBaseDecision: Decision
TurnBaseDecision = class(Decision, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBaseDecision
function TurnBaseDecision:New(side)
    return construct(self, Decision:New(self.Type, side))
end
