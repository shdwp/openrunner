--- @class HandDiscardPhase: InteractionPhase
HandDiscardPhase = class(InteractionPhase, {
    Type = "hand_discard_phase"
})

--- @param side string
--- @return HandDiscardPhase
function HandDiscardPhase:New(side)
    return construct(self, InteractionPhase:New(self.Type, side))
end
