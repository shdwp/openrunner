--- @class TurnBaseDecision: Decision
TurnBaseDecision = class(Decision, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBaseDecision
function TurnBaseDecision:New(side)
    return construct(self, Decision:New(self.Type, side))
end

function TurnBaseDecision:initiateRun(card, slot)
    game.decision_stack:push(RunEndDecision:New(SIDE_RUNNER))
    game.decision_stack:push(RunAccessDecision:New(SIDE_RUNNER, slot))

    for c in cardsIter(iceSlotOfRemote(slot)) do
        game.decision_stack:push(RunIceRezDecision:New(SIDE_CORP, c.meta))
        game.decision_stack:push(RunIceApproachDecision:New(SIDE_RUNNER, c.meta))
    end

    return self:handledTop()
end

function TurnBaseDecision:install(side_id, card, slot)
    game.decision_stack:push(InstallDecision:New(side_id, slot, card))
    game:cycle()
    return true
end