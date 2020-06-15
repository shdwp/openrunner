--- @class HCAdvanceCardComponent: HumanControllerComponent
HCAdvanceCardComponent = class(HumanControllerComponent)

function HCAdvanceCardComponent:onAltClick(card, slot)
    if game.corp:actionAdvance(card, slot, false) then
        info("Corp advanced %d from %s", card.uid, slot)
        return self:handled()
    end
end