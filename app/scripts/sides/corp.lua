--- @class Corp: Side
--- @field bad_publicity number
Corp = class(Side)

--- @return Corp
function Corp:New()
    return construct(self, Side:New(3), {
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
        local card = db:card(card_info.uid)
        board:cardAppend("corp_hand", card)
    end
end

function Corp:actionDrawCard()
    if self:spendClick() then
        self:drawCard()
    end
end

--- @param card userdata Card
--- @param from string
--- @param to string
function Corp:actionInstallRemote(card, from, to)
    if self:spendClick() then
        card.faceup = false
        card.meta.adv = 0
        board:cardAppend(to, card)

        board:cardPop(from, card)
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionAdvance(card, from)
    if not cardspec:canAdvance(card.meta) then
        info("cardspec forbids advance!")
        return false
    end

    if self:spendCredits(1) and self:spendClick() then
        card.meta.adv = card.meta.adv + 1
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionScore(card, from)
    if card.meta.adv >= card.meta.info.advancement_cost then
        cardspec:onScore(card.meta)
        board:cardPop(from, card)
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionRez(card, from)
    if self:payPrice(card.meta) then
        cardspec:onRez(card.meta)
        card.faceup = true
    end
end

--- @param card userdata Card
--- @param from string
function Corp:actionOperation(card, from)
    if not cardspec:canPlay(card.meta) then
        return
    end

    if self:payPrice(card.meta) and self:spendClick() then
        cardspec:onPlay(card.meta)
        board:cardPop(from, card)
    end
end