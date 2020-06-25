--- @class GameEndDecision: Decision
GameEndDecision = class("GameEndDecision", Decision)

function GameEndDecision:New(side_id)
    return construct(self, Decision:New(self.Type, side_id))
end