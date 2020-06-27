--- @class TurnBaseDecision: Decision
TurnBaseDecision = class("TurnBaseDecision", Decision, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBaseDecision
function TurnBaseDecision:New(side)
    return construct(self, Decision:New(self.Type, side))
end

--- @param slot string
--- @param additional_amount number
function TurnBaseDecision:initiateRun(slot, additional_amount)
    TurnBaseDecision.InitiateRun(slot, additional_amount)
    return self:handledTop()
end

function TurnBaseDecision:install(side_id, card, slot)
    game.decision_stack:push(InstallDecision:New(side_id, slot, card))
    game:cycle()
    return true
end

--- @param slot string
--- @param additional_amount number
function TurnBaseDecision.InitiateRun(slot, additional_amount)
    amount = amount or -1

    game.runner:onRunStart()

    game.decision_stack:push(RunEndDecision:New(SIDE_RUNNER))
    game.decision_stack:push(RunAccessDecision:New(SIDE_RUNNER, slot, additional_amount))

    for c in cardsIter(iceSlotOfRemote(slot)) do
        game.decision_stack:push(RunIceRezDecision:New(SIDE_CORP, c.meta))
        game.decision_stack:push(RunIceApproachDecision:New(SIDE_RUNNER, c.meta))
    end
end