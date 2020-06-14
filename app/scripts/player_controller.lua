--- @class PlayerController
--- @field phase InteractionPhase
PlayerController = class()

--- @param side string
--- @return PlayerController
function PlayerController:New(side)
    return construct(self, {
        side = side
    })
end

function PlayerController:active() return self.phase ~= nil end

--- @param phase InteractionPhase
function PlayerController:handle(phase)
    info("Controller %s phase %s of %s", self, phase.type, phase.side)
    self.phase = phase
end

--- @param amount number amount of phases to pop
function PlayerController:handled(amount)
    amount = amount or 1

    if game:popIfTop(self.phase) then
        info("Controller %s handled %d phases", self, amount)
        self.phase = nil

        for _ = 2, amount do
            game:popPhase()
        end
    else
        info("Controller %s handled phase %s (attempted %d)", self, self.phase.type, amount)
        game:popPhase(self.phase)
    end

    self.phase = nil
    game:cycle()
end

function PlayerController:delegated()
    self.phase = nil
    game:cycle()
end
