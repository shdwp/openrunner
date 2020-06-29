--- @class AIState
--- @field valid boolean
--- @field gameState GameState
AIState = class("AIState")

--- @param state GameState
--- @return AIState
function AIState:New(state)
    local t = construct(self, {
        valid = true,
        state = state,
    })

    return t
end

--- @return AIState
function AIState:clone()
    local t = clone(self)
    t.gameState = self.gameState:viewlessDeepcopy()
    return t
end

function AIState:_calculateHandScore()
    local count = self.gameState.board:count(SLOT_CORP_HAND)
    local score = -(count + 4) ^ -1
    info("Calculated hand score: %f (%d cards)", score, count)
    return score
end

--- @return number
function AIState:calculateScore()
    local side = self.gameState:sideObject(SIDE_CORP)
    
    local general_creds = side.bank:count(CREDITS_GENERAL);
    local credits_score = -((general_creds / 10) ^ -2)
    info("Credits (%d) score %f", general_creds, credits_score)
    
    local score_score = side.score * 70
    info("Score (%d) score %d", side.score, score_score)
    
    local remote_score = 0
    local slots = {SLOT_CORP_HQ, SLOT_CORP_RND, SLOT_CORP_ARCHIVES, }
    for i = 1, CORP_REMOTE_SLOTS_N do
        table.insert(slots, remoteSlot(i))
    end
    
    for _, slot in pairs(slots) do
        remote_score = remote_score + AIRemoteServerState:New(self.gameState, slot, iceSlotOfRemote(slot)):calculateScore()
    end
    
    local hand_score = self:_calculateHandScore()

    local score = credits_score + score_score + remote_score + hand_score
    info("Calculated total score %f", score)
    return score
end
