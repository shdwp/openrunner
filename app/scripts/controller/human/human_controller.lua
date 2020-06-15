--- @class HumanControllerComponent
--- @field side Side
--- @field phaseType string
--- @field restrictSlot function
--- @field requireCard boolean
HumanControllerComponent = class()

function HumanControllerComponent:New(side, phaseType, restrictSlot, requireCard)
    return construct(self, {
        side = side == SIDE_CORP and game.corp or game.runner,
        phaseType = phaseType,
        restrictSlot = restrictSlot,
        requireCard = requireCard and requireCard or false,
    })
end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onClick(card, slot) return false end

--- @param card Card
--- @param slot string
--- @return boolean
function HumanControllerComponent:onAltClick(card, slot) return false end

--- @return boolean
function HumanControllerComponent:onCancel() return false end

--- @class HumanController: PlayerController
--- @field components table<number, HumanControllerComponent>
HumanController = class(PlayerController)

--- @param side string
--- @return HumanController
function HumanController:New(side)
    local t = construct(self, PlayerController:New(side), {
        last_update = 0,
    })

    t.components = {
        HumanControllerDrawCardComponent(SIDE_CORP, TurnBasePhase.Type, isPlayDeckSlot, false),
        HumanControllerPlayCardComponent(SIDE_CORP, TurnBasePhase.Type, isHandSlot, true),
        HumanControllerAdvanceCardComponent(SIDE_CORP, TurnBasePhase.Type, isSlotRemote, true),

        HumanControllerInstallCardComponent(SIDE_CORP, InstallPhase.Type, isSlotInstallable, false),
    }

    return t
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
    if dt - self.last_update > 1 and self.phase then
        status_label:setText(string.format(
                "%s, cl%d, cr%d, s%d, b%d",
                self.phase.type,
                game:countClicks(SIDE_CORP),
                game.corp.credits,
                game.corp.score,
                game.corp.bad_publicity
        ))

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

    for _, comp in pairs(self.components) do
        if comp.phaseType == self.phase.type and comp.restrictSlot(descr.slot) then
            local card_required = comp.requireCard

            if descr.card and card_required or not descr.card and not card_required then
                if type == "click" then
                    comp:onClick(descr.card, descr.slot)
                elseif type == "altclick" then
                    comp:onClick(descr.card, descr.slot)
                elseif type == "cancel" then
                    comp:onCancel()
                end
            end
        end
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
                    elseif card_play_type == "play" then
                        if game.corp:payOperation(descr.card, descr.slot) then
                            info("Corp played %s", descr.card.uid)
                            game.corp:actionOperation(descr.card, descr.slot)
                            return self:handled()
                        else
                            info("Corp unable to pay for %d", descr.card.uid)
                        end
                    else
                        error("Unknown play type %s", card_play_type)
                    end
                end
            elseif type == "altclick" then
                if descr.card and game.corp:actionAdvance(descr.card, descr.slot, false) then
                    info("Corp advanced %d from %s", descr.card.uid, descr.slot)
                    return self:handled()
                end
            end

        elseif ph.type == InstallPhase.Type then
            if type == "click" then
                if cardspec:canInstallTo(ph.card.meta, descr.slot) then
                    local handled = false
                    if cardspec:isCardRemote(ph.card.meta) then
                        handled = game.corp:actionInstallRemote(ph.card, ph.slot, descr.slot)
                    else
                        handled = game.corp:actionInstallIce(ph.card, ph.slot, descr.slot)
                    end

                    if handled then
                        return self:handled(2)
                    else
                        info("Corp failed to install card %d into %s", ph.card.uid, descr.slot)
                    end
                else
                    info("Invalid slot for install %s", descr.slot)
                end
            elseif type == "cancel" then
                info("Corp cancelled install")
                return self:handled()
            end
        elseif ph.type == FreeInstallPhase.Type then
            if type == "click" then
                if isSlotRemote(descr.slot) then
                    if game.corp:actionInstallRemote(ph.card, ph.slot, descr.slot) then
                        return self:handled()
                    else
                        info("Corp failed to actionInstallRemote")
                    end
                else
                    info("Invalid slot for install %s", descr.slot)
                end
            elseif type == "cancel" then
                info("Corp cancelled free installation")
                return self:handled()
            end
        elseif ph.type == FreeAdvancePhase.Type then
            if type == "altclick" then
                print(1)
                if descr.card and ph.cb(descr.card) then
                    info("Corp selected %d from %s for free advance", descr.card.uid, descr.slot)
                    if game.corp:actionAdvance(descr.card, descr.slot, true) then
                        info("Corp free advanced %d", descr.card.uid)
                        return self:handled()
                    end
                end
            elseif type == "cancel" then
                info("Corp cancelled free advance")
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
            elseif type == "cancel" then
                info("Corp cancelled select from deck")
                card_select_widget.hidden = true
                return self:handled()
            end
        elseif ph.type == SelectFromSlotPhase.Type then
            --- @type SelectFromSlotPhase
            local sel_ph = ph
            if type == "click" and descr.card then
                if descr.slot ~= sel_ph.slot then
                    info("Corp selected %d from %s - invalid slot (needed to be %s)", descr.card.uid, descr.slot, sel_ph.slot)
                elseif not sel_ph.cb(descr.card) then
                    info("Corp selected %d from %s - forbidden by cardspec", descr.card.uid, descr.slot)
                else
                    info("Corp selected %d from %s, %d left", descr.card.uid, descr.slot, sel_ph.amount - 1)
                    sel_ph.amount = sel_ph.amount - 1
                    if sel_ph.amount <= 0 then
                        info("Corp finished selecting cards")
                        return self:handled()
                    end
                end
            elseif type == "cancel" then
                info("Corp cancelled select from slot")
                return self:handled()
            end
        elseif ph.type == TurnEndPhase.Type then
            print(descr.card)
            print(descr.slot)
            if type == "click" and descr.card and descr.slot == SLOT_CORP_HAND then
                game.corp:actionDiscard(descr.card, descr.slot)
                info("Corp discarded %d", descr.card.uid)
                ph.amount = ph.amount - 1
                if ph.amount <= 0 then
                    info("Corp finished discarding cards")
                    return self:handled()
                end
            end
        end
    end
end
