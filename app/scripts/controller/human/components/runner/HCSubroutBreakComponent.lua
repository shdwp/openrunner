--- @class HCSubroutBreakComponent: HumanControllerComponent
--- @field decision RunSubroutBreakDecision
HCSubroutBreakComponent = class(HumanControllerComponent)

function HCSubroutBreakComponent:onClick(card, slot)
    if game.runner:actionBreakIce(card.meta, self.decision.meta) then
        info("Runner broke ice %s subrout %s with %s", self.decision.meta, self.decision.description, card)
        return self.decision:subroutineBroken()
    else
        info("Runner failed to brake ice %s subrout %s with %s", self.decision.meta, self.decision.description, card)
    end

        return false
    end

function HCSubroutBreakComponent:onAltClick(card, slot)
    if card.meta:canAction() then
        return card.meta:onAction()
    else
        info("Failed to handle alt click: no available action on card %d", card.uid)
        return false
    end
end

function HCSubroutBreakComponent:onCancel()
    return self.decision:handledTop()
end
