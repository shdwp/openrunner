--- @class RunSubroutResolveDecision: Decision
--- @field descr string
--- @field fn fun()
RunSubroutResolveDecision = class(Decision, { Type = "run_subrout_resolve" })

function RunSubroutResolveDecision:New(side, fn, descr)
    return construct(self, Decision:New(self.Type, side), {
        fn = fn,
        descr = descr,
    })
end

function RunSubroutResolveDecision:autoHandle()
    info("Resolving subroutine %s...", self.descr)
    self.fn()
    self:handledSelf()
    return true
end