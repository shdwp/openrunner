--- @class PlayerController
--- @field phase Decision
--- @field side Side
PlayerController = class()

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

function PlayerController:active() return self.phase ~= nil end

--- @param phase Decision
function PlayerController:handle(phase)
    info("Controller of %s phase %s of %s", self.side.id, phase.type, phase.side)
    self.phase = phase
end

--- @param amount number amount of phases to pop
function PlayerController:handled(amount)
    amount = amount or 1

    if game.decision_stack:popIfTop(self.phase) then
        info("Controller of %s handled %d phases", self.side.id, amount)
        self.phase = nil

        for _ = 2, amount do
            game.decision_stack:pop()
        end
    else
        info("Controller of %s handled phase %s (attempted %d)", self.side.id, self.phase.type, amount)
        game.decision_stack:remove(self.phase)
    end

    self.phase = nil
    game:cycle()
end

--- @param type string type of last handled decision
function PlayerController:handledTo(type)
    if game.decision_stack:popTo(type) then
        info("Controller of %s handled phases to %s", self.side.id, type)
    end

    self.phase = nil
    game:cycle()
end

function PlayerController:delegated()
    self.phase = nil
    game:cycle()
end
