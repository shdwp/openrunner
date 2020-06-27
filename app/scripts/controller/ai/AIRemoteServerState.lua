--- @class RemoteServerState
--- @field slot string
--- @field factor number
--- @field core table<number, CardMeta>
--- @field ice table<number, CardMeta>
RemoteServerState = class("RemoteServerState")

function RemoteServerState:New(slot, ice_slot)
    local t = construct(self, {
        slot = slot,
        factor = 1,
        core = {},
        ice = {},
    })

    if slot == SLOT_CORP_HQ then
        for i = 0, board:count(SLOT_CORP_HAND) -1 do
            table.insert(t.core, board:cardGet(SLOT_CORP_HAND, i).meta)
        end

        t.factor = board:count(SLOT_CORP_HAND) * 2
    elseif slot == SLOT_CORP_ARCHIVES then
        local deck = board:deckGet(slot, 0)
        for i = 0, deck.size - 1 do
            table.insert(t.core, deck:at(i).meta)
        end
    elseif slot == SLOT_CORP_RND then
        local deck = board:deckGet(slot, 0)
        for i = 0, deck.size - 1 do
            table.insert(t.core, deck:at(i).meta)
        end

        t.factor = deck.size
    elseif isSlotRemote(slot) then
        for i = 0, board:count(slot) - 1 do
            table.insert(t.core, board:cardGet(slot, i).meta)
        end
    end

    for i = 0, board:count(ice_slot) - 1 do
        table.insert(t.ice, board:cardGet(ice_slot, i).meta)
    end

    return t
end

--- @param ice_meta CardMeta
function RemoteServerState:addIce(ice_meta)
    table.insert(self.ice, ice_meta)
end

--- @return number
function RemoteServerState:calculateScore()
    local core_score = 0
    for _, core_meta in pairs(self.core) do
        if core_meta:isAgenda() then
            core_score = core_score + (core_meta.info.agenda_points * 30) + (10 * core_meta:advancementProgress())
        elseif core_meta:isAsset() then
            core_score = core_score + 20
            if core_meta.rezzed then
                core_score = core_score + 20
            end
        end
    end

    core_score = core_score / self.factor

    local ice_score = 0
    for _, ice_meta in pairs(self.ice) do
        local ice_str = ice_meta.info.strength * #ice_meta.info.subroutines
        ice_score = ice_score + ice_str * 10
    end

    local score = -math.abs(ice_score - core_score)
    info("Calculate remote %s score: %d (%d pieces of ice)", self.slot, score, #self.ice)
    return score
end

