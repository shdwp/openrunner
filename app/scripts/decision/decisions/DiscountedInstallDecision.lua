--- @class DiscountedInstallDecision: Decision
--- @field card Card
--- @field slot string
--- @field discount number
DiscountedInstallDecision = class("DiscountedInstallDecision", Decision, { Type = "discounted_install"})

--- @param side string
--- @param slot string
--- @param card Card
--- @param discount number
--- @return DiscountedInstallDecision
function DiscountedInstallDecision:New(side, slot, card, discount)
    return construct(self, Decision:New(self.Type, side), {
        card = card,
        slot = slot,
        discount = discount,
    })
end
