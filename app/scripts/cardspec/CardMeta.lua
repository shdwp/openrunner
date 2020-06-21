--- @class CardMeta
--- @field card Card
--- @field info CardInfo
--- @field rezzed boolean
--- @field discard boolean
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

        discard = false,
        rezzed = false,
        until_turn_end = {},
        until_run_end = {},
        until_forever = {},
        until_encounter_end = {},
        until_use = {},
    })
end

--- @param card Card
--- @return Ctx
function CardMeta:_ctx()
    return Ctx:New(
            game.decision_stack:top(),
            self
    )
end

--- @return string
function CardMeta:interactionFromHand()
    local t = self.info.type_code
    if t == "agenda" or t == "asset" or t == "ice" or t == "resource" or t == "hardware" or t == "program" then
        return "install"
    elseif t == "operation" or t == "event" then
        return "play"
    end
end

--- @return string
function CardMeta:interactionFromBoard()
    local t = self.info.type_code
    if t == "agenda" then
        return "score"
    elseif t == "asset" then
        return "rez"
    elseif t == "ice" then
        return "rez"
    end
end

--- @return boolean
function CardMeta:isCardRemote()
    return self.info.type_code == "asset" or self.info.type_code == "agenda"
end

--- @return boolean
function CardMeta:isCardIce()
    return self.info.type_code == "ice"
end

--- @return boolean
function CardMeta:isCardIcebreaker()
    return self.info.type_code == "icebreaker"
end

--- @return boolean
function CardMeta:isCardProgram()
    return self.info.type_code == "program"
end

--- @return boolean
function CardMeta:isCardHardware()
    return self.info.type_code == "hardware"
end

--- @return boolean
function CardMeta:isCardResource()
    return self.info.type_code == "resource"
end

--- @return boolean
function CardMeta:isCardConsole()
    return self.info.type_code == "hardware" and self.info.keywords == "Console"
end

--- @return boolean
function CardMeta:isCardAgenda()
    return self.info.type_code == "agenda"
end

--- @param kws table<number, string>
--- @return boolean
function CardMeta:keywordsInclude(kws)
    local str = self.info.keywords
    for _, kw in pairs(kws) do
        if string.find(str, kw) then
            return true
        end

        local result = false
        for t in self:modificationsIter() do
            if string.find(t.additional_keywords, kw) then
                result = true
            end
        end

        if result then
            return true
        end
    end

    return false
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

        if i == 0 then
            return self.until_forever
        elseif i == 1 then
            return self.until_turn_end
        elseif i == 2 then
            return self.until_turn_end
        elseif i == 3 then
            return self.until_use
        elseif i == 4 then
            return self.until_encounter_end
        else
            return nil
        end
    end
end

-- predicates

--- @return boolean
function CardMeta:canAdvance()
    if self.info.type_code == "agenda" then
        return true
    else
        return false
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
    return self:isCardRemote() or self:isCardIce()
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

function CardMeta:onRez() if self.info.onRez then return self.info.onRez(self:_ctx()) else return true end end
function CardMeta:onPlay() if self.info.onPlay then return self.info.onPlay(self:_ctx()) end end
function CardMeta:onAction() if self.info.onAction then return self.info.onAction(self:_ctx()) end end
function CardMeta:onInstall() if self.info.onInstall then return self.info.onInstall(self:_ctx()) end end
function CardMeta:onRemoval() if self.info.onRemoval then return self.info.onRemoval(self:_ctx()) end end
function CardMeta:onScore() if self.info.onScore then return self.info.onScore(self:_ctx()) end end
function CardMeta:onPowerUp() return self.info.onPowerUp(self:_ctx()) end

function CardMeta:onNewTurn()
    self.until_turn_end = {}

    if self.info.onNewTurn then return self.info.onNewTurn(self:_ctx()) end
end

function CardMeta:onUse()
    self.until_use = {}
end

function CardMeta:onRunEnd()
    self.until_run_end = {}
end

function CardMeta:onIceEncounterEnd()
    self.until_encounter_end = {}

    if self.info.onIceEncounterEnd then return self.info.onIceEncounterEnd(self:_ctx()) end
end
