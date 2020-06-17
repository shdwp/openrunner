--- @class RunIceApproachDecision: Decision
--- @field card Card
RunIceApproachDecision = class(Decision, { Type = "run_ice_approach"})

--- @param side string
--- @param card Card
--- @return RunIceApproachDecision
function RunIceApproachDecision:New(side, card)
    return construct(self, Decision:New(self.Type, side), {
        card = card,
    })
end
