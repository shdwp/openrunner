--- @class PlayerController
--- @field phase InteractionPhase
--- @field side Side
PlayerController = class()

--- @param side_id string
--- @return PlayerController
function PlayerController:New(side_id)
    return construct(self, {
        side = sideForId(side_id)
    })
end

function PlayerController:active() return self.phase ~= nil end

--- @param phase InteractionPhase
function PlayerController:handle(phase)
    info("Controller of %s phase %s of %s", self.side.id, phase.type, phase.side)
    self.phase = phase
end

--- @param amount number amount of phases to pop
function PlayerController:handled(amount)
    amount = amount or 1

    if game:popIfTop(self.phase) then
        info("Controller of %s handled %d phases", self.side.id, amount)
        self.phase = nil

        for _ = 2, amount do
            game:popPhase()
        end
    else
        info("Controller of %s handled phase %s (attempted %d)", self.side.id, self.phase.type, amount)
        game:popPhase(self.phase)
    end

    self.phase = nil
    game:cycle()
end

function PlayerController:delegated()
    self.phase = nil
    game:cycle()
end
