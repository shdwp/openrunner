--- @class HCScoreCardComponent: HumanControllerComponent
HCScoreCardComponent = class(HumanControllerComponent)

function HCScoreCardComponent:onAltClick(card, slot)
    local i = cardspec:interactionFromTable(card.meta)
    if i == "score" then
        game.corp:actionScore(card, slot)
        return true
    end
end