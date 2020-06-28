--- @class RunSubroutBreakDecision: Decision
--- @field meta CardMeta
--- @field description string
--- @field resolve_decision RunSubroutResolveDecision
RunSubroutBreakDecision = class("RunSubroutBreakDecision", Decision, { Type = "run_subrout_break"})

--- @param state GameState
--- @param side string
--- @param meta CardMeta
--- @param description string
--- @param resolve_decision RunSubroutResolveDecision
--- @return RunSubroutBreakDecision
function RunSubroutBreakDecision:New(state, side, meta, description, resolve_decision)
    return construct(self, Decision:New(self.Type, state, side), {
        meta = meta,
        description = description,
        resolve_decision = resolve_decision,
    })
end

function RunSubroutBreakDecision:subroutineBroken()
    info("Removing decision for subroutine %s", self.resolve_decision.descr)
    self:handledSpecific(self.resolve_decision)
    return self:handledTop()
end