--- @class HCRunAccessComponent: HumanControllerComponent
--- @field decision RunAccessDecision
--- @field deck Deck
HCRunAccessComponent = class("HCRunAccessComponent", HumanControllerComponent)

function HCRunAccessComponent:onNewDecision()
    self.deck = self.decision:accessedCards()

    card_select_widget:setDeck(self.deck, -1)
    card_select_widget.hidden = false
end

function HCRunAccessComponent:onPrimary(card, slot)
    local intr = card.meta:interactionFromRunAccess()
    local should_remove
    if intr == CI_SCORE then
        should_remove = self.decision:score(card)
    elseif intr == CI_TRASH then
        should_remove = self.decision:trash(card)
    end

    if should_remove then
        self.deck:erase(card)
    end

    if self.deck.size <= 0 then
        card_select_widget.hidden = true
        return self.decision:handledTop()
    end
end

function HCRunAccessComponent:onCancel()
    card_select_widget.hidden = true
    return self.decision:handledTop()
end