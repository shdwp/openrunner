--- @class SelectFromOptionsDecision: Decision
--- @field options table<string, string>
--- @field cb fun(option: string): boolean
SelectFromOptionsDecision = class("SelectFromOptionsDecision", Decision, { Type = "select_from_options "})

--- @param side_id string
--- @param options table<string, string>
--- @param cb fun(option: string): boolean
function SelectFromOptionsDecision:New(side_id, options, cb)
    return construct(self, Decision:New(self.Type, side_id), {
        options = options,
        cb = cb,
    })
end

