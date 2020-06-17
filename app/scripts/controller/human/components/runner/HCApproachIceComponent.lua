--- @class HCApproachIceComponent: HumanControllerComponent
HCApproachIceComponent = class(HumanControllerComponent)

function HCApproachIceComponent:onClick(card, slot)
    print(self.phase.card)
    print(card)

    if self.phase.card == card then
        return self:handled()
    end
end

function HCApproachIceComponent:onCancel()
    return self:handledTo(RunAccessDecision.Type)
end
