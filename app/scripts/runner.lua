Runner = {

}

function Runner.new()
    local table = {
        max_clicks = 5,
        clicks = 5,
        points = 0,
        score = 0,
        credits = 3,
        tags = 0,
        link = 1,
        meat_damage = 0,
        brain_damage = 0,
    }

    setmetatable(table, {__index = Corp})
    return table
end

--- @param amount number
function Runner:alterCredits(amount)
    self.credits = self.credits + amount
end

--- @param amount number
function Runner:alterClicks(amount)
    self.clicks = self.clicks + amount
end

--- @param amount number
function Runner:alterScore(amount)
    self.score = self.score + amount
end

--- @param amount number
function Runner:alterTags(amount)
    self.tags = self.tags + amount
end

function Runner:alterBrainDamage(amount)
    self.brain_damage = self.brain_damage + amount
end

function Runner:alterMeatDamage(amount)
    self.meat_damage = self.meat_damage + amount
end

--- @return boolean
function Runner:spendClick()
    if self.clicks > 0 then
        self.clicks = self.clicks - 1
        return true
    else
        return false
    end
end

--- @param amount number
--- @return boolean
function Runner:spendCredits(amount)
    if self.credits >= amount then
        self:alterCredits(-amount)
        return true
    else
        return false
    end
end

--- @param meta table card metatable
--- @return boolean
function Runner:payPrice(meta)
    return self:spendCredits(meta.info.cost)
end

--- @param strength number
--- @return boolean
function Runner:trace(strength) return self.link < strength end

