--- @class DiscountedInstallDecision: Decision
--- @field card Card
--- @field slot string
DiscountedInstallDecision = class("DiscountedInstallDecision", Decision, { Type = "discounted_install"})

--- @param side string
--- @param slot string
--- @param card Card
--- @return DiscountedInstallDecision
function DiscountedInstallDecision:New(side, slot, card)
    return construct(self, Decision:New(self.Type, side), {
        card = card,
        slot = slot,
    })
end
