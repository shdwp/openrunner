--- @class IGameBoardView
IGameBoardView = class("IGameBoardView")

--- @param slot string
--- @param idx number
--- @return Card
function IGameBoardView:card(slot, idx) end

--- @param slot string
--- @param idx number
--- @return Deck
function IGameBoardView:deck(slot, idx) end

--- @param slot string
--- @param item Card|Deck
function IGameBoardView:insert(slot, item, idx) end

--- @param slot string
--- @param item Card|Deck
function IGameBoardView:append(slot, item) end

--- @param item Card|Deck
function IGameBoardView:pop(item) end

--- @param a Card|Deck
--- @param b Card|Deck
function IGameBoardView:replace(a, b) end

--- @param slot string
function IGameBoardView:move(a, slot) end

--- @param slot string
--- @return number
function IGameBoardView:count(slot) end

function IGameBoardView:cardsIter(slot)
    local i = 0
    local n = self:count(slot)
    
    return function ()
        if i >= n then
            return nil
        else
            local value = self:card(slot, i)
            i = i + 1
            return value
        end
    end
end