playerui = {
    event = nil,
    last_update = 0,
    alert_until = 0,
}

function playerui:reset()
    self.event = nil
    verbose("interaction finished")

    if game.corp.clicks <= 0 then
        info("turn finished")
        game:sideEndedTurn()
    end

    self.last_update = 0
end

function playerui:onTick(dt)
    local update = true
    if Input:keyPressed(61) then
        game.corp:alterCredits(1)
    elseif Input:keyPressed(45) then
        game.corp:alterCredits(-1)
    elseif Input:keyPressed(48) then
        game.corp:alterClicks(1)
    elseif Input:keyPressed(57) then
        game.corp:alterClicks(-1)
    else
        update = false
    end

    if update then self.last_update = 0 end
end

