--- @class RunAccessDecision: Decision
--- @field slot string
--- @field additional_amount number
RunAccessDecision = class("RunAccessDecision", Decision, { Type = "run_access"})

--- @param state GameState
--- @param side string
--- @param slot string
--- @return RunAccessDecision
function RunAccessDecision:New(state, side, slot, additional_amount)
    return construct(self, Decision:New(self.Type, state, side), {
        slot = slot,
        additional_amount = additional_amount or 0,
    })
end

--- @param card Card
--- @return boolean
function RunAccessDecision:score(card)
    self.state.runner:scoreAgenda(card)
    self:_removeCardFromCorp(card)
    return true
end

--- @param card Card
--- @return boolean
function RunAccessDecision:trash(card)
    if self.state.runner:spendCredits(card.meta.info.trash_cost, SPENDING_TRASHING) then
        self:_removeCardFromCorp(card)
        return true
    end
end

--- @param card Card
function RunAccessDecision:_removeCardFromCorp(card)
    if isSlotRemote(self.slot) or self.slot == SLOT_CORP_HQ then
        self.state.board:pop(card)
    elseif self.slot == SLOT_CORP_RND then
        local deck = self.state.board:deckAt(SLOT_CORP_RND)
        deck:erase(card)
    elseif self.slot == SLOT_CORP_ARCHIVES then
        local deck = self.state.board:deckAt(SLOT_CORP_ARCHIVES)
        deck:erase(card)
    end
end

--- @return Deck
function RunAccessDecision:accessedCards()
    local deck = Deck()
    if isSlotRemote(self.slot) then
        for i = 0, self.state.board:count(self.slot) - 1 do
            deck:append(self.state.board:cardAt(self.slot, i))
        end
    elseif self.slot == SLOT_CORP_RND then
        local rnd_deck = self.state.board:deckAt(self.slot)
        local amount = 1 + self.additional_amount
        if amount > rnd_deck.size then
            amount = rnd_deck.size
        end

        for i = 0, amount - 1 do
            deck:append(rnd_deck:at(i))
        end
    elseif self.slot == SLOT_CORP_ARCHIVES then
        local archives_deck = self.state.board:deckAt(self.slot)
        for i = 0, archives_deck.size - 1 do
            deck:append(archives_deck:at(i))
        end
    elseif self.slot == SLOT_CORP_HQ then
        local count = self.state.board:count(SLOT_CORP_HAND)
        if count > 0 then
            local idx = math.random(0, self.state.board:count(SLOT_CORP_HAND) - 1)
            deck:append(self.state.board:cardAt(SLOT_CORP_HAND, idx))
        end
    end

    return deck
end

