test = {
    onTick = function(dt)
    end
}

board:push("corp_hand", Card(200, true))
board:push("corp_hand", Card(201, true))
board:push("corp_hand", Card(202, true))

board:push("corp_remote", Card(100, true))
board:assign("corp_hq", Card(101, true))
board:assign("corp_rnd", Card(102, false))
