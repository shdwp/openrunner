--- @class InstallDecision: Decision
--- @field card Card
--- @field slot string
InstallDecision = class("InstallDecision", Decision, { Type = "install"})

--- @param state GameState
--- @param side string
--- @param slot string
--- @param card Card
--- @return InstallDecision
function InstallDecision:New(state, side, slot, card)
    return construct(self, Decision:New(self.Type, state, side), {
        card = card,
        slot = slot,
    })
end
