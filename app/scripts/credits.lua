--- @class Bank
Bank = class("RecurringCredits")

function Bank:New()
    return construct(self, {
        CREDITS_GENERAL = 0,
    })
end

--- @param category string
--- @param spending string
--- @return boolean
function Bank:_isCategoryApplicable(category, spending)
    if category == CREDITS_FOR_ICEBREAKERS_OR_VIRUS then
        return string.starts_with(spending, "icebreaker.")
    elseif category == CREDITS_FOR_ICEBREAKERS then
        return string.starts_with(spending, "icebreaker.")
    elseif category == CREDITS_FOR_BAD_PUBLICITY then
        return true
    elseif category == CREDITS_GENERAL then
        return true
    end
end

--- @param category string
--- @return boolean
function Bank:count(category)
    category = category or CREDITS_GENERAL

    local total = 0
    for k, v in pairs(self) do
        if self:_isCategoryApplicable(category, k) then
            total = total + v
        end
    end

    return total
end

--- @param category string
--- @param amount number
--- @return boolean
function Bank:credit(category, amount)
    self[category] = (self[category] or 0) + amount
end

--- @param category string
--- @param amount number
function Bank:debit(category, amount)
    assert(self:count(category) > amount)

end

-- creds
CREDITS_FOR_ICEBREAKERS = "icebreaker"
CREDITS_FOR_ICEBREAKERS_OR_VIRUS = "icebreaker_or_virus"
CREDITS_FOR_BAD_PUBLICITY = "bad_publicity"
CREDITS_GENERAL = "general"

SPENDING_ICEBRBREAKER_POWERUP = "icebreaker.powerup"
SPENDING_ICEBREAKER_BREAK = "icebreaker.break"
SPENDING_ICE_REZ = "ice.rez"
SPENDING_INVOLUNTARY = "involuntary"
SPENDING_TRASHING = "trashing"
SPENDING_INSTALL = "install"
SPENDING_ADVANCE = "advance"
SPENDING_EVENT = "event"

function isSpendingApplicable(credits_category, spending_category)
end
