--- @class HumanControllerComponent
--- @field controller HumanController
--- @field phase InteractionPhase
--- @field side Side
--- @field phaseType string
--- @field restrictSlot function
--- @field requireCard boolean
HumanControllerComponent = class()

function HumanControllerComponent:New(controller, side, phaseType, restrictSlot, requireCard)
    local t = construct(self, {
        controller = controller,
        phaseType = phaseType,
        restrictSlot = restrictSlot,
        requireCard = requireCard and requireCard or false,
    })

    if side == SIDE_CORP then
        t.side = game.corp
    elseif side == SIDE_RUNNER then
        t.side = game.runner
    end

    return t
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
