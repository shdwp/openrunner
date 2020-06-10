--- @class TurnBasePhase: InteractionPhase
TurnBasePhase = class(InteractionPhase, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBasePhase
function TurnBasePhase:New(side)
    return construct(self, InteractionPhase:New(self.Type, side))
end

--- @class TurnEndPhase: InteractionPhase
TurnEndPhase = class(InteractionPhase, {
    Type = "turn_end"
})

--- @param side string
--- @return TurnEndPhase
function TurnEndPhase:New(side)
    return construct(self, InteractionPhase:New(self.Type, side))
end
