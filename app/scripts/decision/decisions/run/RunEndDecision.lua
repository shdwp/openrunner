--- @class RunEndDecision: Decision
RunEndDecision = class("RunEndDecision", Decision, { Type = "run_end"})

--- @param side_id string
--- @return RunEndDecision
function RunEndDecision:New(side_id)
    return construct(self, Decision:New(self.Type, side_id))
end

function RunEndDecision:autoHandle()
    for card in game:boardCardsIter() do
        card.meta:onEncounterEnd(card)
        card.meta:onRunEnd(card)
    end

    return self:handledTop()
end

