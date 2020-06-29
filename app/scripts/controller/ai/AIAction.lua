--- @class AIAction
--- @field side Side
AIAction = class("AIAction")

function AIAction:New(side)
    return construct(self, {
        side = side,
    })
end

--- @param decision Decision
--- @param state AIState
--- @param actions table<number, AIAction>
function AIAction:handle(decision, state, actions) end
