--- @class HCRezCardComponent: HumanControllerComponent
--- @field during_run boolean
--- @field decision RunIceRezDecision
HCRezCardComponent = class(HumanControllerComponent)

function HCRezCardComponent:New(controller, side_id, phaseType, restrictSlot, requireCard, during_run)
    return construct(self, HumanControllerComponent:New(controller, side_id, phaseType, restrictSlot, requireCard), {
        during_run = during_run,
    })
end

function HCRezCardComponent:onAltClick(card, slot)
    if game.corp:actionRez(card, slot) then
        if self.decision.type == RunIceRezDecision.Type then
            return self.decision:iceRezzed(card, slot)
        else
            return self.decision:handledTop()
        end
    end
end

function HCRezCardComponent:onCancel()
    if self.during_run then
        return self.decision:handledTop()
    end
end
