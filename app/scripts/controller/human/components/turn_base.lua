--- @class HumanControllerDrawCardComponent: HumanControllerComponent
HumanControllerDrawCardComponent = class(HumanControllerComponent)

--- @param descr SlotInteractable
function HumanControllerDrawCardComponent:onClick(card, slot)
    self.side:actionDrawCard()
    return true
end

function HumanControllerDrawCardComponent:onCancel()
    return false
end

