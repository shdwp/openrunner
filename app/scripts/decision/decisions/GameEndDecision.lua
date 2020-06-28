--- @class GameEndDecision: Decision
GameEndDecision = class("GameEndDecision", Decision)

--- @param state GameState
--- @param side_id string
--- @return GameEndDecision
function GameEndDecision:New(state, side_id)
    return construct(self, Decision:New(self.Type, state, side_id))
end