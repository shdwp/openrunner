--- @class Decision
--- @field type string
--- @field side_id string
Decision = class()

--- @param type string type identifier
--- @param side_id string side
--- @return Decision
function Decision:New(type, side_id)
    return construct(self, {
        type = type,
        side_id = side_id,
    })
end

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

    game:cycle()
    return true
end

--- @param decision Decision
function Decision:handledSpecific(decision)
    assert(decision)
    info("Decision %s handled specific decision %s", self, decision.type)
    game.decision_stack:remove(decision)
    return true
end

--- @param type string type of last handled decision
function Decision:handledUpTo(type)
    if game.decision_stack:popTo(type) then
        info("Decision %s handled decisions up to %s", self, type)
    end

    game:cycle()
    return true
end
