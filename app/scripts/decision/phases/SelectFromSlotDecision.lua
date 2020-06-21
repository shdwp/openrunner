--- @class SelectFromSlotDecision: Decision
--- @field slot string
--- @field slot_pred fun(slot: string): boolean
--- @field amount number
--- @field cb function
--- @field force boolean
SelectFromSlotDecision = class(Decision, { Type = "select_from_slot"})

--- @param side string
--- @param slot any
--- @param amount number
--- @param cb function
--- @param force boolean
function SelectFromSlotDecision:New(side, slot, amount, cb, force)
    return construct(self, Decision:New(self.Type, side), {
        slot = type(slot) == "string" and slot,
        slot_pred = type(slot) == "function" and slot,
        amount = amount,
        cb = cb,
        force = force,
    })
end

--- @param slot string
--- @return boolean
function SelectFromSlotDecision:allowsSlot(slot)
    if self.slot_pred then
        return self.slot_pred(slot)
    elseif self.slot == slot then
        return true
    else
        return false
    end
end

--- @param card Card
--- @param slot string
--- @return boolean
function SelectFromSlotDecision:selected(card, slot)
    if self:allowsSlot(slot) then
        if self.cb(card, slot) then
            self.amount = self.amount - 1
            if self.amount <= 0 then
                return self:handledTop()
            else
                return true
            end
        end
    end

    return false
end

--- @return boolean
function SelectFromSlotDecision:cancelled()
    if self.force then
        if self.slot then
            return board:count(self.slot) <= 0
        elseif self.slot_pred then
            local count = 0
            for slot in sideSlots(self.side.id) do
                if self.slot_pred(slot) then
                    count = board:count(slot)
                end
            end

            return count <= 0
        end
        return false
    else
        return self:handledTop()
    end
end
