--- @class TurnBasePhase: InteractionPhase
TurnBasePhase = class(InteractionPhase, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBasePhase
function TurnBasePhase:New(side)
    return construct(self, InteractionPhase:New(self.Type, side))
end
