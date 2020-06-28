--- @class EngineGameBoardView: IGameBoardView
--- @field board GameBoard
EngineGameBoardView = class("EngineGameBoardView", IGameBoardView)

--- @param board GameBoard
--- @return EngineGameBoardView
function EngineGameBoardView:New(board)
    return construct(self, {
        board = board,
    })
end

function EngineGameBoardView:insert(slot, item, idx)
    idx = idx or 0
    if item.type == "Card" then
        return self.board:cardInsert(slot, item, idx)
    elseif item.type == "Deck" then
        return self.board:deckInsert(slot, item, idx)
    else
        assert(false, "Unknown item class %s", item.type)
    end
end

function EngineGameBoardView:append(slot, item)
    if item.type == "Card" then
        return self.board:cardAppend(slot, item)
    elseif item.type == "Deck" then
        return self.board:deckAppend(slot, item)
    else
        assert(false, "Unknown item class %s", item.type)
    end
end

function EngineGameBoardView:pop(item)
    if item.type == "Card" then
        return self.board:cardPop(item.slotid, item)
    elseif item.type == "Deck" then
        return self.board:deckPop(item.slotid, item)
    else
        assert(false, "Unknown item class %s", item.type)
    end
end

function EngineGameBoardView:move(a, slot)
    if item.type == "Card" then
        return self.board:cardMove(a, slot)
    else
        assert(false, "Unknown item class %s", item.type)
    end
end

function EngineGameBoardView:replace(a, b)
    if item.type == "Card" then
        return self.board:cardReplace(a.slotid, a, b)
    elseif item.type == "Deck" then
        return self.board:deckReplace(a.slotid, a, b)
    else
        assert(false, "Unknown item class %s", item.type)
    end
end

function EngineGameBoardView:count(slot)
    return self.board:count(slot)
end

function EngineGameBoardView:card(slot, idx)
    return self.board:cardGet(slot, idx or 0)
end

function EngineGameBoardView:deck(slot, idx)
    return self.board:deckGet(slot, idx or 0)
end
