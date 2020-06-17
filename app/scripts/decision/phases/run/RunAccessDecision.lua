--- @class RunAccessDecision: Decision
RunAccessDecision = class(Decision, { Type = "run_access"})

function RunAccessDecision:New(side, card)
    return construct(self, Decision:New(self.Type, side), {
        card = card
    })
end
