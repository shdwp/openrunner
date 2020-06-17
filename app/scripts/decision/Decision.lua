--- @class Decision
--- @field type string
--- @field side string
Decision = class()

--- @param type string type identifier
--- @param side string side
--- @return Decision
function Decision:New(type, side)
    return construct(self, {
        type = type,
        side = side,
    })
end
