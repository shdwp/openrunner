--- @class RunIceApproachDecision: Decision
--- @field meta CardMeta
RunIceApproachDecision = class(Decision, { Type = "run_ice_approach"})

--- @param side string
--- @param meta CardMeta
--- @return RunIceApproachDecision
function RunIceApproachDecision:New(side, meta)
    return construct(self, Decision:New(self.Type, side), {
        meta = meta,
    })
end
