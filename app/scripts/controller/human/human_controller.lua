--- @class HumanController: PlayerController
HumanController = class(PlayerController)

--- @return HumanController
function HumanController:New()
    return construct(self, PlayerController:New())
end

--- @param type string
--- @param descr SlotInteractable
function HumanController:onInteraction(type, descr)
    if not self:active() then
        return
    end

    if self.handling.type == TurnBaseIntr.Type and self.handling.side == SIDE_CORP then
        if descr.slot == "corp_rnd" then
            verbose("corp click on draw card")
            game.corp:actionDrawCard()
            return self:handled()

        elseif itr.slot == "corp_hand" then
            local intr = cardspec:interactionFromHand(itr.card.meta)
            verbose()
            if intr == "install" then
                self.event = itr
            elseif intr == "play" then
                game.corp:actionOperation(itr.card, itr.slot)
                return self:reset()
            end
        end
    end
end

