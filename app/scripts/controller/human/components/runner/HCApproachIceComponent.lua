--- @class HCApproachIceComponent: HumanControllerComponent
--- @field decision RunIceApproachDecision
HCApproachIceComponent = class("HCApproachIceComponent", HumanControllerComponent)

function HCApproachIceComponent:onPrimary(card, slot)
    if self.decision.meta == card.meta then
        return self.decision:handledTop()
    end
end

function HCApproachIceComponent:onCancel()
    return self.decision:handledUpTo(RunEndDecision.Type)
end
