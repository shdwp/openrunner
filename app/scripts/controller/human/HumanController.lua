--- @class HumanController: PlayerController
--- @field components table<number, HumanControllerComponent>
HumanController = class("HumanController", PlayerController)

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

            HCRezCardComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isSlotInstallable, true),
            HCRezCardComponent:New(t, SIDE_CORP, RunIceRezDecision.Type, isSlotInstallable, true),
        }
    elseif side_id == SIDE_RUNNER then
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
            HCSubroutBreakComponent:New(t, SIDE_RUNNER, RunSubroutBreakDecision.Type, function (c) return c == SLOT_RUNNER_PROGRAMS end, true),
            HCRunAccessComponent:New(t, SIDE_RUNNER, RunAccessDecision.Type, nil, true),

            HCTurnEndDiscardComponent:New(t, SIDE_RUNNER, HandDiscardDecision.Type, isHandSlot, true),
        }
    end

    return t
end

--- @param ignore_slot_card boolean
--- @param fn fun(comp: HumanControllerComponent): boolean
function HumanController:_matchComponent(ignore_slot_card, slot, card, fn)
    for _, comp in pairs(self.components) do
        local does_require_card = comp.requireCard == true
        local does_restrict_slot = comp.restrictSlot ~= nil

        local side_matches = not comp.side or (self.decision and comp.side.id == self.decision.side.id)
        local phase_matches = not comp.supportedDecisionType or self.decision and comp.supportedDecisionType == self.decision.type
        local slot_matches = ignore_slot_card or not does_restrict_slot or comp.restrictSlot(slot)
        local card_req_matches = ignore_slot_card or (card and does_require_card) or not (card and does_require_card)

        --print(comp.phaseType, comp.side.id, side_matches, comp.phaseType, phase_matches, "slot", slot_matches, "card_req", card_req_matches)
        if side_matches and phase_matches and slot_matches and card_req_matches then
            comp.decision = self.decision;
            if fn(comp) then
                return
            end

            comp.decision = nil
        end
    end
end

function HumanController:handle(decision)
    PlayerController.handle(self, decision)

    self:_matchComponent(true, nil, nil, function (comp)
        info("Decision %s matched to component %s", decision, comp)
        comp:onNewDecision()
    end)
end

function HumanController:onTick(dt)
    if self:active() and dt - self.last_update > 1 then
        if self.side.id == SIDE_CORP then
            status_label:setText(string.format(
                    "%s, cl%d, cr%d, sc%d, bp%d",
                    self.decision.type,
                    game.decision_stack:countClicks(self.side.id),
                    game.corp.credits,
                    game.corp.score,
                    game.corp.bad_publicity
            ))
        else
            status_label:setText(string.format(
                    "%s, cl%d, cr%d, rcr%d/%d, sc%d, tag%d, mem%d",
                    self.decision.type,
                    game.decision_stack:countClicks(self.side.id),
                    self.side.credits,
                    game.runner.recurring.credits_for_icebreakers,
                    game.runner.recurring.credits_for_virus_or_icebreakers,
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
    local interaction_descr = type == INTERACTION_CANCEL and "" or string.format("%s (%s)", descr.slot, descr.card)

    local slot = descr and descr.slot
    local card = descr and descr.card
    self:_matchComponent(type == INTERACTION_CANCEL, slot, card, function (comp)
        info("Component of %s handling %s, passed event %s (%s) to %s", self.side.id, comp.decision, type, interaction_descr, comp)
        if type == INTERACTION_PRIMARY then
            result = comp:onPrimary(descr.card, descr.slot)
        elseif type == INTERACTION_SECONDARY then
            result = comp:onSecondary(descr.card, descr.slot)
        elseif type == INTERACTION_CANCEL then
            result = comp:onCancel()
        end

        return result
    end)

    if not result then
        info("No component of %s to handle decision %s interaction %s %s", self.side.id, self.decision, type, interaction_descr)
        return false
    else
        return true
    end
end
