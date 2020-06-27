--- @class AIPlayCardAction: AIAction
--- @field meta CardMeta
AIPlayCardAction = class("AIPlayCardAction", AIAction)

--- @param meta CardMeta
--- @return AIPlayCardAction
function AIPlayCardAction:New(meta)
    return construct(self, {
        meta = meta,
    })
end

function AIPlayCardAction:alterState(state, actions)
    state:alterClicks(-1)

end