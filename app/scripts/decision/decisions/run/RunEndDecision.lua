--- @class RunEndDecision: Decision
RunEndDecision = class("RunEndDecision", Decision, { Type = "run_end"})

--- @param state GameState
--- @param side_id string
--- @return RunEndDecision
function RunEndDecision:New(state, side_id)
    return construct(self, Decision:New(self.Type, state, side_id))
end

function RunEndDecision:autoHandle()
    self.state.runner:onRunEnd()

    for card in self.state:boardCardsIter() do
        card.meta:onEncounterEnd(self.state, card)
        card.meta:onRunEnd(self.state, card)
    end

    return self:handledTop()
end

