--- @class AIDrawCardAction: AIAction
AIDrawCardAction = class("AIDrawCardAction", AIAction)

function AIDrawCardAction:alterState(state, actions)
    state:alterClicks(-1)
    local deck = board:deckGet(SLOT_CORP_RND, 0)
    local card = deck:top();
end
