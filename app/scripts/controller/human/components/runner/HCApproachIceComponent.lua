--- @class HCApproachIceComponent: HumanControllerComponent
HCApproachIceComponent = class(HumanControllerComponent)

function HCApproachIceComponent:onClick(card, slot)
    if self.decision.meta == card.meta then
        return self.decision:handledTop()
    end
end

function HCApproachIceComponent:onCancel()
    return self.decision:handledUpTo(RunEndDecision.Type)
end
