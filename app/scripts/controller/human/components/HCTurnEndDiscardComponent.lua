--- @class HCTurnEndDiscardComponent: HumanControllerComponent
--- @field decision HandDiscardDecision
HCTurnEndDiscardComponent = class(HumanControllerComponent)

function HCTurnEndDiscardComponent:onClick(card, slot)
    self.side:actionDiscard(card, slot)
    self.decision:discardedCard(card)

    return true
end
