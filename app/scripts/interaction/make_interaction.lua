make_interaction = {

}

--- @param side string
--- @param slot string
--- @param amount number amount of cards
--- @param limit number limit to top N
--- @param cb function accepting Card
function make_interaction:promptDeckSelect(side, slot, limit, amount, cb)
    game:pushPhase(SelectFromDeckPhase:New(side, slot, limit, amount, cb))
end

--- @param side string
--- @param slot string
--- @param cb function accepting Card
--- @return boolean
function make_interaction:promptSlotSelect(side, slot, amount, cb)
    game:pushPhase(SelectFromSlotPhase:New(side, slot, amount, cb))
end

--- @param side string
--- @param card userdata Card
--- @return boolean
function make_interaction:promptFreeInstall(side, card)
    return true
end

--- @param side string
--- @param cb function accepting Card
--- @return boolean
function make_interaction:promptFreeAdvance(side, cb)
    return true
end
