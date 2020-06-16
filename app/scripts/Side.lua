--- @class Side
--- @field id string
--- @field max_clicks number
--- @field max_hand number
--- @field score number
--- @field credits number
Side = {}

--- @return Side
function Side:New(id, max_clicks)
    return construct(self, {
        id = id,
        max_clicks = max_clicks,
        max_hand = 5,
        score = 0,
        credits = 25,
    })
end

--- @param amount number
function Side:alterCredits(amount)
    self.credits = self.credits + amount
end

--- @param amount number
function Side:alterScore(amount)
    self.score = self.score + amount
end

--- @param amount number
--- @return boolean
function Side:spendCredits(amount)
    if self.credits >= amount then
        self:alterCredits(-amount)
        return true
    else
        return false
    end
end

--- @param meta table card metatable
--- @return boolean
function Side:payPrice(meta)
    return self:spendCredits(meta.info.cost)
end

function Side:newTurn()
end

--- @param card Card
--- @param from string
function Side:actionDiscard(card, from)
    board:cardPop(from, card)
end

function Side:actionDrawCard()
    error("Not implemented.")
end

--- @param card Card
--- @param from string
--- @return boolean
function Side:actionPayEvent(card, from)
    if not card then
        return false
    end

    if not cardspec:canPlay(card.meta) then
        return false
    end

    if self:payPrice(card.meta) then
        return true
    end
end

--- @param card Card
--- @param from string
--- @return boolean
function Side:actionPlayEvent(card, from)
    cardspec:onPlay(card.meta)
    board:cardPop(from, card)
end
