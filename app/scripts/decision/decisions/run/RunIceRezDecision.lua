--- @class RunIceRezDecision: Decision
--- @field meta CardMeta
RunIceRezDecision = class("RunIceRezDecision", Decision, { Type = "run_ice_rez"})

--- @param state GameState
--- @param side string
--- @param meta CardMeta
--- @return RunIceRezDecision
function RunIceRezDecision:New(state, side, meta)
    return construct(self, Decision:New(self.Type, state, side), {
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
        local decision = RunSubroutResolveDecision:New(self.state, SIDE_RUNNER, fn, descr, self.meta)
        table.insert(resolve_decisions, 1, decision)
        self.state.stack:push(decision)
    end

    for descr, _ in self.meta:subroutinesReversedIter() do
        local resolve_decision = resolve_decisions[#resolve_decisions]
        self.state.stack:push(RunSubroutBreakDecision:New(self.state, SIDE_RUNNER, self.meta, descr, resolve_decision))
        table.remove(resolve_decisions, #resolve_decisions)
    end

    return self:handledTop()
end
