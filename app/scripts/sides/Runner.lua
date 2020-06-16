--- @class Runner: Side
--- @field tags number
--- @field memory number
--- @field link number
--- @field meat_damage number
--- @field brain_damage number
--- @field recurring table
Runner = class(Side)
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
        local card = cardspec:card(card_info.uid)
        board:cardAppend(SLOT_RUNNER_HAND, card)
    end
end

function Runner:actionInstall(card, from, to)
    assert(card)
    assert(from)
    assert(to)

    if cardspec:isCardConsole(card.meta) and to ~= SLOT_RUNNER_CONSOLE then
        return false
    end

    if cardspec:isCardProgram(card.meta) and (to ~= SLOT_RUNNER_PROGRAMS or self.memory < card.meta.info.memory_cost) then
        return false
    end

    if cardspec:isCardResource(card.meta) and to ~= SLOT_RUNNER_RESOURCES then
        return false
    end

    if self:spendCredits(card.meta.info.cost) then
        card.faceup = true

        local existing_card = board:cardGet(to, 0)
        if to == SLOT_RUNNER_CONSOLE and existing_card then
            board:cardReplace(to, existing_card, card)
            cardspec:onRemoval(existing_card.meta)
        else
            board:cardAppend(to, card)
        end

        if to == SLOT_RUNNER_PROGRAMS then
            self.memory = self.memory - 1
        end

        board:cardPop(from, card)
        cardspec:onInstall(card.meta)
        ui:cardInstalled(card, to)
        return true
    end

    return false
end
