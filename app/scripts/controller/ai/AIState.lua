--- @class AIState
--- @field credits number
--- @field score number
--- @field remotes table<number, RemoteServerState>
AIState = class("AIState")

--- @param clicks number
--- @return AIState
function AIState:New(clicks)
    local t = construct(self, {
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

--- @return number
function AIState:calculateScore()
    local credits_score = -((self.credits / 10) ^ -2)
    info("Credits score %f", credits_score)
    local score_score = self.score * 70
    info("Score score %d", score_score)

    local score = credits_score + score_score

    for _, r in pairs(self.remotes) do
        score = score + r:calculateScore()
    end

    info("Calculated total score %d", score)
end
