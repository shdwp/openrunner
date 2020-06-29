--- @class AIRemoteServerState
--- @field slot string
--- @field ice_slot string
--- @field state GameState
--- @field factor number
AIRemoteServerState = class("AIRemoteServerState")

--- @param state GameState
--- @param slot string
--- @param ice_slot string
--- @return AIRemoteServerState
function AIRemoteServerState:New(state, slot, ice_slot)
    local t = construct(self, {
        state = state,
        slot = slot,
        ice_slot = ice_slot,
    })
    return t
end

function AIRemoteServerState:_calculateCoreScore(meta)
    if meta:isAgenda() then
        return (meta.info.agenda_points * 30) + (10 * meta:advancementProgress())
    elseif meta:isAsset() then
        if meta.rezzed then
            return 40
        else
            return 20
        end
    else
        return 10
    end
end

--- @return number
function AIRemoteServerState:calculateScore()
    local core_score = 0
    
    if self.slot == SLOT_CORP_HQ then
        local count = self.state.board:count(SLOT_CORP_HAND) - 1
        for i = 0, count - 1 do
            core_score = core_score + self:_calculateCoreScore(self.state.board:cardAt(SLOT_CORP_HAND, i).meta) / (count * 2)
        end
    elseif self.slot == SLOT_CORP_ARCHIVES then
        local deck = self.state.board:deckAt(self.slot)
        for i = 0, deck.size - 1 do
            core_score = core_score + self:_calculateCoreScore(deck:at(i).meta)
        end
    elseif self.slot == SLOT_CORP_RND then
        local deck = self.state.board:deckAt(self.slot)
        for i = 0, deck.size - 1 do
            core_score = core_score + self:_calculateCoreScore(deck:at(i).meta) / deck.size
        end
    elseif isSlotRemote(self.slot) then
        for card in self.state.board:cardsIter(self.slot) do
            core_score = core_score + self:_calculateCoreScore(card.meta)
        end
    end

    local ice_score = 0
    for card in self.state.board:cardsIter(self.ice_slot) do
        local ice_str = card.meta.info.strength * #card.meta.info.subroutines
        ice_score = ice_score + ice_str * 10
    end

    local score = -math.abs(ice_score - core_score)
    info("Calculate remote %s score: %d (%f ice)", self.slot, score, ice_score)
    return score
end

