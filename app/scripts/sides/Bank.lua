--- @class Bank
--- @field recurring table<string, number>
--- @field ordered_categories table<number, string>
Bank = class("RecurringCredits")

function Bank:New()
    return construct(self, {
        ordered_categories = {
            CREDITS_FOR_ICEBREAKERS_OR_VIRUS,
            CREDITS_FOR_ICEBREAKERS,
            CREDITS_FOR_BAD_PUBLICITY,
            CREDITS_GENERAL
        },
        recurring = {},
        CREDITS_GENERAL = 5,
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

--- @param category_or_amount string|number
--- @param amount number
--- @return boolean
function Bank:credit(category_or_amount, amount)
    local category = category_or_amount
    if amount == nil then
        category = CREDITS_GENERAL
        amount = category_or_amount
    end
    
    self[category] = (self[category] or 0) + amount
end

--- @param spending_category string
--- @param amount number
function Bank:debit(spending_category, amount)
    assert(amount ~= 0)
    
    if self:count(spending_category) < amount then
        return false
    end
    
    for _, category in pairs(self.ordered_categories) do
        if self:_isCategoryApplicable(category, spending_category) then
            local count = self[category] or 0
            if count ~= 0 then
                amount = amount - count
                
                if amount < 0 then
                    self[category] = -amount
                    break
                else
                    self[category] = 0
                end
            end
        end
    end
    
    return true
end

function Bank:addRecurring(category, amount)
    self.recurring[category] = (self.recurring[category] or 0) + amount
end

function Bank:subtractRecurring(category, amount)
    self.recurring[category] = (self.recurring[category] or 0) + amount
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
