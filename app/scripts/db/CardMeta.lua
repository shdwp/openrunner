--- @class CardMeta
--- @field card Card
--- @field info CardInfo
--- @field rezzed boolean
--- @field until_forever table
--- @field until_turn_end table
--- @field until_run_end table
--- @field until_encounter_end table
--- @field until_use table
CardMeta = class("CardMeta")

--- @param info CardInfo
--- @return CardMeta
function CardMeta:New(info)
    return construct(self, {
        info = info,

        rezzed = false,
        until_turn_end = {},
        until_run_end = {},
        until_forever = {},
        until_encounter_end = {},
        until_use = {},
    })
end

--- @return CardMeta
function CardMeta:clone()
    return copy(CardMeta, self)
end

function CardMeta:debugDescription()
    return "uid " .. self.info.code .. " of " .. self.info.type_code
end

--- @param state GameState
--- @param card Card
--- @return Ctx
function CardMeta:_ctx(state, card)
    return Ctx:New(state, card)
end

--- @return string
function CardMeta:interactionFromHand()
    local t = self.info.type_code
    if t == "agenda" or t == "asset" or t == "ice" or t == "resource" or t == "hardware" or t == "program" then
        return CI_INSTALL
    elseif t == "operation" or t == "event" then
        return CI_PLAY
    end
end

--- @return string
function CardMeta:interactionFromBoard()
    if self:isAgenda() then
        return CI_SCORE
    elseif self:isAsset() or self:isIce() then
        return CI_REZ
    end
end

--- @return string
function CardMeta:interactionFromRunAccess()
    if self:isAgenda() then
        return CI_SCORE
    elseif self.info.trash_cost then
        return CI_TRASH
    end
end

--- @return boolean
function CardMeta:isInstalledInServer()
    return self.info.type_code == "asset" or self.info.type_code == "agenda"
end

--- @return boolean
function CardMeta:isIce()
    return self.info.type_code == "ice"
end

--- @return boolean
function CardMeta:isAsset()
    return self.info.type_code == "asset"
end

--- @return boolean
function CardMeta:isAgenda()
    return self.info.type_code == "agenda"
end

--- @return boolean
function CardMeta:isIcebreaker()
    return self:keywordsInclude({"Icebreaker"})
end

--- @return boolean
function CardMeta:isProgram()
    return self.info.type_code == "program"
end

--- @return boolean
function CardMeta:isHardware()
    return self.info.type_code == "hardware"
end

--- @return boolean
function CardMeta:isResource()
    return self.info.type_code == "resource"
end

--- @return boolean
function CardMeta:isConsole()
    return self.info.type_code == "hardware" and self.info.keywords == "Console"
end

--- @param kws table<number, string>
--- @return boolean
function CardMeta:keywordsInclude(kws)
    local str = self.info.keywords
    for _, kw in pairs(kws) do
        print(str, string.find(str, kw))
        if string.find(str, kw) ~= nil then
            return true
        end

        local result = false
        for t in self:modificationsIter() do
            if t.additional_keywords and string.find(t.additional_keywords, kw) ~= nil then
                result = true
            end
        end

        if result then
            return true
        end
    end

    return false
end

--- @return number
function CardMeta:advancementProgress()
    if not self.adv or self.adv == 0 then
        return 0
    end

    return self.adv / (self.info.advancement_cost or 1)
end

--- @return fun(): string, fun()
function CardMeta:subroutinesReversedIter()
    local i = #self.info.subroutines + 1

    return function ()
        i = i - 1
        if i > 0 then
            return self.info.subroutine_descriptions[i], self.info.subroutines[i]
        end
    end
end

--- @return fun(): table
function CardMeta:modificationsIter()
    local i = 0
    return function ()
        i = i + 1

        if i == 1 then
            return self.until_forever
        elseif i == 2 then
            return self.until_turn_end
        elseif i == 3 then
            return self.until_run_end
        elseif i == 4 then
            return self.until_use
        elseif i == 5 then
            return self.until_encounter_end
        else
            return nil
        end
    end
end

-- predicates

--- @param state GameState
--- @param card Card
--- @return boolean
function CardMeta:canAdvance(state, card)
    if self.info.type_code == "agenda" then
        return true
    elseif self.info.canBeAdvanced and self.info.canBeAdvanced(self:_ctx(state, card)) then
        return true
    end
end

--- @param state GameState
--- @return boolean
function CardMeta:canAction()
    if self.info.canAction then
        return self.info.canAction(state, self:_ctx())
    else
        return self.info.onAction ~= nil
    end
end

--- @return boolean
function CardMeta:canPowerUp()
    return self.info.onPowerUp ~= nil
end

--- @param state GameState
--- @return boolean
function CardMeta:canPlay(state, card)
    return self.info.canPlay == nil or self.info.canPlay(self:_ctx(state, card))
end

--- @return boolean
function CardMeta:canInstall()
    return self:isInstalledInServer() or self:isIce()
end

--- @param state GameState
--- @param card Card
--- @param sacrificed_for Card
--- @param slot string
--- @return boolean
function CardMeta:canBeSacrificed(state, card, sacrificed_for, slot)
    return self.info.canBeSacrificed and self.info.canBeSacrificed(self:_ctx(state, card), sacrificed_for, slot) or false
end

--- @param state GameState
--- @param card Card
--- @param meta CardMeta
--- @return boolean
function CardMeta:onBreakIce(state, card, meta)
    return self.info.onBreakIce(self:_ctx(state, card), meta)
end

--- @param state GameState
--- @param card Card
--- @param slot string
--- @return boolean
function CardMeta:canInstallTo(state, card, slot)
    if not self:canInstall(self:_ctx(state, card)) then
        return false
    end

    if self.info.type_code == "ice" then
        return isSlotIce(slot)
    else
        return isSlotRemote(slot)
    end
end

-- events

--- @param state GameState
--- @param card CardMeta
--- @return boolean
function CardMeta:onRez(state, card)
    if self.info.onRez then
        return self.info.onRez(self:_ctx(state, card))
    else
        return true
    end
end

--- @param eventid string
--- @param state GameState
--- @param card Card
--- @return boolean
function CardMeta:_callEventHandler(eventid, state, card)
    local fn = self.info[eventid]

    local default_values = {
        ["onAction"] = false,
        ["onPowerUp"] = false,

        ["_"] = true,
    }

    if fn == nil then
        local default = default_values[eventid]
        if default ~= nil then
            return default
        else
            return default_values["_"]
        end
    else
        return fn(self:_ctx(state, card))
    end
end

function CardMeta:onPlay(state, card) return self:_callEventHandler("onPlay", state, card) end
function CardMeta:onAction(state, card) return self:_callEventHandler("onAction", state, card) end
function CardMeta:onInstall(state, card) return self:_callEventHandler("onInstall", state, card) end
function CardMeta:onRemoval(state, card) return self:_callEventHandler("onRemoval", state, card) end
function CardMeta:onScore(state, card) return self:_callEventHandler("onScore", state, card) end
function CardMeta:onPowerUp(state, card) return self:_callEventHandler("onPowerUp", state, card) end
function CardMeta:onAdvance(state, card) return self:_callEventHandler("onAdvance", state, card) end

function CardMeta:onNewTurn(state, card)
    self.until_turn_end = {}
    return self:_callEventHandler("onNewTurn", state, card)
end

function CardMeta:onUse(state, card)
    self.until_use = {}
end

function CardMeta:onRunEnd(state, card)
    self.until_run_end = {}
    return self:_callEventHandler("onRunEnd", state, card)
end

function CardMeta:onEncounterStart(state, card)
    return self:_callEventHandler("onIceEncounterStart", state, card)
end

function CardMeta:onEncounterEnd(state, card)
    self.until_encounter_end = {}
    return self:_callEventHandler("onIceEncounterEnd", state, card)
end

function CardMeta:onSubroutineResolution(state, fn)
    fn(self:_ctx(state, nil))
end
