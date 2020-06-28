--- @class RunSubroutResolveDecision: Decision
--- @field descr string
--- @field fn fun()
--- @field meta CardMeta
RunSubroutResolveDecision = class("RunSubroutResolveDecision", Decision, { Type = "run_subrout_resolve" })

--- @param state GameState
--- @param side string
--- @param fn fun()
--- @param descr string
--- @param meta CardMeta
--- @return RunSubroutResolveDecision
function RunSubroutResolveDecision:New(state, side, fn, descr, meta)
    return construct(self, Decision:New(self.Type, state, side), {
        fn = fn,
        descr = descr,
        meta = meta,
    })
end

function RunSubroutResolveDecision:autoHandle()
    info("Resolving subroutine %s...", self.descr)
    self.meta:onSubroutineResolution(self.state, self.fn)
    self:handledSelf()
    return true
end