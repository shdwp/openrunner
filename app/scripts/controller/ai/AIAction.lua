--- @class AIAction
AIAction = class("AIAction")

function AIAction:New()
    return construct(self)
end

--- @param state AIState
--- @param actions table<number, AIAction>
function AIAction:alterState(state, actions) end
