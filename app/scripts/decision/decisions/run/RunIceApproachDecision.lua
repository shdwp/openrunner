--- @class RunIceApproachDecision: Decision
--- @field meta CardMeta
RunIceApproachDecision = class("RunIceApproachDecision", Decision, { Type = "run_ice_approach"})

--- @param state GameState
--- @param side string
--- @param meta CardMeta
--- @return RunIceApproachDecision
function RunIceApproachDecision:New(state, side, meta)
    return construct(self, Decision:New(self.Type, state, side), {
        meta = meta,
    })
end

function RunIceApproachDecision:autoHandle()
    for card in self.state:boardCardsIter() do
        card.meta:onEncounterEnd(self.state)
    end

    return false
end
