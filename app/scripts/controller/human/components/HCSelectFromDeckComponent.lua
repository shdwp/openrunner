--- @class HCSelectFromDeckComponent: HumanControllerComponent
--- @field decision SelectFromDeckDecision
HCSelectFromDeckComponent = class("HCSelectFromDeckComponent", HumanControllerComponent)

function HCSelectFromDeckComponent:onNewDecision()
    card_select_widget:setDeck(self.decision.deck, self.decision.limit)
    card_select_widget.hidden = false
end

function HCSelectFromDeckComponent:onPrimary(card, slot)
    info("%s selected %d", self.side.id, card.uid)
    local result = self.decision:selected(card)
    if result == "done" then
        card_select_widget.hidden = true
        card_select_widget:setDeck(nil, 0)
        return true
    elseif result == "progress" then
        card_select_widget:removeCard(card)
    else
        return false
    end

    return true
end

function HCSelectFromDeckComponent:onCancel()
    info("%s cancelled select from deck", self.side.id)
    card_select_widget.hidden = true
    card_select_widget:setDeck(nil, 0)
    return self.decision:cancelled()
end
