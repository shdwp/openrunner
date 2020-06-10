--- @class InteractionStack
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
    self.stack[#self.stack] = nil
    return intr
end
