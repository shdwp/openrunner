--- @class HumanControllerComponent
--- @field controller HumanController
--- @field decision Decision
--- @field side Side
--- @field supportedDecisionType string
--- @field restrictSlot function
--- @field requireCard boolean
HumanControllerComponent = class("HumanControllerComponent")

--- @param controller HumanController
--- @param side_id string
--- @param supportedDecisionType string
--- @param restrictSlot fun(slot: string): boolean
--- @param requireCard boolean
--- @return HumanControllerComponent
function HumanControllerComponent:New(controller, side_id, supportedDecisionType, restrictSlot, requireCard)
    return construct(self, {
        controller = controller,
        supportedDecisionType = supportedDecisionType,
        restrictSlot = restrictSlot,
        requireCard = requireCard and requireCard or false,
        side = sideForId(side_id),
    })
end

function HumanControllerComponent:debugDescription()
    return self.side.id .. " stype " .. (self.supportedDecisionType or "nil")
end

function HumanControllerComponent:interactionDescriptions() return {} end

--- @return boolean
function HumanControllerComponent:onNewDecision() return false end

--- @param type string
--- @param option string
--- @return boolean
function HumanControllerComponent:onOptionSelect(type, option) return false end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onPrimary(card, slot) return false end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onSecondary(card, slot) return false end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onTertiary(card, slot) return false end

--- @return boolean
function HumanControllerComponent:onCancel() return false end
