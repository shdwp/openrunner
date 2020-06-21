--- @class RunIceRezDecision: Decision
--- @field meta CardMeta
RunIceRezDecision = class(Decision, { Type = "run_ice_rez"})

--- @param side string
--- @param meta CardMeta
--- @return RunIceRezDecision
function RunIceRezDecision:New(side, meta)
    return construct(self, Decision:New(self.Type, side), {
        meta = meta,
    })
end

--- @param card Card
--- @param slot string
function RunIceRezDecision:iceRezzed(card, slot)
    local resolve_decisions = {}

    for descr, fn in card.meta:subroutinesReversedIter() do
        local decision = RunSubroutResolveDecision:New(SIDE_RUNNER, fn, descr)
        table.insert(resolve_decisions, 1, decision)
        game.decision_stack:push(decision)
    end

    for descr, _ in card.meta:subroutinesReversedIter() do
        local resolve_decision = resolve_decisions[#resolve_decisions]
        game.decision_stack:push(RunSubroutBreakDecision:New(SIDE_RUNNER, card.meta, descr, resolve_decision))
        table.remove(resolve_decisions, #resolve_decisions)
    end

    return self:handledTop()
end
