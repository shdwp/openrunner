--- @class RunIceApproachDecision: Decision
--- @field meta CardMeta
RunIceApproachDecision = class("RunIceApproachDecision", Decision, { Type = "run_ice_approach"})

--- @param side string
--- @param meta CardMeta
--- @return RunIceApproachDecision
function RunIceApproachDecision:New(side, meta)
    return construct(self, Decision:New(self.Type, side), {
        meta = meta,
    })
end

function RunIceApproachDecision:autoHandle()
    for card in game:boardCardsIter() do
        card.meta:onIceEncounterEnd()
    end

    return false
end
