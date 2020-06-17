--- @class Db
--- @field cards table<number, CardInfo>
--- @field card_titles table<string, number>
Db = {
    cards = {},
    card_titles = {},
}

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
function Db:card(uid)
    local info = self.cards[uid]
    if not info then
        error("Failed to find card %d", uid)
    end

    return Card(uid, CardMeta:New(info))
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

