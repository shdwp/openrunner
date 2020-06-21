--- @class RunAccessDecision: Decision
--- @field slot string
RunAccessDecision = class(Decision, { Type = "run_access"})

--- @param side string
--- @param slot string
--- @return RunAccessDecision
function RunAccessDecision:New(side, slot)
    return construct(self, Decision:New(self.Type, side), {
        slot = slot,
    })
end

function RunAccessDecision:accessedCardsIter()
    if isSlotRemote(self.slot) then
        local i = 0
        local n = board:count(self.slot)
        return function ()
            if i >= n then
                return nil
            else
                local value = board:cardGet(self.slot, i)
                i = i + 1
                return value
            end
        end
    elseif self.slot == SLOT_CORP_RND then
        assert(false, "not implemented")
    elseif self.slot == SLOT_CORP_ARCHIVES then
        assert(false, "not implemented")
    elseif self.slot == SLOT_CORP_HQ then
        assert(false, "not implemented")
    end
end
