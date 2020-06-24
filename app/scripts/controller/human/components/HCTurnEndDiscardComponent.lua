--- @class HCTurnEndDiscardComponent: HumanControllerComponent
--- @field decision HandDiscardDecision
HCTurnEndDiscardComponent = class("HCTurnEndDiscardComponent", HumanControllerComponent)

function HCTurnEndDiscardComponent:onPrimary(card, slot)
    self.side:discard(card)
    self.decision:discardedCard(card)

    return true
end
