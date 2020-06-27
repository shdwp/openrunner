--- @class AIController: PlayerController
AIController = class("AIController", PlayerController)

function AIController:New(side_id)
    return construct(self, PlayerController:New(side_id), {

    })
end

function AIController:newTurn(side)
    if side == self.side.id then
        local state = AIState:New(game.decision_stack:countClicks(self.side.id))
        print(state:calculateScore())
    end
end

function AIController:handle(decision)
end
