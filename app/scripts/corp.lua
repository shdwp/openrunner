Corp = {}

function Corp.new()
    local table = {
        max_clicks = 4,
        clicks = 4,
        points = 0,
        score = 0,
        credits = 3,
        bad_publicity = 0,
    }

    setmetatable(table, {__index = Corp})
    return table
end

--- @param amount number
function Corp:alterCredits(amount)
    self.credits = self.credits + amount
end

--- @param amount number
function Corp:alterClicks(amount)
    self.clicks = self.clicks + amount
end

--- @param amount number
function Corp:alterScore(amount)
    self.score = self.score + amount
end

--- @param amount number
function Corp:alterBadPublicity(amount)
    self.bad_publicity = self.bad_publicity + amount
end

--- @return boolean
function Corp:spendClick()
    if self.clicks > 0 then
        self.clicks = self.clicks - 1
        return true
    else
        return false
    end
end

--- @param amount number
--- @return boolean
function Corp:spendCredits(amount)
    if self.credits >= amount then
        self:alterCredits(-amount)
        return true
    else
        return false
    end
end

--- @param meta table card metatable
--- @return boolean
function Corp:payPrice(meta)
    return self:spendCredits(meta.info.cost)
end

function Corp:newTurn()
    self.clicks = self.max_clicks
    self:drawCard()
end

function Corp:drawCard()
    local deck = board:deckGet("corp_rnd", 0)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = db:card(card_info.uid)
        board:cardAppend("corp_hand", card)
    end
end

function Corp:actionDrawCard()
    if self:spendClick() then
        self:drawCard()
    end
end

--- @param card userdata Card
--- @param from string
--- @param to string
function Corp:actionInstallRemote(card, from, to)
    if self:spendClick() then
        card.faceup = false
        card.meta.adv = 0
        board:cardAppend(to, card)

        board:cardPop(from, card)
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionAdvance(card, from)
    if not cardspec:canAdvance(card.meta) then
        host:info("cardspec forbids advance!")
        return false
    end

    if self:spendCredits(1) and self:spendClick() then
        card.meta.adv = card.meta.adv + 1
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionScore(card, from)
    if card.meta.adv >= card.meta.info.advancement_cost then
        cardspec:onScore(card.meta)
        board:cardPop(from, card)
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionRez(card, from)
    if self:payPrice(card.meta) then
        cardspec:onRez(card.meta)
        card.faceup = true
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionOperation(card, from)
    if not cardspec:canPlay(card.meta) then
        return
    end

    if self:payPrice(card.meta) and self:spendClick() then
        cardspec:onPlay(card.meta)
        board:cardPop(from, card)
    end
end