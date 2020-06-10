--- @class InteractionPhase
--- @field type string
--- @field side string
InteractionPhase = class()

--- @param type string type identifier
--- @param side string side
--- @return InteractionPhase
function InteractionPhase:New(type, side)
    return construct(self, {
        type = type,
        side = side,
    })
end

--- @class DeckSelectIntr: InteractionPhase
DeckSelectIntr = class(InteractionPhase, { Type = "deck_select" })

--- @param side string
--- @param slot string slot of the deck
--- @param limit number limit query to first N cards
--- @param amount number amount of cards to pick
--- @param cb function callback
--- @return DeckSelectIntr
function DeckSelectIntr:New(side, slot, limit, amount, cb)
    return construct(self, InteractionPhase:New(DeckSelectIntr.Type, side), {
        slot = slot,
        limit = limit,
        amount = amount,
        cb = cb
    })
end

--- @class TurnBaseIntr: InteractionPhase
TurnBaseIntr = class(InteractionPhase, {
    Type = "turn_base"
})

--- @param side string
--- @return TurnBaseIntr
function TurnBaseIntr:New(side)
    return construct(self, InteractionPhase:New(TurnBaseIntr.Type, side))
end

--- @class TurnEndIntr: InteractionPhase
TurnEndIntr = class(InteractionPhase, {
    Type = "turn_end"
})

--- @param side string
--- @return TurnEndIntr
function TurnEndIntr:New(side)
    return construct(self, InteractionPhase:New(TurnEndIntr.Type, side))
end