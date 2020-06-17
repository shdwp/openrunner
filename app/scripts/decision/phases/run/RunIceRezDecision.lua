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

    card.meta:iterSubroutines(function (descr, fn)
        local decision = RunSubroutResolveDecision:New(SIDE_RUNNER, fn)
        table.insert(resolve_decisions, decision)
        game.decision_stack:push(decision)
    end)

    card.meta:iterSubroutines(function (descr, fn)
        local resolve_decision = resolve_decisions[#resolve_decisions]
        game.decision_stack:push(RunSubroutBreakDecision:New(SIDE_RUNNER, card.meta, descr, resolve_decision))

        table.remove(resolve_decisions, #resolve_decisions)
    end)

    return self:handledTop()
end
