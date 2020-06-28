--- @class Decision
--- @field Type string
--- @field type string
--- @field state GameState
--- @field side Side
Decision = class("Decision")

--- @param type string type identifier
--- @param state GameState
--- @param side_id string side
--- @return Decision
function Decision:New(type, state, side_id)
    return construct(self, {
        type = type,
        side = state:sideObject(side_id),
        state = state,
    })
end

function Decision:debugDescription()
    return self.type .. " for " .. self.side.id
end

function Decision:autoHandle()
    return false
end

function Decision:handledSelf()
    info("Decision %s handled self", self)
    self.state.stack:remove(self)
    self.state:cycle()
    return true
end

--- @param amount number
--- @return boolean
function Decision:handledTop(amount)
    amount = amount or 1

    if self.state.stack:popIfTop(self) then
        info("Decision %s handled %d on top", self, amount)

        for _ = 2, amount do
            self.state.stack:pop()
        end
    elseif self.state.stack:remove(self) then
        info("Decision %s tried to handle %d, but only hanlded itself", self, amount)
    else
        info("Decision %s tried to handle %d, but failed due to no longer being on stack", self, amount)
    end

    --- defer call in order to clear the stack
    self.state:cycle()
    return true
end

--- @param decision Decision
--- @return boolean
function Decision:handledSpecific(decision)
    assert(decision)
    info("Decision %s handled specific decision %s", self, decision.type)
    self.state.stack:remove(decision)
    return true
end

--- @param type string type of last handled decision
--- @return boolean
function Decision:handledUpTo(type)
    if game.decision_stack:popUpTo(type) then
        info("Decision %s handled decisions up to %s", self, type)
    end

    self.state:cycle()
    return true
end
