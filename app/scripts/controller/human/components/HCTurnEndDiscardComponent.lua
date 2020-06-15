--- @class HCTurnEndDiscardComponent: HumanControllerComponent
HCTurnEndDiscardComponent = class(HumanControllerComponent)

function HCTurnEndDiscardComponent:onClick(card, slot)
    self.side:actionDiscard(card, slot)
    info("%s discarded %d", self.side.id, card.uid)
    self.phase.amount = self.phase.amount - 1
    if self.phase.amount <= 0 then
        info("%s finished discarding cards", self.side.id)
        return self:handled()
    end

    return true
end
