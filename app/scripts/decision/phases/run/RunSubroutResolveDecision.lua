--- @class RunSubroutResolveDecision: Decision
--- @field fn function
RunSubroutResolveDecision = class(Decision, { Type = "run_subrout_resolve" })

function RunSubroutResolveDecision:New(side, fn)
    return construct(self, Decision:New(self.Type, side), {
        fn = fn
    })
end