--- @class DiscountedInstallDecision: Decision
--- @field card Card
--- @field slot string
--- @field discount number
DiscountedInstallDecision = class("DiscountedInstallDecision", Decision, { Type = "discounted_install"})

--- @param state GameState
--- @param side string
--- @param slot string
--- @param card Card
--- @param discount number
--- @return DiscountedInstallDecision
function DiscountedInstallDecision:New(state, side, slot, card, discount)
    return construct(self, Decision:New(self.Type, state, side), {
        card = card,
        slot = slot,
        discount = discount,
    })
end
