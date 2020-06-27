--- @class AIAdvanceCardAction: AIAction
--- @field meta CardMeta
AIAdvanceCardAction = class("AIAdvanceCardAction", AIAction)

--- @param meta CardMeta
function AIAdvanceCardAction:New(meta)
    return construct(self, {
        meta = meta,
    })
end