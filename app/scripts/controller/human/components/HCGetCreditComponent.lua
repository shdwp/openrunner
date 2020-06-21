--- @class HCGetCreditComponent: HumanControllerComponent
HCGetCreditComponent = class("HCGetCreditComponent", HumanControllerComponent)

function HCGetCreditComponent:onPrimary(card, slot)
    self.side:alterCredits(1)
    return self.decision:handledTop()
end