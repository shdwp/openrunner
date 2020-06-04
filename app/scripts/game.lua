game = {
    onInit = function()
        board:cardAppend("corp_rnd", Card(200, true))
        --board:cardAppend("corp_hand", Card(200, true))
    end,

    onInit2 = function()
        board:cardAppend("corp_hand", Card(200, true))
        board:cardAppend("corp_hand", Card(200, true))

        board:cardAppend("corp_remote_1", Card(100, true))
        board:cardAppend("corp_remote_1_ice", Card(200, false))
        board:cardAppend("corp_remote_1_ice", Card(201, false))

        -- board:cardAppend("corp_hq", Card(301, true))

        local deck = board:deckAppend("corp_rnd", CardDeck())
        deck:append(Card(401, false))
        deck:append(Card(402, false))
        deck:append(Card(403, false))
        deck:append(Card(404, false))

        local ice_1 = board_view:getSlotStackWidget("corp_remote_1_ice")
        ice_1.alignment = 1
        ice_1.orientation = 1
        ice_1.child_padding = 1.25
        ice_1.child_rotation = math.pi / 2
    end
}

