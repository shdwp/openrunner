--- @class Runner: Side
--- @field tags number
--- @field link number
--- @field meat_damage number
--- @field brain_damage number
Runner = class(Side)
print(Side)

--- @return Runner
function Runner:New()
    return construct(self, Side:New(4), {
        tags = 0
    })
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

--- @param strength number
--- @return boolean
function Runner:trace(strength) return self.link < strength end

