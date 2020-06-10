--- @class PlayerController
--- @field handling InteractionPhase
PlayerController = class()

--- @param child_storage table
--- @return PlayerController
function PlayerController:New()
    return construct(self)
end

function PlayerController:active() return self.handling ~= nil end

--- @param phase InteractionPhase
function PlayerController:handle(phase)
    info("Controller %s handling %s of %s", self, phase.type, phase.side)
end

function PlayerController:handled()
    self.handling = nil
    game:cycle()
end