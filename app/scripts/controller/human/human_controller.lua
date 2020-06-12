--- @class HumanController: PlayerController
HumanController = class(PlayerController)

--- @return HumanController
function HumanController:New()
    return construct(self, PlayerController:New(), {
        last_update = 0,
        alert_until = 0,
    })
end

function HumanController:handle(phase)
    PlayerController.handle(self, phase)

    if phase.type == SelectFromDeckPhase.Type then
        --- @type SelectFromDeckPhase
        local ph = phase

        local deck = board:deckGet(ph.slot, 0)
        card_select_widget:setDeck(deck, ph.limit)
        card_select_widget.hidden = false
    end
end

function HumanController:onTick(dt)
    if dt - self.last_update > 1 then
        status_label:setText(string.format(
                "%s, cl%d, cr%d, s%d, b%d",
                self.phase.type,
                game:countClicks(SIDE_CORP),
                game.corp.credits,
                game.corp.score,
                game.corp.bad_publicity
        ))

        if self.alert_until > dt then
            verbose("Alert expired")
            alert_label:setText("")
        end

        self.last_update = dt
    end

    local update = true
    if Input:keyPressed(61) then
        game.corp:alterCredits(1)
    elseif Input:keyPressed(45) then
        game.corp:alterCredits(-1)
    elseif Input:keyPressed(48) then
        game:alterClicks(SIDE_CORP, 1)
    elseif Input:keyPressed(57) then
        game.corp:alterClicks(SIDE_CORP, -1)
    else
        update = false
    end

    if update then self.last_update = 0 end
end

--- @param type string
--- @param descr SlotInteractable
function HumanController:onInteraction(type, descr)
    self.last_update = 0

    if type == "click" and descr.card and isSlotRemote(descr.slot) then
        local i = cardspec:interactionFromTable(descr.card.meta)
        if i == "score" then
            game.corp:actionScore(descr.card, descr.slot)
        elseif i == "rez" then
            game.corp:actionRez(descr.card, descr.slot)
        end
    end

    if not self:active() then
        return
    end

    local ph = self.phase
    if ph.side == SIDE_CORP then
        if ph.type == TurnBasePhase.Type then
            if type == "click" then
                if descr.slot == SLOT_CORP_RND then
                    info("Corp draw card")
                    game.corp:actionDrawCard()
                    return self:handled()

                elseif descr.slot == SLOT_CORP_HAND then
                    local card_play_type = cardspec:interactionFromHand(descr.card.meta)
                    if card_play_type == "install" then
                        info("Corp installing %s", descr.card.uid)
                        game:pushPhase(InstallPhase:New(ph.side, descr.slot, descr.card))
                        return self:delegated()
                    elseif card_play_type == "play" and game.corp:actionOperation(descr.card, descr.slot) then
                        info("Corp played %s", descr.card.uid)
                        return self:handled()
                    else
                        error("Uknown play type %s", card_play_type)
                    end
                end
            elseif type == "altclick" then
                if isSlotRemote(descr.slot) and game.corp:actionAdvance(descr.card, descr.slot) then
                    return self:handled()
                end
            end

        elseif ph.type == InstallPhase.Type then
            if type == "click" then
                if isSlotRemote(descr.slot) then
                    if game.corp:actionInstallRemote(ph.card, ph.slot, descr.slot) then
                        return self:handled(2)
                    else
                        info("Corp failed to actionInstallRemote")
                    end
                else
                    info("Invalid slot for install %s", descr.slot)
                end
            elseif type == "cancel" then
                return self:handled()
            end
        elseif ph.type == SelectFromDeckPhase.Type then
            --- @type SelectFromDeckPhase
            local sel_ph = ph
            local deck = board:deckGet(sel_ph.slot, 0)
            if type == "click" and descr.card then
                info("Corp selected %d, %d left", descr.card.uid, sel_ph.amount - 1)
                if sel_ph.cb(descr.card) then
                    sel_ph.amount = sel_ph.amount - 1
                    card_select_widget:removeCard(descr.card)
                    deck:erase(descr.card)

                    if sel_ph.amount <= 0 then
                        info("Corp finished selecting cards")
                        card_select_widget.hidden = true
                        return self:handled()
                    end
                end
            end
        elseif ph.type == SelectFromStackPhase.Type then
            --- @yype SelectFromStackPhase
            local sel_ph = ph

        end
    end
end
