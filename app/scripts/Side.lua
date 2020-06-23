--- @class Side
--- @field id string
--- @field max_clicks number
--- @field max_hand number
--- @field score number
--- @field credits number
Side = class("Side")

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
        if amount > 0 then
            self:alterCredits(-amount)
        end

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
function Side:actionDiscard(card)
    board:cardPop(card.slotid, card)

    local deck = board:deckGet(sideDiscardSlot(self.id), 0)
    card.faceup = false
    deck:append(card)
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

    if not card.meta:canPlay() then
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
    card.meta:onPlay()
    board:cardPop(from, card)
end
