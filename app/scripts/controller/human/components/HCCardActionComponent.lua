--- @class HCCardActionComponent: HumanControllerComponent
--- @field decision TurnBaseDecision
HCCardActionComponent = class("HCCardActionComponent", HumanControllerComponent)

function HCCardActionComponent:onTertiary(card, slot)
    if card.meta:onAction(card) then
        return self.decision:handledTop()
    end
end