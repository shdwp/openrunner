--- @class HCSelectFromSlotComponent: HumanControllerComponent
--- @field decision SelectFromSlotDecision
HCSelectFromSlotComponent = class("HCSelectFromSlotComponent", HumanControllerComponent)

function HCSelectFromSlotComponent:onPrimary(card, slot)
    if self.decision:selected(card, slot) then
        info("%s selected %d from %s", self.side.id, card.uid, slot)
        return true
    else
        info("%s selected %d from %s - invalid slot / forbidden by cardspec", self.side.id, card.uid, slot)
    end
end

function HCSelectFromSlotComponent:onCancel()
    info("%s attempt to cancel select from slot", self.side.id)
    return self.decision:cancelled()
end