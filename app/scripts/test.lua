test = {
    onTick = function(dt)
    end
}

local c = board:push("corp_remote", Card(100, true))
c.faceup = false

local card = Card(101, true)
board:assign("corp_hq", card)
board:assign("corp_rnd", Card(102, false))

