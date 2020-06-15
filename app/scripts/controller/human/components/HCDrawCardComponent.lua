--- @class HCDrawCardComponent: HumanControllerComponent
HCDrawCardComponent = class(HumanControllerComponent)

function HCDrawCardComponent:onClick(card, slot)
    self.side:actionDrawCard()
    return self:handled()
end
