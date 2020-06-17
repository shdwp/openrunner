--- @class HCScoreCardComponent: HumanControllerComponent
HCScoreCardComponent = class(HumanControllerComponent)

function HCScoreCardComponent:onAltClick(card, slot)
    local i = card.meta:interactionFromBoard()
    if i == "score" then
        game.corp:actionScore(card, slot)
        return true
    end
end