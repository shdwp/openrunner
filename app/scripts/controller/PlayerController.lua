--- @class PlayerController
--- @field decision Decision
--- @field side Side
PlayerController = class("PlayerController")

--- @param side_id string
--- @return PlayerController
function PlayerController:New(side_id)
    return construct(self, {
        side = sideForId(side_id)
    })
end

--- @param type string
--- @param descr SlotInteractable
--- @return boolean
function PlayerController:interaction(type, descr) return false end

function PlayerController:active() return self.decision ~= nil end

--- @param side string
function PlayerController:newTurn(side) end

--- @param decision Decision
function PlayerController:handle(decision)
    info("Controller of %s decision %s of %s", self.side.id, decision.type, decision.side.id)
    self.decision = decision
end

function PlayerController:clear()
    self.decision = nil
end
