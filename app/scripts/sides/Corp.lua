--- @class Corp: Side
--- @field bad_publicity number
Corp = class(Side)

--- @return Corp
function Corp:New()
    return construct(self, Side:New(SIDE_CORP, 3), {
        bad_publicity = 0
    })
end

--- @param amount number
function Corp:alterBadPublicity(amount)
    self.bad_publicity = self.bad_publicity + amount
end

function Corp:newTurn()
    Side.newTurn(self)
    self:drawCard()
end

function Corp:drawCard()
    local deck = board:deckGet("corp_rnd", 0)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = cardspec:card(card_info.uid)
        board:cardAppend("corp_hand", card)
    end
end

function Corp:actionDrawCard()
    self:drawCard()
    return true
end

--- @param card Card
--- @param from string
--- @param to string
--- @return boolean
function Corp:actionInstallRemote(card, from, to)
    if not card then
        return false
    end

    card.faceup = false
    card.meta.adv = 0
    local existing_card = board:cardGet(to, 0)
    if existing_card then
        board:cardReplace(to, existing_card, card)
    else
        board:cardAppend(to, card)
    end

    board:cardPop(from, card)
    return true
end

--- @param card Card
--- @param from string
--- @param to string
--- @return boolean
function Corp:actionInstallIce(card, from, to)
    assert(card)
    assert(isSlotIce(to))

    local count = board:count(to)
    if self:spendCredits(count) then
        card.faceup = false
        board:cardAppend(to, card)
        board:cardPop(from, card)

        ui:iceCardInstalled(card, to)
        return true
    end

    return false
end

--- @param card userdata Card
--- @param from string
--- @param free boolean
--- @return boolean
function Corp:actionAdvance(card, from, free)
    if not card then
        return false
    end

    if not cardspec:canAdvance(card.meta) then
        info("cardspec forbids advance!")
        return false
    end

    if card.meta.adv >= card.meta.info.advancement_cost then
        return false
    elseif self:spendCredits(free and 0 or 1) then
        card.meta.adv = card.meta.adv + 1
        return true
    else
        return false
    end
end

--- @param card userdata Card
--- @param from string
--- @return boolean
function Corp:actionScore(card, from)
    if not card then
        return false
    end

    if card.meta.adv >= card.meta.info.advancement_cost then
        cardspec:onScore(card.meta)
        board:cardPop(from, card)
        game.last_agenda_scored_turn_n = game.turn_n
        return true
    end

    return false
end

--- @param card userdata Card
--- @param from string
--- @return boolean
function Corp:actionRez(card, from)
    if not card then
        return false
    end

    if card.faceup then
        return false
    end

    if self:payPrice(card.meta) then
        cardspec:onRez(card.meta)
        card.faceup = true
        return true
    end

    return false
end
