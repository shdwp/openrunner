JSON = dofile(libpath .. "json-lua/JSON.lua")
inspect = dofile(libpath .. "inspect.lua/inspect.lua")

db = {
    _cards = {},
    _cardNameIndexes = {},

    loadPack = function (self, name)
        local path = "../assets/json/pack/" .. name .. ".json"
        local contents = io.open(path, "rb"):read("*all")
        assert(contents)
        local cards = JSON:decode(contents)
        assert(cards)

        for _, v in pairs(cards) do
            local id = tonumber(v["code"])
            self._cards[id] = v
            self._cardNameIndexes[v["title"]] = id
        end
    end,

    buildDeckFromDescription = function (self, text)
        local deck = {}
        for line in text:gmatch("[^\n]+") do
            local count = tonumber(line:sub(0, 1))
            local title = line:sub(3)
            for _=0,count do
                table.insert(deck, self._cards[self._cardNameIndexes[title]])
            end
        end

        return deck
    end,

    infoForCode = function (self, code)
        return self._cards[code]
    end,

    card = function (self, uid)
        return Card(uid, self:infoForCode(uid))
    end,

    deck = function (self, descr)
        local deck = Deck()
        for _, info in pairs(self:buildDeckFromDescription(descr)) do
            local card = self:card(info["code"])
            card.faceup = false
            deck:append(card)
        end

        return deck
    end
}

db:loadPack("core")
