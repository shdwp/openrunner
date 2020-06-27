--- @class AIActionCardAction: AIAction
--- @field meta CardMeta
AIActionCardAction = class("AIActionCardAction", AIAction)

--- @param meta CardMeta
--- @return AIActionCardAction
function AIActionCardAction:New(meta)
    return construct(self, {
        meta = meta,
    })
end