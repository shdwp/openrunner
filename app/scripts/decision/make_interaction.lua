make_interaction = {

}

--- @param side string
--- @param slot string
--- @param amount number amount of cards
--- @param limit number limit to top N
--- @param cb fun(card: Card): boolean
function make_interaction:promptDeckSelect(side, slot, limit, amount, cb)
    game.decision_stack:push(SelectFromDeckDecision:New(side, slot, limit, amount, cb))
    game:cycle()
end

--- @param side string
--- @param slot string
--- @param amount number
--- @param cb fun(decision: SelectFromSlotDecision, card: Card, slot: string): boolean
--- @param forced boolean
function make_interaction:promptSlotSelect(side, slot, amount, cb, forced)
    game.decision_stack:push(SelectFromSlotDecision:New(side, slot, amount, cb, forced))
    game:cycle()
end

--- @param side string
--- @param card userdata Card
--- @param discount number
function make_interaction:promptDiscountedInstall(side, slot, card, discount)
    game.decision_stack:push(DiscountedInstallDecision:New(side, slot, card, discount and discount or -99))
    game:cycle()
end

--- @param side string
--- @param cb function returning bool
function make_interaction:promptFreeAdvance(side, cb)
    game.decision_stack:push(FreeAdvanceDecision:New(side, cb))
    game:cycle()
end

--- @param side string
--- @param options table<string, string>
--- @param cb fun(option: string): boolean
function make_interaction:promptOptionSelect(side, options, cb)
    game.decision_stack:push(SelectFromOptionsDecision:New(side, options, cb))
    game:cycle()
end

function make_interaction:displayFaceup(side, card)
end
