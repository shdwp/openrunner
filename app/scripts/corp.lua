inspect = dofile(libpath .. "inspect.lua/inspect.lua")

Corp = {}

function Corp.new()
    local table = {
        max_clicks = 4,
        clicks = 4,
        points = 0,
        credits = 12,
    }

    setmetatable(table, {__index = Corp})
    return table
end

function Corp.spendClick(self)
    if self.clicks > 0 then
        self.clicks = self.clicks - 1
        return true
    else
        return false
    end
end

function Corp.spendCredits(self, amount)
    if self.credits > amount then
        self.credits = self.credits - amount
        return true
    else
        return false
    end
end

function Corp.drawCard(self)
    local deck = board:deckGet("corp_rnd", 0)
    if deck.size > 0 then
        local card_info = deck:takeTop()
        local card = db:card(card_info.uid)
        board:cardAppend("corp_hand", card)
    else
        game:halt("CORP_RUN_OUT_OF_RND")
    end
end

function Corp.actionDrawCard(self)
    if self:spendClick() then
        self:drawCard()
    end
end

function Corp.actionInstallRemote(self, card, from, to)
    if self:spendClick() then
        board:cardPop(from, card)
        card.faceup = false
        card.meta["adv"] = 0
        board:cardAppend(to, card)
    end
end

function Corp.actionRez(self, card, from)
    if self:spendCredits(card.meta["info"]["cost"]) then
        card.faceup = true
    end
end

function Corp.actionAdvance(self, card, from)
    if self:spendCredits(1) and self:spendClick() then
        local info = card.meta["info"]
        card.meta["adv"] = card.meta["adv"] + 1
        if info["type_code"] == "agenda" then
            local op = agendas[card.uid]
            if card.meta["adv"] > info["advancement_cost"] then
                op.onScore()
                self.score = self.score + info["agenda_points"]
                board:cardPop(from, card)
            end
        end
    end
end

function Corp.actionOperation(self, card, from)
    local op = operations[card.uid]
    if op.canPlay == nil or op.canPlay() then
        if self:spendClick() then
            if op.onPlay() then op.onPlay() end
            board:cardPop(from, card)
        end
    end
end