--- @class RunIceRezDecision: Decision
--- @field meta CardMeta
RunIceRezDecision = class("RunIceRezDecision", Decision, { Type = "run_ice_rez"})

--- @param side string
--- @param meta CardMeta
--- @return RunIceRezDecision
function RunIceRezDecision:New(side, meta)
    return construct(self, Decision:New(self.Type, side), {
        meta = meta,
    })
end

function RunIceRezDecision:autoHandle()
    if self.meta.rezzed == true then
        return self:iceRezzed()
    end
end

function RunIceRezDecision:iceRezzed()
    local resolve_decisions = {}

    for descr, fn in self.meta:subroutinesReversedIter() do
        local decision = RunSubroutResolveDecision:New(SIDE_RUNNER, fn, descr)
        table.insert(resolve_decisions, 1, decision)
        game.decision_stack:push(decision)
    end

    for descr, _ in self.meta:subroutinesReversedIter() do
        local resolve_decision = resolve_decisions[#resolve_decisions]
        game.decision_stack:push(RunSubroutBreakDecision:New(SIDE_RUNNER, self.meta, descr, resolve_decision))
        table.remove(resolve_decisions, #resolve_decisions)
    end

    return self:handledTop()
end
