--- @class HumanControllerComponent
--- @field controller HumanController
--- @field phase InteractionPhase
--- @field side Side
--- @field phaseType string
--- @field restrictSlot function
--- @field requireCard boolean
HumanControllerComponent = class()

function HumanControllerComponent:New(controller, side, phaseType, restrictSlot, requireCard)
    return construct(self, {
        controller = controller,
        side = side == SIDE_CORP and game.corp or game.runner,
        phaseType = phaseType,
        restrictSlot = restrictSlot,
        requireCard = requireCard and requireCard or false,
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
