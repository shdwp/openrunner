--- @class Side
--- @field max_clicks number
--- @field points number
--- @field score number
--- @field credits number
Side = {}

--- @return Side
function Side:New(max_clicks)
    return construct(self, {
        max_clicks = max_clicks,
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
