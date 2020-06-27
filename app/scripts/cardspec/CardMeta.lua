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

function CardMeta:debugDescription()
    return "uid " .. self.info.code .. " of " .. self.info.type_code
end

--- @param card Card
--- @return Ctx
function CardMeta:_ctx(card)
    return Ctx:New(
            game.decision_stack:top(),
            self,
            card
    )
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

--- @param card Card
--- @return boolean
function CardMeta:canAdvance(card)
    if self.info.type_code == "agenda" then
        return true
    elseif self.info.canBeAdvanced and self.info.canBeAdvanced(self:_ctx(card)) then
        return true
    end
end
--- @return boolean
function CardMeta:canAction()
    if self.info.canAction then
        return self.info.canAction(self:_ctx())
    else
        return self.info.onAction ~= nil
    end
end

--- @return boolean
function CardMeta:canPowerUp()
    return self.info.onPowerUp ~= nil
end

--- @return boolean
function CardMeta:canPlay()
    return self.info.canPlay == nil or self.info.canPlay(self:_ctx())
end

--- @return boolean
function CardMeta:canInstall()
    return self:isInstalledInServer() or self:isIce()
end

function CardMeta:canBeSacrificed(card, slot)
    return self.info.canBeSacrificed and self.info.canBeSacrificed(self:_ctx(), card, slot) or false
end

--- @param meta CardMeta
--- @return boolean
function CardMeta:onBreakIce(meta)
    return self.info.onBreakIce(self:_ctx(), meta)
end

--- @param slot string
--- @return boolean
function CardMeta:canInstallTo(slot)
    if not self:canInstall(self:_ctx()) then
        return false
    end

    if self.info.type_code == "ice" then
        return isSlotIce(slot)
    else
        return isSlotRemote(slot)
    end
end

-- events

function CardMeta:onRez(card)
    if self.info.onRez then
        return self.info.onRez(self:_ctx(card))
    else
        return true
    end
end

function CardMeta:_callEventHandler(eventid, card)
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
        return fn(self:_ctx(card))
    end
end

function CardMeta:onPlay(card) return self:_callEventHandler("onPlay", card) end
function CardMeta:onAction(card) return self:_callEventHandler("onAction", card) end
function CardMeta:onInstall(card) return self:_callEventHandler("onInstall", card) end
function CardMeta:onRemoval(card) return self:_callEventHandler("onRemoval", card) end
function CardMeta:onScore(card) return self:_callEventHandler("onScore", card) end
function CardMeta:onPowerUp(card) return self:_callEventHandler("onPowerUp", card) end
function CardMeta:onAdvance(card) return self:_callEventHandler("onAdvance", card) end

function CardMeta:onNewTurn(card)
    self.until_turn_end = {}
    return self:_callEventHandler("onNewTurn", card)
end

function CardMeta:onUse(card)
    self.until_use = {}
end

function CardMeta:onRunEnd(card)
    self.until_run_end = {}
    return self:_callEventHandler("onRunEnd", card)
end

function CardMeta:onEncounterStart(card)
    return self:_callEventHandler("onIceEncounterStart")
end

function CardMeta:onEncounterEnd(card)
    self.until_encounter_end = {}
    return self:_callEventHandler("onIceEncounterEnd")
end
