--- @class HumanControllerComponent
--- @field controller HumanController
--- @field decision Decision
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

--- @return boolean
function HumanControllerComponent:onNewDecision() return false end

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
