--[[
            Card
]]--
--- @class Card
--- @field uid number
--- @field faceup boolean
--- @field meta CardMeta
_card = {}

--[[
            Deck
]]--
--- @class Deck
_deck = {}

--- @return Card
function _deck:top() end

--- @return Card
function _deck:takeTop() end

--- @return Card
function _deck:takeBottom() end

--- @param card Card
--- @param idx number
--- @return Card
function _deck:insert(card, idx) end

--- @param card Card
--- @return Card
function _deck:append(card) end

function _deck:shuffle() end

--- @param idx number
function _deck:remove(card, idx) end

--- @param card Card
function _deck:erase(card) end

--- @return number
function _deck:size() end

--[[
            GameBoard
]]--
--- @class GameBoard
_game_board = {}

--- @param slot string
--- @param card Card
--- @param idx number
--- @return Card
function _game_board:cardInsert(slot, card, idx) end

--- @param slot string
--- @param card Card
--- @return Card
function _game_board:cardAppend(slot, card) end

--- @param slot string
--- @param card Card
--- @return Card
function _game_board:cardPop(slot, card) end

--- @param slot string
--- @param from Card
--- @param to Card
--- @return Card
function _game_board:cardReplace(slot, from, to) end

--- @param slot string
--- @param idx number
--- @return Card
function _game_board:cardGet(slot, idx) end

--- @param slot string
--- @param deck Deck
--- @param idx number
--- @return Deck
function _game_board:deckInsert(slot, deck, idx) end

--- @param slot string
--- @param deck Deck
--- @return Deck
function _game_board:deckAppend(slot, deck) end

--- @param slot string
--- @param deck Deck
--- @return Deck
function _game_board:deckPop(slot, deck) end

--- @param slot string
--- @param from Deck
--- @param to Deck
--- @return Deck
function _game_board:deckReplace(slot, from, to) end

--- @param slot string
--- @param idx number
--- @return Deck
function _game_board:deckGet(slot, idx) end

--- @return number
function _game_board:count(slot) end

--[[
            Views
]]--
--- @class SlotView
--- @field slot string

--- @class CardView: SlotView
--- @field card Card

--- @class DeckView: SlotView
--- @field deck Deck
---
--- @class GameBoardView
--- @field vertical_offset number
_game_board_view = {}

--- @param slot string
--- @return StackWidget
function _game_board_view:getSlotStackWidget(slot) end

--- @class SlotInteractable
--- @field slot string
--- @field card Card
--- @field deck Deck

--[[
            Widgets
]]--
--- @class StackWidget
--- @field orientation string
--- @field alignment string
--- @field child_padding number
--- @field child_rotation number
_stack_widget = {}

--- @class Label
_label = {}

--- @param str string
function _label:setText(str) end

--- @class CardSelectWidget
--- @field hidden boolean
_card_select_widget = {}

--- @param deck Deck
--- @param limit number
function _card_select_widget:setDeck(deck, limit) end

--- @param card Card
function _card_select_widget:removeCard(card) end

--- @class OptionSelectWidget
--- @field hidden boolean
_option_select_widget = {}

--- @param options table<number, string>
function _option_select_widget:setOptions(options) end

--[[
            Host
]]--

--- @class Scripting
_scripting = {}

--- @param lvl number
--- @param str string
function _scripting:log(lvl, str) end

--- @param t table
function _scripting:register(t) end

--[[
            Globals
]]--

--- @type GameBoard
board = nil

--- @type Scripting
host = nil

--- @type GameBoardView
corp_hand_view = nil

--- @type GameBoardView
runner_hand_view = nil

--- @type GameBoardView
board_view = nil

--- @type CardSelectWidget
card_select_widget = nil

--- @type OptionSelectWidget
option_select_widget = nil

--- @type Label
status_label = nil

--- @type Label
alert_label = nil

--- @type Camera
main_camera = nil
