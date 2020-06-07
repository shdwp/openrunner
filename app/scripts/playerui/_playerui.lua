playerui = {
    event = nil,
    last_update = 0,
    alert_until = 0,
}

function playerui:_isRemoteSlot(slot)
    return starts_with(slot, "corp_remote_") and not ends_with(slot, "_ice")
end

function playerui:_isRemoteIceSlot(slot)
    return starts_with(slot, "corp_remote_") and ends_with(slot, "_ice")
end

function playerui:reset()
    self.event = nil
    host:verbose("interaction finished")

    if game.corp.clicks <= 0 then
        host:info("turn finished")
        game:sideEndedTurn()
    end

    self.last_update = 0
end

function playerui:onTick(dt)
    local update = true
    if host:keyPressed(61) then
        game.corp:alterCredits(1)
    elseif host:keyPressed(45) then
        game.corp:alterCredits(-1)
    elseif host:keyPressed(48) then
        game.corp:alterClicks(1)
    elseif host:keyPressed(57) then
        game.corp:alterClicks(-1)
    else
        update = false
    end

    if update then self.last_update = 0 end
end

