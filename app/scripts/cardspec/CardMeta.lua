--- @class CardMeta
--- @field info CardInfo
--- @field until_forever table
--- @field until_turn_end table
--- @field until_run_end table
CardMeta = class()

--- @param info CardInfo
--- @return CardMeta
function CardMeta:New(info)
    return construct(self, {
        info = info,

        rezzed = false,
        until_turn_end = {},
        until_run_end = {},
        until_forever = {},
        until_use = {},
    })
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
        return self.info.canAction(self)
    else
        return self.info.onAction ~= nil
    end
end

--- @return boolean
function CardMeta:canPlay()
    return self.info.canPlay == nil or self.info.canPlay(meta)
end

--- @return boolean
function CardMeta:canInstall()
    return self:isCardRemote() or self:isCardIce()
end

--- @param meta CardMeta
--- @return boolean
function CardMeta:canBreakIce(meta)
    return self.info.canBreakIce(meta)
end

--- @param slot string
--- @return boolean
function CardMeta:canInstallTo(slot)
    if not self:canInstall() then
        return false
    end

    if self.info.type_code == "ice" then
        return isSlotIce(slot)
    else
        return isSlotRemote(slot)
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

--- @param kws table<number, string>
--- @return boolean
function CardMeta:keywordsInclude(kws)
    local str = self.info.keywords
    for _, kw in pairs(kws) do
        if string.find(str, kw) then
            return true
        end

        local result = false
        self:iterModifications(function (t)
            if string.find(t.additional_keywords, kw) then
                result = true
            end
        end)

        if result then
            return true
        end
    end

    return false
end

--- @param func fun(description: string, effect: function)
function CardMeta:iterSubroutines(func)
    for i = 1, #self.info.subroutines do
        func(self.info.subroutine_descriptions[i], self.info.subroutines[i])
    end
end

--- @param func fun(t: table)
function CardMeta:iterModifications(func)
    func(self.until_forever)
    func(self.until_turn_end)
    func(self.until_run_end)
end

-- events

function CardMeta:onRez() if self.info.onRez then return self.info.onRez(self) end end
function CardMeta:onPlay() if self.info.onPlay then return self.info.onPlay(self) end end
function CardMeta:onAction() if self.info.onAction then return self.info.onAction(self) end end
function CardMeta:onInstall() if self.info.onInstall then return self.info.onInstall(self) end end
function CardMeta:onRemoval() if self.info.onRemoval then return self.info.onRemoval(meta) end end
function CardMeta:onScore() if self.info.onScore then return self.info.onScore(self) end end

--- @param meta CardMeta
function CardMeta:onNewTurn(meta)
    self.until_turn_end = {}

    if self.info.onNewTurn then return self.info.onNewTurn(self) end
end

function CardMeta:onUse()
    self.until_use = {}
end

function CardMeta:onRunEnd(meta)
    self.until_run_end = {}
end
