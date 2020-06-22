--- @class HCInstallCardComponent: HumanControllerComponent
HCInstallCardComponent = class("HCInstallCardComponent", HumanControllerComponent)

function HCInstallCardComponent:onPrimary(card, slot)
    local discount = 0
    if self.decision.type == DiscountedInstallDecision.Type then
        discount = self.decision.discount
    end

    if self.side:actionInstall(self.decision.card, self.decision.slot, slot, false, discount) then
        self.decision:handledTop(2)
        return true
    else
        info("%s failed to install card %d into %s", self.side.id, self.decision.card.uid, slot)
    end
end

function HCInstallCardComponent:onCancel()
    return self.decision:handledTop()
end