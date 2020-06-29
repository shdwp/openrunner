--- @class HCGetCreditComponent: HumanControllerComponent
HCGetCreditComponent = class("HCGetCreditComponent", HumanControllerComponent)

function HCGetCreditComponent:onPrimary(card, slot)
    self.side.bank:credit(1)
    return self.decision:handledTop()
end