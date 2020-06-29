--- @class PromptFactory
--- @field state GameState
PromptFactory = class("DecisionFactory")

function PromptFactory:New(state)
    return construct(self, {
        state = state,
    })
end

--- @param side string
--- @param slot string
--- @param amount number amount of cards
--- @param limit number limit to top N
--- @param cb fun(card: Card): boolean
function PromptFactory:promptDeckSelect(side, slot, limit, amount, cb)
    local deck = self.state.board:deckAt(slot)
    self.state.stack:push(SelectFromDeckDecision:New(self.state, side, deck, limit, amount, cb))
    self.state:cycle()
end

--- @param side string
--- @param slot string
--- @param amount number
--- @param cb fun(decision: SelectFromSlotDecision, card: Card, slot: string): boolean
--- @param forced boolean
function PromptFactory:promptSlotSelect(side, slot, amount, cb, forced)
    self.state.stack:push(SelectFromSlotDecision:New(self.state, side, slot, amount, cb, forced))
    self.state:cycle()
end

--- @param side string
--- @param card userdata Card
--- @param discount number
function PromptFactory:promptDiscountedInstall(side, slot, card, discount)
    self.state.stack:push(DiscountedInstallDecision:New(self.state, side, slot, card, discount and discount or -99))
    self.state:cycle()
end

--- @param side string
--- @param cb function returning bool
function PromptFactory:promptFreeAdvance(side, cb)
    self.state.stack:push(FreeAdvanceDecision:New(self.state, side, cb))
    self.state:cycle()
end

--- @param side string
--- @param options table<string, string>
--- @param cb fun(option: string): boolean
function PromptFactory:promptOptionSelect(side, options, cb)
    self.state.stack:push(SelectFromOptionsDecision:New(self.state, side, options, cb))
    self.state:cycle()
end

function PromptFactory:displayFaceup(side, card)
    local deck = Deck()
    deck:append(card)
    self.state.stack:push(SelectFromDeckDecision:New(self.state, side, deck, 1, 1, function (card) return true end))
    self.state:cycle()
end
