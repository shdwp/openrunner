--- @class HCInitiateRunComponent: HumanControllerComponent
--- @field decision TurnBaseDecision
HCInitiateRunComponent = class("HCInitiateRunComponent", HumanControllerComponent)

function HCInitiateRunComponent:onPrimary(card, slot)
    self.decision:initiateRun(slot)
    return true
end

