--- @class Db
--- @field cards table<number, CardInfo>
--- @field card_titles table<string, number>
Db = {
    cards = {},
    card_titles = {},
}

--- @class Ctx
--- @field meta CardMeta
--- @field decision Decision
--- @field card Card
Ctx = class("Ctx")

--- @param decision Decision
--- @param meta CardMeta
--- @param card Card
--- @return Ctx
function Ctx:New(decision, meta, card)
    return construct(self, {
        meta = meta,
        decision = decision,
        card = card,
    })
end

--- @class CardInfo
--- @field code string
--- @field flavor string
--- @field keywords string
--- @field side_code string
--- @field title string
--- @field text string
--- @field type_code string

--- @param text string
--- @return table<number, Card>
function Db:_buildCardInfoArray(text)
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

--- @param uid number
--- @return Card
function Db:card(uid, params)
    params = params or {}

    if type(uid) == "string" then
        uid = self.card_titles[uid]
    end

    local info = self.cards[uid]
    if not info then
        error("Failed to find card %s", uid)
    end

    local card = Card(uid, CardMeta:New(info))
    if params.faceup ~= nil then
        card.faceup = params.faceup
    end

    return card
end

--- @param descr string
--- @return Deck
function Db:deck(descr)
    local deck = Deck()
    for _, info in pairs(self:_buildCardInfoArray(descr)) do
        local card = self:card(tonumber(info.code))
        card.faceup = false
        deck:append(card)
    end

    return deck
end

