--- @class RunAccessDecision: Decision
--- @field slot string
--- @field additional_amount number
RunAccessDecision = class("RunAccessDecision", Decision, { Type = "run_access"})

--- @param side string
--- @param slot string
--- @return RunAccessDecision
function RunAccessDecision:New(side, slot, additional_amount)
    return construct(self, Decision:New(self.Type, side), {
        slot = slot,
        additional_amount = additional_amount or 0,
    })
end

--- @param card Card
--- @return boolean
function RunAccessDecision:score(card)
    game.runner:scoreAgenda(card)
    self:_removeCardFromCorp(card)
    return true
end

--- @param card Card
--- @return boolean
function RunAccessDecision:trash(card)
    if game.runner:spendCredits(card.meta.info.trash_cost) then
        self:_removeCardFromCorp(card)
        return true
    end
end

--- @param card Card
function RunAccessDecision:_removeCardFromCorp(card)
    if isSlotRemote(self.slot) or self.slot == SLOT_CORP_HQ then
        board:cardPop(self.slot, card)
    elseif self.slot == SLOT_CORP_RND then
        local deck = board:deckGet(SLOT_CORP_RND, 0)
        deck:erase(card)
    elseif self.slot == SLOT_CORP_ARCHIVES then
        local deck = board:deckGet(SLOT_CORP_ARCHIVES, 0)
        deck:erase(card)
    end
end

--- @return Deck
function RunAccessDecision:accessedCards()
    local deck = Deck()
    if isSlotRemote(self.slot) then
        for i = 0, board:count(self.slot) - 1 do
            deck:append(board:cardGet(self.slot, i))
        end
    elseif self.slot == SLOT_CORP_RND then
        local rnd_deck = board:deckGet(self.slot, 0)
        local amount = 1 + self.additional_amount
        if amount > rnd_deck.size then
            amount = rnd_deck.size
        end

        for i = 0, amount - 1 do
            deck:append(rnd_deck:at(i))
        end
    elseif self.slot == SLOT_CORP_ARCHIVES then
        local archives_deck = board:deckGet(self.slot, 0)
        for i = 0, archives_deck.size - 1 do
            deck:append(archives_deck:at(i))
        end
    elseif self.slot == SLOT_CORP_HQ then
        local count = board:count(SLOT_CORP_HAND)
        if count > 0 then
            local idx = math.random(0, board:count(SLOT_CORP_HAND) - 1)
            deck:append(board:cardGet(SLOT_CORP_HAND, idx))
        end
    end

    return deck
end

