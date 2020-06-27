--- @class AIState
--- @field valid boolean
--- @field clicks number
--- @field credits number
--- @field score number
--- @field remotes table<number, RemoteServerState>
AIState = class("AIState")

--- @param clicks number
--- @return AIState
function AIState:New(clicks)
    local t = construct(self, {
        valid = true,
        clicks = clicks,
        credits = game.corp.credits,
        score = game.corp.score,
        remotes = {
            [0] = RemoteServerState:New(SLOT_CORP_HQ, SLOT_CORP_HQ_ICE),
            [1] = RemoteServerState:New(SLOT_CORP_RND, SLOT_CORP_RND_ICE),
            [2] = RemoteServerState:New(SLOT_CORP_ARCHIVES, SLOT_CORP_ARCHIVES_ICE),
        }
    })

    for i = 1, CORP_REMOTE_SLOTS_N do
        table.insert(t.remotes, RemoteServerState:New(remoteSlot(i), remoteIceSlot(i)))
    end

    return t
end

--- @return AIState
function AIState:clone()
    return construct(AIState, {
        valid = self.valid,
        clicks = self.clicks,
        credits = self.credits,
        score = self.score,
        remotes = self.remotes,
    })
end

--- @param amount number
--- @return boolean
function AIState:alterClicks(amount)
    self.clicks = self.clicks + amount

    if self.clicks < 0 then
        self.valid = false
    end
end

--- @param amount number
--- @return boolean
function AIState:alterCredits(amount)
    self.credits = self.credits + amount
    if self.credits < 0 then
        self.valid = false
    end
end

--- @return number
function AIState:calculateScore()
    local credits_score = -((self.credits / 10) ^ -2)
    info("Credits (%d) score %f", self.credits, credits_score)
    local score_score = self.score * 70
    info("Score (%d) score %d", self.score, score_score)

    local score = credits_score + score_score

    for _, r in pairs(self.remotes) do
        score = score + r:calculateScore()
    end

    info("Calculated total score %f", score)
    return score
end
