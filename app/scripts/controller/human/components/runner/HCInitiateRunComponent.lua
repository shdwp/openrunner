--- @class HCInitiateRunComponent: HumanControllerComponent
HCInitiateRunComponent = class(HumanControllerComponent)

function HCInitiateRunComponent:onClick(card, slot)
     game.decision_stack:push(RunAccessDecision:New(SIDE_RUNNER, card))

    iterCards(iceSlotOfRemote(slot), function (card)
        print(card)
        game.decision_stack:push(RunIceRezDecision:New(SIDE_CORP, card))
        game.decision_stack:push(RunIceApproachDecision:New(SIDE_RUNNER, card))
    end)

    return self:handled()
end

