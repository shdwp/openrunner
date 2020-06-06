inspect = dofile(libpath .. "inspect.lua/inspect.lua")

game = {
    onInit = function()
        board:cardAppend("corp_hq", db:card(1093))

        local deck = db:deck([[3 Hostile Takeover
2 Posted Bounty
3 Priority Requisition
3 Private Security Force
3 Adonis Campaign
2 Melange Mining Corp.
3 PAD Campaign
1 Anonymous Tip
3 Beanstalk Royalties
3 Hedge Fund
2 Shipment from Kaguya
2 Hadrian's Wall
3 Ice Wall
3 Wall of Static
3 Enigma
3 Tollbooth
2 Archer
2 Rototurret
3 Shadow
]]
        )
        board:deckAppend("corp_rnd", deck)


        --[[
        local deck = board:deckAppend("corp_rnd", Deck())
        deck:append(Card(401, false))
        deck:append(Card(402, false))
        deck:append(Card(403, false))
        deck:append(Card(404, false))

        board:cardAppend("corp_remote_1", Card(100, true))
        board:cardAppend("corp_remote_1_ice", Card(200, false))
        board:cardAppend("corp_remote_1_ice", Card(201, false))

        local ice_1 = board_view:getSlotStackWidget("corp_remote_1_ice")
        ice_1.alignment = "min"
        ice_1.orientation = "vertical"
        ice_1.child_padding = 1.25
        ice_1.child_rotation = math.pi / 2
        ]]--
    end,


    onInteraction = function (self, event, itr)
        if event == "release" or event == "drag" then
            return
        end

        if itr.slot == "corp_rnd" then
            if itr.deck.size > 0 then
                local card = itr.deck:takeTop()
                card.faceup = true
                board:cardAppend("corp_hand", card)
            end
        elseif itr.slot == "corp_hand" then
            print(itr.card.uij)
            local card = board:cardPop(itr.slot, itr.card)
            board:cardAppend("corp_remote_2", card)
        end

        if event == "click" and itr.slot == "corp_rnd" and itr.deck.size > 0 then
        end
    end,
}

