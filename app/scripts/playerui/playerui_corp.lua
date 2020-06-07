playerui_corp = {
}

function playerui_corp:onInit()
    setmetatable(playerui_corp, {__index = playerui})

    self:reset()
end

function playerui_corp:onTick(dt)
    playerui.onTick(self, dt)

    if dt - self.last_update > 1 then
        status_label:setText(string.format(
                "cl%d, cr%d, s%d, b%d",
                game.corp.clicks,
                game.corp.credits,
                game.corp.score,
                game.corp.bad_publicity
        ))

        if self.alert_until > dt then
            host:verbose("Alert expired")
            alert_label:setText("")
        end

        self.last_update = dt
    end
end

function playerui_corp:onInteraction (event, itr)
    if game.turn ~= "corp" then
        return
    end

    if event == "click" then
        if itr.slot == "corp_rnd" then
            host:verbose("corp click on draw card")
            game.corp:actionDrawCard()
            return self:reset()

        elseif itr.slot == "corp_hand" then
            local intr = cardspec:interactionFromHand(itr.card.meta)
            host:verbose()
            if intr == "install" then
                self.event = itr
            elseif intr == "play" then
                game.corp:actionOperation(itr.card, itr.slot)
                return self:reset()
            end

        elseif self.event and self:_isRemoteSlot(itr.slot) then
            local card = self.event.card
            if card then
                game.corp:actionInstallRemote(card, self.event.slot, itr.slot)
            end
            return self:reset()

        elseif self:_isRemoteSlot(itr.slot) then
            if itr.card == nil then
                return self:reset()
            end

            local i = cardspec:interactionFromTable(itr.card.meta)
            if i == "score" then
                game.corp:actionScore(itr.card, itr.slot)
            elseif i == "rez" then
                game.corp:actionRez(itr.card, itr.slot)
            end
            return self:reset()
        end

        self.event = itr
    elseif event == "altclick" then
        if self:_isRemoteSlot(itr.slot) then
            game.corp:actionAdvance(itr.card, itr.slot)
            return self:reset()
        end
    end
end
