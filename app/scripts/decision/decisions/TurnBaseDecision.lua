--- @class TurnBaseDecision: Decision
TurnBaseDecision = class("TurnBaseDecision", Decision, {
    Type = "turn_base"
})

--- @param state GameState
--- @param side string
--- @return TurnBaseDecision
function TurnBaseDecision:New(state, side)
    return construct(self, Decision:New(self.Type, state, side))
end

--- @param slot string
--- @param additional_amount number
function TurnBaseDecision:initiateRun(slot, additional_amount)
    TurnBaseDecision.InitiateRun(slot, additional_amount)
    return self:handledTop()
end

function TurnBaseDecision:install(side_id, card, slot)
    self.state.stack:push(InstallDecision:New(self.state, side_id, slot, card))
    self.state:cycle()
    return true
end

--- @param state GameState
--- @param slot string
--- @param additional_amount number
function TurnBaseDecision.InitiateRun(state, slot, additional_amount)
    amount = amount or -1

    state.runner:onRunStart()

    state.stack:push(RunEndDecision:New(state, SIDE_RUNNER))
    state.stack:push(RunAccessDecision:New(state, SIDE_RUNNER, slot, additional_amount))

    for c in state.board:cardsIter(iceSlotOfRemote(slot)) do
        state.stack:push(RunIceRezDecision:New(state, SIDE_CORP, c.meta))
        state.stack:push(RunIceApproachDecision:New(state, SIDE_RUNNER, c.meta))
    end
end