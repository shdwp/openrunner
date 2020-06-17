--- @class RunSubroutineConfrontationDecision: Decision
--- @field card Card
RunSubroutineConfrontationDecision = class(Decision, { Type = "run_ice_confrontation"})

--- @param side string
--- @param card Card
--- @return RunSubroutineConfrontationDecision
function RunSubroutineConfrontationDecision:New(side, card)
    return construct(self, Decision:New(self.Type, side), {
        card = card,
    })
end
