--- @class AIController: PlayerController
--- @field paths table<number, table<number, AIAction>>
AIController = class("AIController", PlayerController)

function AIController:New(state, side_id)
    return construct(self, PlayerController:New(state, side_id), {
        paths = {},
    })
end

--- @param state AIState
--- @param actions table<number, AIAction>
--- @param path table<number, AIAction>
function AIController:_calculateScores(state, actions, path)
    if state.gameState.stack:size() == 0 then
        info("Finalized branch %s: ", table.concat(table.map(path, tostring), " "))
        local score = state:calculateScore()
        self.paths[score] = path
        info("------------------------------")
        info(" ")
        return
    else
        for _, action in pairs(actions) do
            local updated_state = state:clone()
            local updated_actions = clone(actions)
            local updated_branch = clone(path)

            action:handle(updated_state.gameState.stack:top(), updated_state, updated_actions)
            print("updated stack size ", #updated_state.gameState.stack.stack)
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
        local ai_state = self.state:viewlessDeepcopy()

       local available_actions = {
            AIDrawCardAction:New(),
            AIGainCreditAction:New(),
        }

        self:_calculateScores(AIState:New(ai_state), available_actions, {})

        local max_key = MINUS_INFINITE
        local max_path = nil
        for k, v in pairs(self.paths) do
            if k >= max_key then
                max_key = k
                max_path = v
            end
        end

        print("Min path is: ", inspect(table.map(max_path, tostring)));
    end
end

function AIController:handle(decision)
end
