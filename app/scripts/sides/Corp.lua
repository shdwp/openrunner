--- @class Corp: Side
--- @field bad_publicity number
Corp = class("Corp", Side)

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
    local deck = board:deckGet(SLOT_CORP_RND, 0)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = Db:card(card_info.uid)
        board:cardAppend(SLOT_CORP_HAND, card)
    end
end

--- @param card Card
function Corp:rez(card)
    card.meta.rezzed = true
    card.faceup = true
end

function Corp:actionDrawCard()
    self:drawCard()
    return true
end

--- @param card Card
--- @param from string
--- @param to string
--- @param suppress_events boolean
--- @param discount number - or + amount
--- @return boolean
function Side:actionInstall(card, from, to, suppress_events, discount)
    assert(card)
    assert(from)
    assert(to)
    discount = discount or 0

    if card.meta:isIce() and not isSlotIce(to) then
        return false
    end

    if card.meta:isInstalledInServer() and not isSlotRemote(to) then
        return false
    end

    card.faceup = false
    card.meta.adv = 0

    local price = 0
    if card.meta:isIce() then
        price = board:count(to)
    end

    if self:spendCredits(price + discount, SPENDING_INSTALL) then
        local existing_card = board:cardGet(to, 0)
        if isSlotRemote(to) and existing_card then
            board:cardReplace(to, existing_card, card)
        else
            board:cardAppend(to, card)
        end

        if not suppress_events then
            card.meta:onInstall(card)
        end

        board:cardPop(from, card)
        return true
    else
        return false
    end
end

--- @param card Card
--- @param from string
--- @param free boolean
--- @return boolean
function Corp:actionAdvance(card, from, free)
    assert(card)

    if not card.meta:canAdvance(card) then
        info("cardspec forbids advance!")
        return false
    end

    if card.meta:onAdvance(card) and self:spendCredits(free and 0 or 1, SPENDING_ADVANCE) then
        card.meta.adv = (card.meta.adv or 0) + 1
        return true
    else
        return false
    end
end

--- @param card Card
--- @param from string
--- @return boolean
function Corp:actionScore(card, from)
    assert(card)

    if (card.meta.adv or 0) >= (card.meta.info.advancement_cost or INFINITE) and card.meta:onScore(card) then
        card.meta.rezzed = true
        card.faceup = true
        board:cardMove(card, SLOT_CORP_SCORE)

        self:alterScore(card.meta.info.agenda_points)
        game.last_agenda_scored_turn_n = game.turn_n
        return true
    end

    return false
end

--- @param card Card
--- @param from string
--- @param discount number
--- @return boolean
function Corp:actionRez(card, from, discount)
    discount = discount or 0

    if not card then
        return false
    end

    if card.meta.rezzed then
        return false
    end

    if card.meta:onRez(card) and self:payPrice(card.meta, SPENDING_ICE_REZ, discount) then
        self:rez(card)
        return true
    end

    return false
end
