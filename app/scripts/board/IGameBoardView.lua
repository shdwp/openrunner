--- @class IGameBoardView
IGameBoardView = class("IGameBoardView")

--- @param slot string
--- @param idx number
--- @return Card
function IGameBoardView:cardAt(slot, idx) end

--- @param slot string
--- @param idx number
--- @return Deck
function IGameBoardView:deckAt(slot, idx) end

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

--- @param slot string
--- @return fun(): Card
function IGameBoardView:cardsIter(slot)
    local i = 0
    local n = self:count(slot)
    
    return function ()
        if i >= n then
            return nil
        else
            local value = self:cardAt(slot, i)
            i = i + 1
            return value
        end
    end
end

--- @return fun(): Card
function IGameBoardView:boardCardsIter()
    local slots = {
        remoteSlot(1),
        remoteSlot(2),
        remoteSlot(3),
        remoteSlot(4),
        remoteSlot(5),
        remoteSlot(6),
        remoteIceSlot(1),
        remoteIceSlot(2),
        remoteIceSlot(3),
        remoteIceSlot(4),
        remoteIceSlot(5),
        remoteIceSlot(6),
        SLOT_CORP_HQ,
        SLOT_RUNNER_PROGRAMS,
        SLOT_RUNNER_HARDWARE,
        SLOT_RUNNER_RESOURCES,
        SLOT_RUNNER_CONSOLE,
    }
    
    local cards = {}
    
    for _, slot in pairs(slots) do
        for i = 0, self:count(slot) do
            local card = self:cardAt(slot, i)
            if card then
                table.insert(cards, card)
            end
        end
    end
    
    local i = 0
    
    return function ()
        i = i + 1
        if i > #cards then
            return nil
        else
            return cards[i]
        end
    end
end