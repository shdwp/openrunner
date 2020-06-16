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

--- @class SelectFromDeckPhase: InteractionPhase
--- @field slot string
--- @field limit number
--- @field amount number
--- @field cb function
SelectFromDeckPhase = class(InteractionPhase, {Type = "deck_select"})

--- @param side string
--- @param slot string slot of the deck
--- @param limit number limit query to first N cards
--- @param amount number amount of cards to pick
--- @param cb function callback
--- @return SelectFromDeckPhase
function SelectFromDeckPhase:New(side, slot, limit, amount, cb)
    return construct(self, InteractionPhase:New(self.Type, side), {
        slot = slot,
        limit = limit,
        amount = amount,
        cb = cb
    })
end

--- @class SelectFromSlotPhase: InteractionPhase
--- @field slot string
--- @field amount number
--- @field cb function
SelectFromSlotPhase = class(InteractionPhase, {Type = "select_from_slot"})

--- @param side string
--- @param slot string
--- @param amount number
--- @param cb function
function SelectFromSlotPhase:New(side, slot, amount, cb)
    return construct(self, InteractionPhase:New(self.Type, side), {
        slot = slot,
        amount = amount,
        cb = cb,
    })
end

--- @class InstallPhase: InteractionPhase
--- @field card Card
--- @field slot string
InstallPhase = class(InteractionPhase, {Type = "install"})

--- @param side string
--- @param slot string
--- @param card Card
--- @return InstallPhase
function InstallPhase:New(side, slot, card)
    return construct(self, InteractionPhase:New(self.Type, side), {
        card = card,
        slot = slot,
    })
end

--- @class FreeInstallPhase: InteractionPhase
--- @field card Card
--- @field slot string
FreeInstallPhase = class(InteractionPhase, {Type = "free_install"})

--- @param side string
--- @param slot string
--- @param card Card
--- @return FreeInstallPhase
function FreeInstallPhase:New(side, slot, card)
    return construct(self, InteractionPhase:New(self.Type, side), {
        card = card,
        slot = slot,
    })
end

--- @class FreeAdvancePhase: InteractionPhase
--- @field card Card
--- @field slot string
FreeAdvancePhase = class(InteractionPhase, {Type = "free_advance"})

--- @param side string
--- @param cb function returning bool
--- @return FreeAdvancePhase
function FreeAdvancePhase:New(side, cb)
    return construct(self, InteractionPhase:New(self.Type, side), {
        cb = cb and cb or function () return true end,
    })
end

--- @class FreeRezPhase: InteractionPhase
FreeRezPhase = class(InteractionPhase, {Type = "free_rez"})

--- @param side string
--- @param cb function returning bool
--- @return FreeRezPhase
function FreeRezPhase:New(side, cb)
    return construct(self, InteractionPhase:New(self.Type, side), {
        cb = cb and cb or function () return true end,
    })
end