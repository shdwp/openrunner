--- @class HumanControllerComponent
--- @field controller HumanController
--- @field phase Decision
--- @field side Side
--- @field phaseType string
--- @field restrictSlot function
--- @field requireCard boolean
HumanControllerComponent = class()

function HumanControllerComponent:New(controller, side_id, phaseType, restrictSlot, requireCard)
    return construct(self, {
        controller = controller,
        phaseType = phaseType,
        restrictSlot = restrictSlot,
        requireCard = requireCard and requireCard or false,
        side = sideForId(side_id),
    })
end

function HumanControllerComponent:handled(amount)
    self.controller:handled(amount)
    return true
end

function HumanControllerComponent:delegated()
    self.controller:delegated()
    return true
end

function HumanControllerComponent:handledTo(type)
    self.controller:handledTo(type)
    return true
end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onClick(card, slot) return false end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onAltClick(card, slot) return false end

--- @return boolean
function HumanControllerComponent:onCancel() return false end
