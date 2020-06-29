--- @class game
--- @field state GameState
--- @field current_side string
--- @field player_controllers table<number, PlayerController>
game = {
    player_controllers = {},
    ui_focused = nil,
    last_ui_update = 0,
}

--- @param player string const
--- @return PlayerController
function game:controllerFor(player)
    return self.player_controllers[player]
end

function game:cycle()
    info("Game cycle")
    for _, c in pairs(self.player_controllers) do
        c:clear()
    end

    local decision = self.state.stack:top()
    if self.ui_focused ~= decision.side.id then
        self.ui_focused = decision.side.id
        ui:focusCurrentPlayer()
    end
    
    if decision.type == TurnBaseDecision.Type then
        self.state:save()
    end

    local ctrl = self:controllerFor(decision.side.id)
    ctrl:handle(decision)
end

function game:newTurn()
    for _, c in pairs(self.player_controllers) do
        c:newTurn(self.state.current_side)
    end
end

function game:onInit()
    info("Game init")
    self.state = GameState:New(EngineGameBoardView:New(board))
    
    self.player_controllers[SIDE_CORP] = AIController:New(self.state, SIDE_CORP)
    self.player_controllers[SIDE_RUNNER] = HumanController:New(self.state, SIDE_RUNNER)

    host:register(self.player_controllers[SIDE_CORP])
    host:register(self.player_controllers[SIDE_RUNNER])
    
    if host.meta.current_side then
        self.state:load()
    else
        self.state:testState()
    end
    
    info("Game ready!")
    dbg()
    self.state:cycle()
end

function game:onTick(dt)
    if dt - self.last_ui_update > 1 then
        local text = ""
        for _, v in pairs(self.state.stack.stack) do
            text = string.format("%s\n%s %s", text, v.side.id, v.type)
        end

        alert_label:setText(text)
        self.last_ui_update = dt
    end
end

function game:onInteraction(type, descr)
    for _, ctrl in pairs(self.player_controllers) do
        if ctrl:interaction(type, descr) then
            break
        end
    end

    self.last_ui_update = 0
end

host:register(game)
