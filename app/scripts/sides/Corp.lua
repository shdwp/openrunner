--- @class Corp: Side
--- @field bad_publicity number
Corp = class("Corp", Side)

--- @param state GameState
--- @return Corp
function Corp:New(state)
    return construct(self, Side:New(state, SIDE_CORP, 3), {
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
    local deck = self.state.board:deckAt(SLOT_CORP_RND)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = Db:card(card_info.uid)
        self.state.board:append(SLOT_CORP_HAND, card)
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
        price = self.state.board:count(to)
    end

    if self:spendCredits(price + discount, SPENDING_INSTALL) then
        local existing_card = self.state.board:cardAt(to)
        if isSlotRemote(to) and existing_card then
            self.state.board:replace(existing_card, card)
        else
            self.state.board:append(to, card)
        end

        if not suppress_events then
            card.meta:onInstall(self.state, card)
        end

        self.state.board:pop(card)
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

    if not card.meta:canAdvance(self.state, card) then
        info("cardspec forbids advance!")
        return false
    end

    if card.meta:onAdvance(self.state, card) and self:spendCredits(free and 0 or 1, SPENDING_ADVANCE) then
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
    
    if (card.meta.adv or 0) < (card.meta.info.advancement_cost or INFINITE) then
        return false
    end

    if card.meta:onScore(self.state, card) then
        card.meta.rezzed = true
        card.faceup = true
        self.state.board:move(card, SLOT_CORP_SCORE)

        self:alterScore(card.meta.info.agenda_points)
        self.state.last_agenda_scored_turn_n = self.state.turn_n
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

    if card.meta:onRez(self.state, card) and self:payPrice(card.meta, SPENDING_ICE_REZ, discount) then
        self:rez(card)
        return true
    end

    return false
end
