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
        HCDrawCardComponent:New(t, SIDE_CORP, TurnBasePhase.Type, isPlayDeckSlot, false),
        HCPlayCardComponent:New(t, SIDE_CORP, TurnBasePhase.Type, isHandSlot, true),

        HCAdvanceCardComponent:New(t, SIDE_CORP, TurnBasePhase.Type, isSlotInstallable, true),

        HCInstallCardComponent:New(t, SIDE_CORP, InstallPhase.Type, isSlotInstallable, false),
        HCInstallCardComponent:New(t, SIDE_CORP, FreeInstallPhase.Type, isSlotInstallable, false),
        HCSelectFromDeckComponent:New(t, SIDE_CORP, SelectFromDeckPhase.Type, nil, true),
        HCSelectFromSlotComponent:New(t, SIDE_CORP, SelectFromSlotPhase.Type, nil, true),

        HCTurnEndDiscardComponent:New(t, SIDE_CORP, HandDiscardPhase.Type, isHandSlot, true),
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
    elseif phase.type == HandDiscardPhase.Type then

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

    local result
    for _, comp in pairs(self.components) do
        local does_require_card = comp.requireCard == true
        local does_restrict_slot = comp.restrictSlot ~= nil

        local phase_matches = comp.phaseType == self.phase.type
        local slot_matches = type == "cancel" or not does_restrict_slot or comp.restrictSlot(descr.slot)
        local card_req_matches = type == "cancel" or (descr.card and does_require_card) or not (descr.card and does_require_card)

        if phase_matches and slot_matches and card_req_matches then
            comp.phase = self.phase
            if type == "click" then
                result = comp:onClick(descr.card, descr.slot)
            elseif type == "altclick" then
                result = comp:onAltClick(descr.card, descr.slot)
            elseif type == "cancel" then
                result = comp:onCancel()
            end

            if result == true then
                break
            end
        end
    end

    if not result then
        local interaction_descr = type == "cancel" and "" or string.format("%s (%s)", descr.slot, descr.card)
        info("No component to handle interaction: %s %s", type, interaction_descr)
    end
end
