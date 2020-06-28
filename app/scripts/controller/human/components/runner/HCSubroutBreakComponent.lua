--- @class HCSubroutBreakComponent: HumanControllerComponent
--- @field decision RunSubroutBreakDecision
HCSubroutBreakComponent = class("HCSubroutBreakComponent", HumanControllerComponent)

function HCSubroutBreakComponent:onPrimary(card, slot)
    if game.runner:actionBreakIce(card, card.meta, self.decision.meta) then
        info("Runner broke ice %s subrout %s with %s", self.decision.meta, self.decision.description, card)
        return self.decision:subroutineBroken()
    else
        info("Runner failed to brake ice %s subrout %s with %s", self.decision.meta, self.decision.description, card)
    end

        return false
    end

function HCSubroutBreakComponent:onSecondary(card, slot)
    if card.meta:canPowerUp() then
        return card.meta:onPowerUp(self.state, card)
    else
        info("Failed to handle alt click: no available action on card %d", card.uid)
        return false
    end
end

function HCSubroutBreakComponent:onCancel()
    return self.decision:handledTop()
end
