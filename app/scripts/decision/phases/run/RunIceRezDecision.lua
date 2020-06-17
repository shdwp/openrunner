--- @class RunIceRezDecision: Decision
--- @field card Card
RunIceRezDecision = class(Decision, { Type = "run_ice_rez"})

--- @param side string
--- @param card Card
--- @return RunIceRezDecision
function RunIceRezDecision:New(side, card)
    return construct(self, Decision:New(self.Type, side), {
        card = card,
    })
end
