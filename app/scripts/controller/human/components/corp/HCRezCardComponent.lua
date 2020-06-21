--- @class HCRezCardComponent: HumanControllerComponent
--- @field decision RunIceRezDecision
HCRezCardComponent = class("HCRezCardComponent", HumanControllerComponent)

function HCRezCardComponent:New(controller, side_id, phaseType, restrictSlot, requireCard)
    return construct(self, HumanControllerComponent:New(controller, side_id, phaseType, restrictSlot, requireCard))
end

function HCRezCardComponent:onSecondary(card, slot)
    if card.meta == self.decision.meta and game.corp:actionRez(card, slot) then
        if self.decision.type == RunIceRezDecision.Type then
            return self.decision:iceRezzed()
        end
    end
end

function HCRezCardComponent:onCancel()
    if self.decision.type == RunIceRezDecision.Type then
        return self.decision:handledTop()
    end
end
