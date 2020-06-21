--- @class HCAdvanceCardComponent: HumanControllerComponent
HCAdvanceCardComponent = class("HCAdvanceCardComponent", HumanControllerComponent)

function HCAdvanceCardComponent:onSecondary(card, slot)
    local free = false
    if self.decision.type == FreeAdvanceDecision.Type then
        if not self.decision.cb(card) then
            info("Unable to free advance %d - cardspec forbids!", card.uid)
            return false
        else
            free = true
        end
    end

    if game.corp:actionAdvance(card, slot, free) then
        info("Corp advanced %d from %s", card.uid, slot)
        return self.decision:handledTop()
    end
end