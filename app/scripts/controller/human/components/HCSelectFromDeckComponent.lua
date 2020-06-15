--- @class HCSelectFromDeckComponent: HumanControllerComponent
HCSelectFromDeckComponent = class(HumanControllerComponent)

function HCSelectFromDeckComponent:onClick(card, slot)
    info("%s selected %d, %d left", self.side.id, descr.card.uid, sel_ph.amount - 1)

    --- @type SelectFromDeckPhase
    local sel_ph = self.phase
    if sel_ph.cb(card) then
        sel_ph.amount = sel_ph.amount - 1
        card_select_widget:removeCard(card)
        deck:erase(card)

        if sel_ph.amount <= 0 then
            info("%s finished selecting cards", self.side.id)
            card_select_widget.hidden = true
            return self:handled()
        end

        return true
    end
end

function HCSelectFromDeckComponent:onCancel()
    info("%s cancelled select from deck", self.side.id)
    card_select_widget.hidden = true
    return self:handled()
end
