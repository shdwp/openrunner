--- @class HCInstallCardComponent: HumanControllerComponent
HCInstallCardComponent = class(HumanControllerComponent)

function HCInstallCardComponent:onClick(card, slot)
    if self.side:actionInstall(self.phase.card, self.phase.slot, slot) then
        return self:handled(2)
    else
        info("%s failed to install card %d into %s", self.side.id, self.phase.card.uid, slot)
    end
end

function HCInstallCardComponent:onCancel()
    return self:handled()
end