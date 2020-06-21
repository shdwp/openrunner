--- @class HCRunAccessComponent: HumanControllerComponent
--- @field decision RunAccessDecision
--- @field deck Deck
HCRunAccessComponent = class("HCRunAccessComponent", HumanControllerComponent)

function HCRunAccessComponent:onNewDecision()
    local deck = Deck()
    for card in self.decision:accessedCardsIter() do
        card.faceup = true
        deck:append(card)
    end

    card_select_widget:setDeck(deck, -1)
    card_select_widget.hidden = false
    self.deck = deck
end

function HCRunAccessComponent:onPrimary(card, slot)
    if self.deck.size <= 0 then
        card_select_widget.hidden = true
        return self.decision:handledTop()
    end
end

function HCRunAccessComponent:onCancel()
    card_select_widget.hidden = true
    return self.decision:handledTop()
end