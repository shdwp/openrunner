game = {
    onInit = function()
        local ice_1 = board_view:getSlotStackWidget("corp_remote_1_ice")
        ice_1.alignment = 1
        ice_1.orientation = 1
        ice_1.child_padding = 1.25
        ice_1.child_rotation = math.pi / 2
    end
}

board:push("corp_hand", Card(200, true))
board:push("corp_hand", Card(201, true))
board:push("corp_hand", Card(202, true))

board:push("corp_remote_1", Card(100, true))

board:push("corp_remote_1_ice", Card(200, false))
board:push("corp_remote_1_ice", Card(200, false))
board:push("corp_remote_1_ice", Card(200, false))
board:assign("corp_hq", Card(101, true))
board:assign("corp_rnd", Card(102, false))
