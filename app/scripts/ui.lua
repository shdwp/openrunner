ui = {
    configured_slots = {},
    view_zoomed = false,
}

function ui:cardInstalled(card, slot)
    if not table.contains(self.configured_slots, slot) then
        if isSlotIce(slot) then
            local widget= board_view:getSlotStackWidget(slot)
            widget.alignment = "min"
            widget.orientation = "vertical"
            widget.child_padding = 1.25
            widget.child_rotation = math.pi / 2

        elseif table.contains(RUNNER_BOARD_SLOTS, slot) then
            local widget = board_view:getSlotStackWidget(slot)
            widget.child_rotation = math.pi
        end

        self.configured_slots[#self.configured_slots] = slot
    end
end

function ui:focusCorp()
    main_camera.position = Vec3(0, 1.2, 0.5)
    main_camera.direction = Vec3(0, -1, -0.001)

    runner_hand_view.vertical_offset = 100
    corp_hand_view.vertical_offset = 0
end

function ui:zoomCorp()
    main_camera.position = Vec3(0, 1.2, 0.03)
    main_camera.direction = Vec3(0, -1, 0.001)
end

function ui:focusRunner()
    main_camera.position = Vec3(0, 1.2, -0.5)
    main_camera.direction = Vec3(0, -1, 0.001)

    runner_hand_view.vertical_offset = 0
    corp_hand_view.vertical_offset = 100
end

function ui:zoomRunner()
    main_camera.position = Vec3(0, 1.2, 0.1)
    main_camera.direction = Vec3(0, -1, -0.001)
end

function ui:focusCurrentPlayer()
    if game.current_side == SIDE_CORP then
        ui:focusCorp()
    else
        ui:focusRunner()
    end
end

function ui:onTick(dt)
    if Input:keyDown(340) then
        if game.current_side == SIDE_CORP then
            ui:zoomRunner()
        else
            ui:zoomCorp()
        end
        self.view_zoomed = true
    else if self.view_zoomed then
        ui:focusCurrentPlayer()
        self.view_zoomed = false
    end
    end
end

host:register(ui)
