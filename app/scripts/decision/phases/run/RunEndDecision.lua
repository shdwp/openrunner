--- @class RunEndDecision: Decision
RunEndDecision = class(Decision, { Type = "run_end"})

--- @param side_id string
--- @return RunEndDecision
function RunEndDecision:New(side_id)
    return construct(self, Decision:New(self.Type, side_id))
end
