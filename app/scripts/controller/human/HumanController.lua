--- @class HumanController: PlayerController
--- @field components table<number, HumanControllerComponent>
HumanController = class(PlayerController)

--- @param side_id string
--- @return HumanController
function HumanController:New(side_id)
    local t = construct(self, PlayerController:New(side_id), {
        last_update = 0,
    })

    if side_id == SIDE_CORP then
        t.components = {
            HCDrawCardComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isPlayDeckSlot, false),
            HCGetCreditComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isCreditsPoolSlot, false),
            HCPlayCardComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isHandSlot, true),

            HCAdvanceCardComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isSlotInstallable, true),
            HCAdvanceCardComponent:New(t, SIDE_CORP, FreeAdvanceDecision.Type, isSlotInstallable, true),

            HCInstallCardComponent:New(t, SIDE_CORP, InstallDecision.Type, isSlotInstallable, false),
            HCInstallCardComponent:New(t, SIDE_CORP, DiscountedInstallDecision.Type, isSlotInstallable, false),
            HCSelectFromDeckComponent:New(t, SIDE_CORP, SelectFromDeckDecision.Type, nil, true),
            HCSelectFromSlotComponent:New(t, SIDE_CORP, SelectFromSlotDecision.Type, nil, true),

            HCTurnEndDiscardComponent:New(t, SIDE_CORP, HandDiscardDecision.Type, isHandSlot, true),

            HCScoreCardComponent:New(t, nil, nil, isSlotRemote, true),
            HCRezCardComponent:New(t, SIDE_CORP, RunIceRezDecision.Type, isSlotIce, true, true),
            HCRezCardComponent:New(t, SIDE_CORP, nil, isSlotInstallable, true, false),
        }
    else
        t.components = {
            HCDrawCardComponent:New(t, SIDE_RUNNER, TurnBaseDecision.Type, isPlayDeckSlot, false),
            HCGetCreditComponent:New(t, SIDE_RUNNER, TurnBaseDecision.Type, isCreditsPoolSlot, false),
            HCPlayCardComponent:New(t, SIDE_RUNNER, TurnBaseDecision.Type, isHandSlot, true),

            HCInstallCardComponent:New(t, SIDE_RUNNER, InstallDecision.Type, isSlotInstallable, false),
            HCInstallCardComponent:New(t, SIDE_RUNNER, DiscountedInstallDecision.Type, isSlotInstallable, false),

            HCSelectFromDeckComponent:New(t, SIDE_RUNNER, SelectFromDeckDecision.Type, nil, true),
            HCSelectFromSlotComponent:New(t, SIDE_RUNNER, SelectFromSlotDecision.Type, nil, true),

            HCInitiateRunComponent:New(t, SIDE_RUNNER, TurnBaseDecision.Type, isSlotRemote, true),
            HCApproachIceComponent:New(t, SIDE_RUNNER, RunIceApproachDecision.Type, isSlotIce, true),

            HCTurnEndDiscardComponent:New(t, SIDE_RUNNER, HandDiscardDecision.Type, isHandSlot, true),
        }
    end

    return t
end

function HumanController:handle(phase)
    PlayerController.handle(self, phase)

    if phase.type == SelectFromDeckDecision.Type then
        --- @type SelectFromDeckDecision
        local ph = phase

        local deck = board:deckGet(ph.slot, 0)
        card_select_widget:setDeck(deck, ph.limit)
        card_select_widget.hidden = false
    elseif phase.type == HandDiscardDecision.Type then
        phase.amount = board:count(sideHandSlot(self.side.id)) - self.side.max_hand
        if phase.amount <= 0 then
            self:handled()
        end
    end
end

function HumanController:onTick(dt)
    if self:active() and dt - self.last_update > 1 then
        if self.side.id == SIDE_CORP then
            status_label:setText(string.format(
                    "%s, cl%d, cr%d, sc%d, bp%d",
                    self.phase.type,
                    game.decision_stack:countClicks(self.side.id),
                    game.corp.credits,
                    game.corp.score,
                    game.corp.bad_publicity
            ))
        else
            status_label:setText(string.format(
                    "%s, cl%d, cr%d, rcr%d, sc%d, tag%d, mem%d",
                    self.phase.type,
                    game.decision_stack:countClicks(self.side.id),
                    self.side.credits,
                    game.runner.recurring.credits_for_icebreakers,
                    self.side.score,
                    game.runner.tags,
                    game.runner.memory
            ))
        end

        self.last_update = dt
    end

    if self:active() then
        local update = true
        if Input:keyPressed(61) then
            self.side:alterCredits(1)
        elseif Input:keyPressed(45) then
            self.side:alterCredits(-1)
        elseif Input:keyPressed(48) then
            game:alterClicks(self.side.id, 1)
        elseif Input:keyPressed(57) then
            self.side:alterClicks(self.side.id, -1)
        else
            update = false
        end

        if update then self.last_update = 0 end
    end
end

function HumanController:interaction(type, descr)
    self.last_update = 0

    local result
    for _, comp in pairs(self.components) do
        local does_require_card = comp.requireCard == true
        local does_restrict_slot = comp.restrictSlot ~= nil

        local side_matches = not comp.side or comp.side.id == self.side.id
        local phase_matches = not comp.phaseType or self.phase and comp.phaseType == self.phase.type
        local slot_matches = type == "cancel" or not does_restrict_slot or comp.restrictSlot(descr.slot)
        local card_req_matches = type == "cancel" or (descr.card and does_require_card) or not (descr.card and does_require_card)

        if side_matches and phase_matches and slot_matches and card_req_matches then
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
        info("No component of %s to handle decision: %s %s", self.side.id, type, interaction_descr)
        return false
    else
        return true
    end
end
