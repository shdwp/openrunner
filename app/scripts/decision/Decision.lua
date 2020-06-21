--- @class Decision
--- @field Type string
--- @field type string
--- @field side Side
Decision = class("Decision")

--- @param type string type identifier
--- @param side_id string side
--- @return Decision
function Decision:New(type, side_id)
    return construct(self, {
        type = type,
        side = sideForId(side_id),
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
    game.decision_stack:remove(self)
    game:cycle()
    return true
end

--- @param amount number
--- @return boolean
function Decision:handledTop(amount)
    amount = amount or 1

    if game.decision_stack:popIfTop(self) then
        info("Decision %s handled %d on top", self, amount)

        for _ = 2, amount do
            game.decision_stack:pop()
        end
    else
        info("Decision %s tried to handle %d, but only hanlded itself", self, amount)
        game.decision_stack:remove(self)
    end

    --- defer call in order to clear the stack
    game:cycle()
    return true
end

--- @param decision Decision
--- @return boolean
function Decision:handledSpecific(decision)
    assert(decision)
    info("Decision %s handled specific decision %s", self, decision.type)
    game.decision_stack:remove(decision)
    return true
end

--- @param type string type of last handled decision
--- @return boolean
function Decision:handledUpTo(type)
    if game.decision_stack:popUpTo(type) then
        info("Decision %s handled decisions up to %s", self, type)
    end

    game:cycle()
    return true
end
