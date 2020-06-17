--- @class HCInitiateRunComponent: HumanControllerComponent
--- @field decision TurnBaseDecision
HCInitiateRunComponent = class(HumanControllerComponent)

function HCInitiateRunComponent:onClick(card, slot)
    self.decision:initiateRun(card, slot)
    return true
end

