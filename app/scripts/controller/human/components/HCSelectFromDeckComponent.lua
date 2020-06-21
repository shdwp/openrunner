--- @class HCSelectFromDeckComponent: HumanControllerComponent
--- @field decision SelectFromDeckDecision
HCSelectFromDeckComponent = class(HumanControllerComponent)

function HCSelectFromDeckComponent:onNewDecision()
    local deck = board:deckGet(self.decision.slot, 0)
    card_select_widget:setDeck(deck, self.decision.limit)
    card_select_widget.hidden = false
end

function HCSelectFromDeckComponent:onClick(card, slot)
    info("%s selected %d, %d left", self.side.id, card.uid, sel_ph.amount - 1)

    --- @type SelectFromDeckDecision
    local sel_ph = self.decision
    if sel_ph.cb(card) then
        sel_ph.amount = sel_ph.amount - 1
        card_select_widget:removeCard(card)
        deck:erase(card)

        if sel_ph.amount <= 0 then
            info("%s finished selecting cards", self.side.id)
            card_select_widget.hidden = true
            return self.decision:handled()
        end

        return true
    end
end

function HCSelectFromDeckComponent:onCancel()
    info("%s cancelled select from deck", self.side.id)
    card_select_widget.hidden = true
    return self.decision:handled()
end
