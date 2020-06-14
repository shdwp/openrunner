cardspec = {

}

function cardspec:_spec(meta)
    local t = meta.info.type_code

    if t == "agenda" then
        return agendas[meta.info.code]
    elseif t == "operation" then
        return operations[meta.info.code]
    elseif t == "asset" then
        return assets[meta.info.code]
    end
end

function cardspec:canAdvance(meta)
    if meta.info.type_code == "agenda" then
        return true
    else
        return false
    end
end

function cardspec:interactionFromHand(meta)
    local t = meta.info.type_code
    if t == "agenda" or t == "asset" or t == "ice" then
        return "install"
    elseif t == "operation" then
        return "play"
    end
end

function cardspec:interactionFromTable(meta)
    local t = meta.info.type_code
    if t == "agenda" then
        return "score"
    elseif t == "asset" then
        return "rez"
    end
end

-- cans

function cardspec:canAction(meta)
    local spec = self:_spec(meta)
    return spec.canAction and spec.canAction(meta)
end

function cardspec:canPlay(meta)
    local spec = self:_spec(meta)
    return spec.canPlay == nil or spec.canPlay(meta)
end

function cardspec:canInstall(meta)
    return self:isCardRemote(meta) or self:isCardIce(meta)
end

--- @param meta userdata
--- @param slot string
--- @return boolean
function cardspec:canInstallTo(meta, slot)
    if not self:canInstall(meta) then
        return false
    end

    if meta.info.type_code == "ice" then
        return isSlotIce(slot)
    else
        return isSlotRemote(slot)
    end
end

function cardspec:isCardRemote(meta)
    return meta.info.type_code == "asset" or meta.info.type_code == "agenda"
end

function cardspec:isCardIce(meta)
    return meta.info.type_code == "ice"
end

-- events

function cardspec:onRez(meta)
    local spec = self:_spec(meta)
    if spec.onRez then return spec.onRez(meta) end
end

function cardspec:onPlay(meta)
    local spec = self:_spec(meta)
    if spec.onPlay then return spec.onPlay(meta) end
end

function cardspec:onAction(meta)
    local spec = self:_spec(meta)
    return spec.onAction(meta)
end

function cardspec:onScore(meta)
    local spec = self:_spec(meta)
    return spec.onScore(meta)
end

function cardspec:onNewTurn(meta)
    local spec = self:_spec(meta)
    if spec and spec.onNewTurn then return spec.onNewTurn(meta) end
end
