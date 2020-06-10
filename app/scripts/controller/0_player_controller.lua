--- @class PlayerController
--- @field phase InteractionPhase
PlayerController = class()

--- @param child_storage table
--- @return PlayerController
function PlayerController:New()
    return construct(self)
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

        game:cycle()
    else
        info("Controller %s tried to handle %d phases but had to delegate to the top", self, amount)
        self:delegated()
    end

end

function PlayerController:delegated()
    self.phase = nil
    game:cycle()
end
