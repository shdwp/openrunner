--- @class HCRezCardComponent: HumanControllerComponent
--- @field supports_cancellation boolean
HCRezCardComponent = class(HumanControllerComponent)

function HCRezCardComponent:New(controller, side_id, phaseType, restrictSlot, requireCard, supports_cancellation)
    return construct(self, HumanControllerComponent:New(controller, side_id, phaseType, restrictSlot, requireCard), {
        supports_cancellation = supports_cancellation
    })
end

function HCRezCardComponent:onAltClick(card, slot)
    if game.corp:actionRez(card, slot) then
        return self:handled()
    end
end

function HCRezCardComponent:onCancel()
    if self.supports_cancellation then
        return self:handled()
    end
end
