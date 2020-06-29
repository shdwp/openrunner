--- @class AIDrawCardAction: AIAction
AIDrawCardAction = class("AIDrawCardAction", AIAction)

--- @param decision TurnBaseDecision
function AIDrawCardAction:handle(decision, state, actions)
    decision.side:actionDrawCard()
    return decision:handledTop()
end
