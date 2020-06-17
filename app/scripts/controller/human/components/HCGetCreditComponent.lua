--- @class HCGetCreditComponent: HumanControllerComponent
HCGetCreditComponent = class(HumanControllerComponent)

function HCGetCreditComponent:onClick(card, slot)
    self.side:alterCredits(1)
    return self:handled()
end