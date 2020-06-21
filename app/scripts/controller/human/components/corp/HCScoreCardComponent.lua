--- @class HCScoreCardComponent: HumanControllerComponent
HCScoreCardComponent = class("HCScoreCardComponent", HumanControllerComponent)

function HCScoreCardComponent:onSecondary(card, slot)
    local i = card.meta:interactionFromBoard()
    if i == "score" then
        game.corp:actionScore(card, slot)
        return true
    end
end