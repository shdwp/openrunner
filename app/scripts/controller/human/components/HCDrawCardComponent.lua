--- @class HCDrawCardComponent: HumanControllerComponent
HCDrawCardComponent = class("HCDrawCardComponent", HumanControllerComponent)

function HCDrawCardComponent:onPrimary(card, slot)
    self.side:actionDrawCard()
    return self.decision:handledTop()
end
