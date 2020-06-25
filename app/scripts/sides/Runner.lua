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
        memory = 4,
        recurring = {}
    })
end

--- @param amount number
function Runner:alterTags(amount)
    self.tags = self.tags + amount
end

function Runner:isTagged()
    return self.tags > 0
end

--- @param amount number
function Runner:damage(amount)
    local size = board:count(SLOT_RUNNER_HAND)
    if size < amount then
        game:endInFavor(SIDE_CORP)
        return
    end

    for _ = 0, amount do
        self:discard(board:cardGet(SLOT_RUNNER_HAND, math.random(0, size)))
        size = size - 1
    end
end

--- @param amount number
function Runner:brainDamage(amount)
    self:damage(amount)
    self.max_hand = self.max_hand - 1
end

--- @param amount number
function Runner:netDamage(amount)
    self:damage(amount)
end

--- @param amount number
function Runner:meatDamage(amount)
    self:damage(amount)
end

function Runner:newTurn()
    Side.newTurn(self)

    self.recurring = {
        credits_for_icebreakers = 0,
        credits_for_virus_or_icebreakers = 0,
    }
end

--- @param card Card
function Runner:scoreAgenda(card)
    game.runner:alterScore(card.meta.info.agenda_points)
    card.faceup = true
    card.meta.rezzed = false
    board:cardAppend(SLOT_RUNNER_SCORE, card)
    ui:cardInstalled(card, SLOT_RUNNER_SCORE)
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

--- @param card Card
--- @param from string
--- @param to string
--- @param suppress_events boolean
--- @param discount number - or + amount
function Runner:actionInstall(card, from, to, suppress_events, discount)
    assert(card)
    assert(from)
    assert(to)
    discount = discount or 0

    if card.meta:isCardConsole() and to ~= SLOT_RUNNER_CONSOLE then
        return false
    end

    if card.meta:isCardProgram() and (to ~= SLOT_RUNNER_PROGRAMS or self.memory < card.meta.info.memory_cost) then
        return false
    end

    if card.meta:isCardResource() and to ~= SLOT_RUNNER_RESOURCES then
        return false
    end

    if self:spendCredits(card.meta.info.cost + discount) then
        card.faceup = true
        card.meta.rezzed = true

        local existing_card = board:cardGet(to, 0)
        if to == SLOT_RUNNER_CONSOLE and existing_card then
            board:cardReplace(to, existing_card, card)
            existing_card.meta:onRemoval(existing_card)
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
            card.meta:onInstall(card)
        end
        ui:cardInstalled(card, to)
        return true
    end

    return false
end

--- @param breaker_card Card
--- @param breaker_meta CardMeta
--- @param ice_meta CardMeta
--- @return boolean
function Runner:actionBreakIce(breaker_card, breaker_meta, ice_meta)
    local breaker_strength = breaker_meta.info.strength
    local ice_strength = ice_meta.info.strength

    for t in breaker_meta:modificationsIter() do
        if t.additional_strength then
            breaker_strength = breaker_strength + t.additional_strength
        end
    end

    for t in ice_meta:modificationsIter() do
        if t.additional_strength then
            ice_strength = ice_strength + t.additional_strength
        end
    end

    if breaker_strength >= ice_strength and breaker_meta:onBreakIce(ice_meta) then
        breaker_meta:onUse(breaker_card)
        return true
    else
        return false
    end
end
