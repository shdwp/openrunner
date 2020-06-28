--- @class Side
--- @field id string
--- @field state GameState
--- @field bank Bank
--- @field max_clicks number
--- @field max_hand number
--- @field score number
--- @field credits number
Side = class("Side")

--- @param state GameState
--- @param id string
--- @param max_clicks number
--- @return Side
function Side:New(state, id, max_clicks)
    return construct(self, {
        state = state,
        id = id,
        max_clicks = max_clicks,
        bank = Bank:New(),
        max_hand = 5,
        score = 0,
        credits = 5,
    })
end

--- @param amount number
--- @param category string
function Side:alterCredits(amount, category)
    self.credits = self.credits + amount
end

--- @param amount number
function Side:alterScore(amount)
    self.score = self.score + amount
end

--- @param amount number
--- @param category string
--- @return boolean
function Side:spendCredits(amount, category, discount)
    discount = discount or 0
    amount = amount + discount
    
    if amount > 0 then
        return true
    else
        return self.bank:debit(category, -amount)
    end
end

--- @param meta table card metatable
--- @param category string
--- @param discount number defaults to 0
--- @return boolean
function Side:payPrice(meta, category, discount)
    return self:spendCredits(meta.info.cost, category, discount or 0)
end

function Side:newTurn()
end

--- @param card Card
function Side:discard(card)
    self.state.board:pop(card)

    local deck = self.state.board:deck(sideDiscardSlot(self.id))
    card.faceup = false
    deck:append(card)
end

--- @param card Card
--- @param from string
--- @return boolean
function Side:actionPayEvent(card, from)
    if not card then
        return false
    end

    if not card.meta:canPlay(self.state, card) then
        return false
    end

    if self:payPrice(card.meta, SPENDING_EVENT) then
        return true
    end
end

--- @param card Card
--- @param from string
--- @return boolean
function Side:actionPlayEvent(card, from)
    card.meta:onPlay(self.state, card)
    self.state.board:pop(card)
end

--- @return boolean
function Side:actionDrawCard()
    error("Not implemented.")
end

--- @param card Card
--- @param from string
--- @param to string
--- @param suppress_events boolean
--- @param discount number - or + amount
--- @return boolean
function Side:actionInstall(card, from, to, suppress_events, discount)
    error("Not implemented")
    return false
end
