--- @class AIController: PlayerController
--- @field paths table<number, table<number, AIAction>>
AIController = class("AIController", PlayerController)

function AIController:New(side_id)
    return construct(self, PlayerController:New(side_id), {
        paths = {},
    })
end

--- @param state AIState
--- @param actions table<number, AIAction>
--- @param path table<number, AIAction>
function AIController:_calculateScores(state, actions, path)
    if state.clicks <= 0 then
        info("Finalized branch %s: ", table.concat(table.map(path, tostring), " "))
        local score = state:calculateScore()
        self.paths[score] = path
        info("------------------------------")
        info(" ")
        return
    else
        for _, action in pairs(actions) do
            local updated_state = state:clone()
            local updated_actions = table.shallowcopy(actions)
            local updated_branch = table.shallowcopy(path)

            action:alterState(updated_state, updated_actions)
            table.insert(updated_branch, action)
            if not updated_state.valid then
                break
            end

            self:_calculateScores(updated_state, updated_actions, updated_branch)
        end
    end
end

function AIController:newTurn(side)
    if side == self.side.id then
        local clicks = game.decision_stack:countClicks(self.side.id)

        local available_actions = {
            AIDrawCardAction:New(),
            AIGainCreditAction:New(),
        }

        for c in cardsIter(sideHandSlot(self.side.id)) do
            table.insert(available_actions, AIPlayCardAction:New(c.meta))
        end

        self:_calculateScores(AIState:New(clicks), available_actions, {})

        local max_key = MINUS_INFINITE
        local max_path = nil
        for k, v in pairs(self.paths) do
            if k >= max_key then
                max_key = k
                max_path = v
            end
        end

        print("Min path is: %s", inspect(table.map(max_path, tostring)));
    end
end

function AIController:handle(decision)
end
