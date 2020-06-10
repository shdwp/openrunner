--- @class Side
Side = {}

--- @return Side
function Side:New(max_clicks)
    return construct(self, {
        max_clicks = max_clicks,
        clicks = max_clicks,
        points = 0,
        score = 0,
        credits = 0,
    })
end

--- @param amount number
function Side:alterCredits(amount)
    self.credits = self.credits + amount
end

--- @param amount number
function Side:alterClicks(amount)
    self.clicks = self.clicks + amount
end

--- @param amount number
function Side:alterScore(amount)
    self.score = self.score + amount
end

--- @return boolean
function Side:spendClick()
    if self.clicks > 0 then
        self.clicks = self.clicks - 1
        return true
    else
        return false
    end
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
    self.clicks = self.max_clicks
end
