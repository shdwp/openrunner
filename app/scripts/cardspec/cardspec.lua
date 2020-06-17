--- @class cardspec
--- @field cards table<number, CardInfo>
--- @field card_titles table<string, number>
cardspec = {
    cards = {},
    card_titles = {},
}

--- @class CardInfo

--- @class CardMeta
--- @field info CardInfo
--- @field until_forever table
--- @field until_turn_end table
--- @field until_run_end table

ACTION_PRIMARY = "primary"
ACTION_SECONDARY = "secondary"
ACTION_TERTIARY = "tertiary"

function cardspec:_spec(meta)
    return meta.info
end

function cardspec:buildDeckFromDescription(text)
    local deck = {}
    for line in text:gmatch("[^\n]+") do
        local count = tonumber(line:sub(0, 1))
        local title = line:sub(3)
        for _ = 0, count do
            table.insert(deck, self.cards[self.card_titles[title]])
        end
    end

    return deck
end

function cardspec:infoForCode(code)
    local card = self.cards[code]
    if not card then error("Failed to find card %s", code) end
    return card
end

function cardspec:card(uid)
    local meta = {
        info = self:infoForCode(uid),
        until_turn_end = {},
        until_run_end = {},
        until_forever = {},
        until_use = {},
    }

    return Card(uid, meta)
end

function cardspec:deck(descr)
    local deck = Deck()
    for _, info in pairs(self:buildDeckFromDescription(descr)) do
        local card = self:card(tonumber(info["code"]))
        card.faceup = false
        deck:append(card)
    end

    return deck
end

function cardspec:canAdvance(meta)
    if meta.info.type_code == "agenda" then
        return true
    else
        return false
    end
end

function cardspec:interactionFromHand(meta)
    local t = meta.info.type_code
    if t == "agenda" or t == "asset" or t == "ice" or t == "resource" or t == "hardware" or t == "program" then
        return "install"
    elseif t == "operation" or t == "event" then
        return "play"
    end
end

function cardspec:interactionFromTable(meta)
    local t = meta.info.type_code
    if t == "agenda" then
        return "score"
    elseif t == "asset" then
        return "rez"
    elseif t == "ice" then
        return "rez"
    end
end

-- predicates

function cardspec:canAction(meta)
    local spec = self:_spec(meta)
    return spec.canAction and spec.canAction(meta)
end

function cardspec:canPlay(meta)
    local spec = self:_spec(meta)
    return spec.canPlay == nil or spec.canPlay(meta)
end

function cardspec:canInstall(meta)
    return self:isCardRemote(meta) or self:isCardIce(meta)
end

--- @param meta userdata
--- @param slot string
--- @return boolean
function cardspec:canInstallTo(meta, slot)
    if not self:canInstall(meta) then
        return false
    end

    if meta.info.type_code == "ice" then
        return isSlotIce(slot)
    else
        return isSlotRemote(slot)
    end
end

function cardspec:isCardRemote(meta)
    return meta.info.type_code == "asset" or meta.info.type_code == "agenda"
end

function cardspec:isCardIce(meta)
    return meta.info.type_code == "ice"
end

function cardspec:isCardIcebreaker(meta)
    return meta.info.type_code == "icebreaker"
end

function cardspec:isCardProgram(meta)
    return meta.info.type_code == "program"
end

function cardspec:isCardHardware(meta)
    return meta.info.type_code == "hardware"
end

function cardspec:isCardResource(meta)
    return meta.info.type_code == "resource"
end

function cardspec:isCardConsole(meta)
    return meta.info.type_code == "hardware" and meta.info.keywords == "Console"
end

-- mods

-- events

function cardspec:onRez(meta)
    local spec = self:_spec(meta)
    if spec.onRez then return spec.onRez(meta) end
end

function cardspec:onPlay(meta)
    local spec = self:_spec(meta)
    if spec.onPlay then return spec.onPlay(meta) end
end

function cardspec:onAction(meta)
    local spec = self:_spec(meta)
    return spec.onAction(meta)
end

function cardspec:onInstall(meta)
    local spec = self:_spec(meta)
    if spec and spec.onInstall then return spec.onInstall(meta) end
end

function cardspec:onRemoval(meta)
    local spec = self:_spec(meta)
    if spec and spec.onRemoval then return spec.onRemoval(meta) end
end

function cardspec:onScore(meta)
    local spec = self:_spec(meta)
    return spec.onScore(meta)
end

function cardspec:onNewTurn(meta)
    meta.until_turn_end = {}

    local spec = self:_spec(meta)
    if spec and spec.onNewTurn then return spec.onNewTurn(meta) end
end

function cardspec:onRunStart(meta)

end

function cardspec:onRunEnd(meta)

end
