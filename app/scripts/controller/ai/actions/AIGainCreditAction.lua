--- @class AIGainCreditAction: AIAction
AIGainCreditAction = class("AIGainCreditAction", AIAction)

function AIGainCreditAction:handle(decision, state, actions)
    print(decision)
    print(state.gameState.stack:top())
    
    decision.side.bank:credit(1)
    return decision:handledTop()
end