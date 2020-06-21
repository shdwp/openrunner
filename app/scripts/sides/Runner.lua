--- @class Runner: Side
--- @field tags number
--- @field memory number
--- @field link number
--- @field meat_damage number
--- @field brain_damage number
--- @field recurring table
Runner = class("Runner", Side)
print(Side)

--- @return Runner
function Runner:New()
    return construct(self, Side:New(SIDE_RUNNER, 4), {
        tags = 0,
        link = 1,
        meat_damage = 0,
        brain_damage = 0,
        memory = 4,
        recurring = {}
    })
end

--- @param amount number
function Runner:alterTags(amount)
    self.tags = self.tags + amount
end

--- @param amount number
function Runner:alterBrainDamage(amount)
    self.brain_damage = self.brain_damage + amount
end

--- @param amount number
function Runner:alterMeatDamage(amount)
    self.meat_damage = self.meat_damage + amount
end

function Runner:newTurn()
    Side.newTurn(self)

    self.recurring = {
        credits_for_icebreakers = 0,
        credits_for_virus_or_icebreakers = 0,
    }
end

--- @param strength number
--- @return boolean
function Runner:trace(strength)
    return self.link < strength
end

function Runner:actionDrawCard()
    local deck = board:deckGet(SLOT_RUNNER_STACK, 0)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = Db:card(card_info.uid)
        board:cardAppend(SLOT_RUNNER_HAND, card)
    end
end

function Runner:actionInstall(card, from, to, suppress_events)
    assert(card)
    assert(from)
    assert(to)

    if card.meta:isCardConsole() and to ~= SLOT_RUNNER_CONSOLE then
        return false
    end

    if card.meta:isCardProgram() and (to ~= SLOT_RUNNER_PROGRAMS or self.memory < card.meta.info.memory_cost) then
        return false
    end

    if card.meta:isCardResource() and to ~= SLOT_RUNNER_RESOURCES then
        return false
    end

    if self:spendCredits(card.meta.info.cost) then
        card.faceup = true
        card.meta.rezzed = true

        local existing_card = board:cardGet(to, 0)
        if to == SLOT_RUNNER_CONSOLE and existing_card then
            board:cardReplace(to, existing_card, card)
            existing_card.meta:onRemoval()
        else
            board:cardAppend(to, card)
        end

        if to == SLOT_RUNNER_PROGRAMS then
            self.memory = self.memory - 1
        end

        board:cardPop(from, card)
        if suppress_events == true then
            info("onInstall() suppressed due to suppress_events")
        else
            card.meta:onInstall()
        end
        ui:cardInstalled(card, to)
        return true
    end

    return false
end

--- @param breaker CardMeta
--- @param ice CardMeta
--- @return boolean
function Runner:actionBreakIce(breaker, ice)
    local breaker_strength = breaker.info.strength
    local ice_strength = ice.info.strength

    for t in breaker:modificationsIter() do
        if t.additional_strength then
            breaker_strength = breaker_strength + t.additional_strength
        end
    end

    for t in ice:modificationsIter() do
        if t.additional_strength then
            ice_strength = ice_strength + t.additional_strength
        end
    end

    if breaker_strength >= ice_strength and breaker:onBreakIce(ice) then
        breaker:onUse()
        return true
    else
        return false
    end
end
