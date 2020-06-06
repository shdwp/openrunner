ui = {
    event = {}
}

function ui._isRemoteSlot(self, slot)
    return starts_with(slot, "corp_remote_") and not ends_with(slot, "_ice")
end

function ui._isRemoteIceSlot(self, slot)
    return starts_with(slot, "corp_remote_") and ends_with(slot, "_ice")
end

function ui.reset(self)
    self.event = {}
    status_label:setText(string.format("clicks %d, creds %d", game.corp.clicks, game.corp.credits))
end

function ui.onInteraction (self, event, itr)
    if event ~= "click" and event ~= "altclick" then
        return
    end

    if itr.slot == "corp_rnd" then
        game.corp:actionDrawCard()
        return self:reset()

    elseif itr.slot == "corp_hand" then
        local t = itr.card.meta["info"]["type_code"]
        if t == "asset" or t == "agenda" then
            self.event = itr
        elseif t == "operation" then
            game.corp:actionOperation(itr.card, itr.slot)
            return self:reset()
        end

    elseif self:_isRemoteSlot(itr.slot) then
        local card = self.event.card
        if card then
            game.corp:actionInstallRemote(card, self.event.slot, itr.slot)
        end
        return self:reset()

    end

    self.event = itr
end
