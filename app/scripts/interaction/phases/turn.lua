--- @class TurnBasePhase: InteractionPhase
TurnBasePhase = class(InteractionPhase, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBasePhase
function TurnBasePhase:New(side)
    return construct(self, InteractionPhase:New(self.Type, side))
end

--- @class HandDiscardPhase: InteractionPhase
TurnEndPhase = class(InteractionPhase, {
    Type = "hand_discard_phase"
})

--- @param side string
--- @param amount number
--- @return HandDiscardPhase
function TurnEndPhase:New(side, amount)
    return construct(self, InteractionPhase:New(self.Type, side), {
        amount = amount
    })
end
