--- @class HCPlayCardComponent: HumanControllerComponent
HCPlayCardComponent = class(HumanControllerComponent)

function HCPlayCardComponent:onClick(card, slot)
    local card_play_type = cardspec:interactionFromHand(card.meta)
    if card_play_type == "install" then
        info("%s installing %s", self.side.id, card.uid)
        game:pushPhase(InstallPhase:New(self.side.id, slot, card))
        return self:delegated()
    elseif card_play_type == "play" then
        if self.side:actionPayEvent(card, slot) then
            info("%s played %s", self.side.id, card.uid)
            self.side:actionPlayEvent(card, slot)
            return self:handled()
        else
            info("%s unable to pay for %d", self.side.id, card.uid)
        end
    else
        error("Unknown play type %s", card_play_type)
    end
end
