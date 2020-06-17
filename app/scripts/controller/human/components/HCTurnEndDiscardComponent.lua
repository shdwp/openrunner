--- @class HCTurnEndDiscardComponent: HumanControllerComponent
HCTurnEndDiscardComponent = class(HumanControllerComponent)

function HCTurnEndDiscardComponent:onClick(card, slot)
    self.side:actionDiscard(card, slot)
    info("%s discarded %d", self.side.id, card.uid)
    self.decision.amount = self.decision.amount - 1
    if self.decision.amount <= 0 then
        info("%s finished discarding cards", self.side.id)
        return self.decision:handledTop()
    end

    return true
end
