--- @class Runner: Side
--- @field tags number
--- @field memory number
--- @field link number
--- @field meat_damage number
--- @field brain_damage number
--- @field recurring table
Runner = class("Runner", Side)

--- @param state GameState
--- @return Runner
function Runner:New(state)
    return construct(self, Side:New(state, SIDE_RUNNER, 4), {
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
    local size = self.state.board:count(SLOT_RUNNER_HAND)
    if size < amount then
        self.state:endInFavor(SIDE_CORP)
        return
    end

    for _ = 0, amount do
        self:discard(self.state.board:get(SLOT_RUNNER_HAND, math.random(0, size)))
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

function Runner:alterCredits(amount, category)
    for k, v in pairs(self.recurring) do
        if isSpendingApplicable(k, category) then
            amount = amount + v
            if amount >= 0 then
                self.recurring[k] = amount
                amount = 0
                break
            end
        end
    end
end

function Runner:alterMemory(amount)
    self.memory = self.memory + amount
end

function Runner:alterLink(amount)
    self.link = self.link + amount
end

function Runner:newTurn()
    Side.newTurn(self)

    self.recurring = {
        credits_for_icebreakers = 0,
        credits_for_virus_or_icebreakers = 0,
        credits_for_bad_publicity = 0,
    }
end

function Runner:onRunStart()
    self.recurring.credits_for_bad_publicity = self.state.corp.bad_publicity
end

function Runner:onRunEnd()
    self.recurring.credits_for_bad_publicity = 0
end

--- @param card Card
function Runner:scoreAgenda(card)
    self:alterScore(card.meta.info.agenda_points)
    card.faceup = true
    card.meta.rezzed = false
    self.state.board:append(SLOT_RUNNER_SCORE, card)
end

--- @param strength number
--- @return boolean
function Runner:trace(strength)
    return self.link < strength
end

function Runner:actionDrawCard()
    local deck = self.state.board:deck(SLOT_RUNNER_STACK)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = Db:card(card_info.uid)
        self.state.board:append(SLOT_RUNNER_HAND, card)
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

    if card.meta:isConsole() and to ~= SLOT_RUNNER_CONSOLE then
        return false
    end

    if card.meta:isProgram() and (to ~= SLOT_RUNNER_PROGRAMS or self.memory < card.meta.info.memory_cost) then
        return false
    end

    if card.meta:isResource() and to ~= SLOT_RUNNER_RESOURCES then
        return false
    end

    if self:spendCredits(card.meta.info.cost + discount, SPENDING_INSTALL) then
        card.faceup = true
        card.meta.rezzed = true

        local existing_card = self.state.board:card(to)
        if to == SLOT_RUNNER_CONSOLE and existing_card then
            self.state.board:replace(existing_card, card)
            existing_card.meta:onRemoval(self.state, existing_card)
        else
            self.state.board:append(to, card)
        end

        if to == SLOT_RUNNER_PROGRAMS then
            self.memory = self.memory - 1
        end

        self.state.board:pop(card)
        if suppress_events == true then
            info("onInstall() suppressed due to suppress_events")
        else
            card.meta:onInstall(self.state, card)
        end
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

    if breaker_strength >= ice_strength and breaker_meta:onBreakIce(self.state, breaker_card, ice_meta) then
        breaker_meta:onUse(self.state, breaker_card)
        return true
    else
        return false
    end
end
