--- @class HCRezCardComponent: HumanControllerComponent
--- @field decision RunIceRezDecision
HCRezCardComponent = class("HCRezCardComponent", HumanControllerComponent)

function HCRezCardComponent:New(controller, side_id, phaseType, restrictSlot, requireCard)
    return construct(self, HumanControllerComponent:New(controller, side_id, phaseType, restrictSlot, requireCard))
end

function HCRezCardComponent:onPrimary(card, slot)
    local intr = card.meta:interactionFromBoard()
    if intr ~= CI_REZ then
        return false
    end

    if self.decision.type == TurnBaseDecision.Type then
        game.corp:actionRez(card, slot)
        return true
    elseif self.decision.type == RunIceRezDecision.Type then
        if card.meta == self.decision.meta and game.corp:actionRez(card, slot) then
            if self.decision.type == RunIceRezDecision.Type then
                return self.decision:iceRezzed()
            end
        end
    end
end

function HCRezCardComponent:onCancel()
    if self.decision.type == RunIceRezDecision.Type then
        return self.decision:handledTop()
    end
end
