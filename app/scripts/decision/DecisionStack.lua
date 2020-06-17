--- @class DecisionStack
--- @field stack table<number, Decision>
DecisionStack = class()

--- @return DecisionStack
function DecisionStack:New()
    return construct(self, {
        stack = {}
    })
end

--- @return boolean
function DecisionStack:empty()
    return #self.stack == 0
end

--- @param phase Decision
function DecisionStack:push(phase)
    table.insert(self.stack, phase)
end

--- @return Decision
function DecisionStack:pop()
    local intr = self.stack[#self.stack]
    table.remove(self.stack, #self.stack)
    return intr
end

--- @param phase Decision
function DecisionStack:prepend(phase)
    table.insert(self.stack, 2, phase)
end

--- @return Decision
function DecisionStack:top()
    return self.stack[#self.stack]
end

--- @param phase Decision
function DecisionStack:remove(phase)
    for k, v in pairs(self.stack) do
        if v == phase then
            table.remove(self.stack, k)
        end
    end
end

--- @param phase Decision
--- @return boolean
function DecisionStack:popIfTop(phase)
    if self:top() == phase then
        self:pop()
        return true
    end

    return false
end

--- @param phase_type string
--- @return boolean
function DecisionStack:popTo(phase_type)
    local idx = table.indexOf(self.stack, function (t) return t.Type == phase_type  end)
    if idx then
        for k = #self.stack, idx, -1 do
            table.remove(self.stack, k)
        end

        return true
    else
        error("Type %s not found in stack!", phase_type)
        return false
    end
end

--- @param side string
--- @return number
function DecisionStack:countClicks(side)
    local n = 0
    for _, v in pairs(self.stack) do
        if v.side == side and v.type == TurnBaseDecision.Type then
            n = n + 1
        end
    end

    return n
end

--- @param side string
--- @param amount number
function DecisionStack:addClicks(side, amount)
    for _ = 1, amount do
        self:prepend(TurnBaseDecision:New(side))
    end
end

--- @param side string
--- @param amount number
function DecisionStack:removeClicks(side, amount)
    for i = #self.stack, 1 do
        if amount == 0 then
            return
        end

        if self.stack[i].side == side then
            self.stack[i] = nil
            amount = amount - 1
        end
    end
end
