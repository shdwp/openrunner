--- @class HCAdvanceCardComponent: HumanControllerComponent
HCAdvanceCardComponent = class(HumanControllerComponent)

function HCAdvanceCardComponent:onAltClick(card, slot)
    local free = false
    if self.phase.type == FreeAdvanceDecision.Type then
        if not self.phase.cb(card) then
            info("Unable to free advance %d - cardspec forbids!", card.uid)
            return false
        else
            free = true
        end
    end

    if game.corp:actionAdvance(card, slot, free) then
        info("Corp advanced %d from %s", card.uid, slot)
        return self:handled()
    end
end