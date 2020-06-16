--- @class HCRezCardComponent: HumanControllerComponent
HCRezCardComponent = class(HumanControllerComponent)

function HCRezCardComponent:onAltClick(card, slot)
    local i = cardspec:interactionFromTable(card.meta)

    if i == "rez" then
        game.corp:actionRez(card, slot)
        return true
    end
end

