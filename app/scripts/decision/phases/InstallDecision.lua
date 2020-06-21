--- @class InstallDecision: Decision
--- @field card Card
--- @field slot string
InstallDecision = class("InstallDecision", Decision, { Type = "install"})

--- @param side string
--- @param slot string
--- @param card Card
--- @return InstallDecision
function InstallDecision:New(side, slot, card)
    return construct(self, Decision:New(self.Type, side), {
        card = card,
        slot = slot,
    })
end
