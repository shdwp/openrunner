--- @class HCPlayCardComponent: HumanControllerComponent
--- @field decision TurnBaseDecision
HCPlayCardComponent = class("HCPlayCardComponent", HumanControllerComponent)

function HCPlayCardComponent:onPrimary(card, slot)
    local card_play_type = card.meta:interactionFromHand()
    if card_play_type == "install" then
        info("%s installing %s", self.side.id, card.uid)
        return self.decision:install(self.side.id, card, slot)
    elseif card_play_type == "play" then
        if self.side:actionPayEvent(card, slot) then
            info("%s played %s", self.side.id, card.uid)
            self.side:actionPlayEvent(card, slot)
            return self.decision:handledTop()
        else
            info("%s unable to pay for %d", self.side.id, card.uid)
        end
    else
        error("Unknown play type %s", card_play_type)
    end
end
