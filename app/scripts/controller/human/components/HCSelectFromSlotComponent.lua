--- @class HCSelectFromSlotComponent: HumanControllerComponent
HCSelectFromSlotComponent = class(HumanControllerComponent)

function HCSelectFromSlotComponent:onClick(card, slot)
    --- @type SelectFromSlotDecision
    local sel_ph = ph

    if slot ~= sel_ph.slot then
        info("%s selected %d from %s - invalid slot (needed to be %s)", self.side.id, card.uid, slot, sel_ph.slot)
    elseif not sel_ph.cb(card) then
        info("%s selected %d from %s - forbidden by cardspec", self.side.id, card.uid, slot)
    else
        info("%s selected %d from %s, %d left", self.side.id, card.uid, slot, sel_ph.amount - 1)
        sel_ph.amount = sel_ph.amount - 1
        if sel_ph.amount <= 0 then
            info("Corp finished selecting cards")
            return self:handled()
        else
            return true
        end
    end
end

function HCSelectFromSlotComponent:onCancel()
    info("%s cancelled select from slot", self.side.id)
    return self:handled()
end