--- @class HCInstallCardComponent: HumanControllerComponent
HCInstallCardComponent = class(HumanControllerComponent)

function HCInstallCardComponent:onClick(card, slot)
    if cardspec:canInstallTo(self.phase.card.meta, slot) then
        local handled = false
        if cardspec:isCardRemote(self.phase.card.meta) then
            handled = game.corp:actionInstallRemote(self.phase.card, self.phase.slot, slot)
        else
            handled = game.corp:actionInstallIce(self.phase.card, self.phase.slot, slot)
        end

        if handled then
            return self:handled(2)
        else
            info("Corp failed to install card %d into %s", self.phase.card.uid, slot)
        end
    else
        info("Invalid slot for install %s", descr.slot)
    end
end

function HCInstallCardComponent:onCancel()
    return self:handled()
end