--- @class HandDiscardDecision: Decision
HandDiscardDecision = class(Decision, {
    Type = "hand_discard_phase"
})

--- @param side string
--- @return HandDiscardDecision
function HandDiscardDecision:New(side)
    return construct(self, Decision:New(self.Type, side))
end

function HandDiscardDecision:autoHandle()
    self.amount = board:count(sideHandSlot(self.side.id)) - self.side.max_hand
    if self.amount <= 0 then
        return self:handledTop()
    end
end

--- @param card Card
function HandDiscardDecision:discardedCard(card)
    info("%s discarded %d", self.side.id, card.uid)
    self.amount = self.amount - 1

    if self.amount <= 0 then
        info("%s finished discarding cards", self.side.id)
        self:handledTop()
    end
end
