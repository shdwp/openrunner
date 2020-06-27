--- @class AIGainCreditAction: AIAction
AIGainCreditAction = class("AIGainCreditAction", AIAction)

function AIGainCreditAction:alterState(state, actions)
    state:alterClicks(-1)
    state:alterCredits(1)
end