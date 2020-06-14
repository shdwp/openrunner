--- @class InteractionStack
--- @field stack table<number, InteractionPhase>
InteractionStack = class()

--- @return InteractionStack
function InteractionStack:New()
    return construct(self, {
        stack = {}
    })
end

--- @return boolean
function InteractionStack:empty()
    return #self.stack == 0
end

--- @param phase InteractionPhase
function InteractionStack:push(phase)
    table.insert(self.stack, phase)
end

--- @return InteractionPhase
function InteractionStack:pop()
    local intr = self.stack[#self.stack]
    table.remove(self.stack, #self.stack)
    return intr
end

--- @param phase InteractionPhase
function InteractionStack:prepend(phase)
    table.insert(self.stack, 1, phase)
end

--- @return InteractionPhase
function InteractionStack:top()
    return self.stack[#self.stack]
end

--- @param phase InteractionPhase
function InteractionStack:remove(phase)
    for k, v in pairs(self.stack) do
        if v == phase then
            table.remove(self.stack, k)
        end
    end
end

--- @param side string
--- @return number
function InteractionStack:countClicks(side)
    local n = 0
    for _, v in pairs(self.stack) do
        if v.side == side and v.type == TurnBasePhase.Type then
            n = n + 1
        end
    end

    return n
end

--- @param side string
--- @param amount number
function InteractionStack:addClicks(side, amount)
    for _ = 1, amount do
        self:prepend(TurnBasePhase:New(side))
    end
end

--- @param side string
--- @param amount number
function InteractionStack:removeClicks(side, amount)
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
