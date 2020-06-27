--- @class HumanController: PlayerController
--- @field components table<number, HumanControllerComponent>
HumanController = class("HumanController", PlayerController)

--- @param side_id string
--- @return HumanController
function HumanController:New(side_id)
    local t = construct(self, PlayerController:New(side_id), {
        last_update = 0,
    })

    t.components = {}

    if side_id == SIDE_CORP then
        table.array_concat(t.components, {
            HCAdvanceCardComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isSlotInstallable, true),
            HCAdvanceCardComponent:New(t, SIDE_CORP, FreeAdvanceDecision.Type, isSlotInstallable, true),

            HCScoreCardComponent:New(t, SIDE_CORP, nil, isSlotRemote, true),

            HCRezCardComponent:New(t, SIDE_CORP, TurnBaseDecision.Type, isSlotInstallable, true),
            HCRezCardComponent:New(t, SIDE_CORP, RunIceRezDecision.Type, isSlotInstallable, true),
        })
    elseif side_id == SIDE_RUNNER then
        table.array_concat(t.components, {
            HCInitiateRunComponent:New(t, SIDE_RUNNER, TurnBaseDecision.Type, isSlotRunnable, true),
            HCApproachIceComponent:New(t, SIDE_RUNNER, RunIceApproachDecision.Type, isSlotIce, true),
            HCSubroutBreakComponent:New(t, SIDE_RUNNER, RunSubroutBreakDecision.Type, function (c) return c == SLOT_RUNNER_PROGRAMS end, true),
            HCRunAccessComponent:New(t, SIDE_RUNNER, RunAccessDecision.Type, nil, true),
        })
    end

    table.array_concat(t.components, {
        HCDrawCardComponent:New(t, side_id, TurnBaseDecision.Type, isPlayDeckSlot, false),
        HCGetCreditComponent:New(t, side_id, TurnBaseDecision.Type, isCreditsPoolSlot, false),
        HCPlayCardComponent:New(t, side_id, TurnBaseDecision.Type, isHandSlot, true),
        HCCardActionComponent:New(t, side_id, TurnBaseDecision.Type, nil, true),

        HCInstallCardComponent:New(t, side_id, InstallDecision.Type, isSlotInstallable, false),
        HCInstallCardComponent:New(t, side_id, DiscountedInstallDecision.Type, isSlotInstallable, false),

        HCSelectFromDeckComponent:New(t, side_id, SelectFromDeckDecision.Type, nil, true),
        HCSelectFromSlotComponent:New(t, side_id, SelectFromSlotDecision.Type, nil, true),
        HCSelectFromOptionsComponent:New(t, side_id, SelectFromOptionsDecision.Type, nil, false),

        HCTurnEndDiscardComponent:New(t, side_id, HandDiscardDecision.Type, isHandSlot, true),
    })

    return t
end

--- @param ignore_slot_card boolean
--- @param fn fun(comp: HumanControllerComponent): boolean
function HumanController:_matchComponent(ignore_slot_card, slot, card, fn)
    for _, comp in pairs(self.components) do
        local does_require_card = comp.requireCard == true
        local does_restrict_slot = comp.restrictSlot ~= nil

        local side_matches = comp.side == nil or (self.decision and comp.side.id == self.decision.side.id)
        local phase_matches = not comp.supportedDecisionType or self.decision and comp.supportedDecisionType == self.decision.type
        local slot_matches = ignore_slot_card or not does_restrict_slot or (slot ~= nil and comp.restrictSlot(slot))
        local card_req_matches = ignore_slot_card or (card and does_require_card) or ((not card) and (not does_require_card))

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
        if Input:keyPressed(KeyCode.EQUAL) then
            self.side:alterCredits(1)
        elseif Input:keyPressed(KeyCode.MINUS) then
            self.side:alterCredits(-1)
        elseif Input:keyPressed(KeyCode.N0) then
            game:alterClicks(self.side.id, 1)
        elseif Input:keyPressed(KeyCode.N9) then
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
        if descr and descr.type == "OptionInteractable" then
            result = comp:onOptionSelect(type, descr.option)
        elseif type == INTERACTION_PRIMARY then
            result = comp:onPrimary(descr.card, descr.slot)
        elseif type == INTERACTION_SECONDARY then
            result = comp:onSecondary(descr.card, descr.slot)
        elseif type == INTERACTION_TERTIARY then
            result = comp:onTertiary(descr.card, descr.slot)
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
