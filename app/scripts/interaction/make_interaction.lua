make_interaction = {

}

--- @param slot string
--- @param amount number amount of cards
--- @param limit number limit to top N
--- @param cb function accepting Card
function make_interaction:promptDeckSelect(side, slot, limit, amount, cb)
    InteractionStack:push(DeckSelectIntr:New(side, slot, limit, amount, cb))
end

--- @param slot string
--- @param cb function accepting Card
--- @return boolean
function make_interaction:promptStackSelect(side, slot, cb)
    InteractionStack:push(InteractionPhase:New(
            "stack_select",
            function (selected_card) cb(selected_card) end
    ))
end

--- @param card userdata Card
--- @return boolean
function make_interaction:promptFreeInstall(side, card)
    return true
end

--- @param cb function accepting Card
--- @return boolean
function make_interaction:promptFreeAdvance(side, cb)
    return true
end
