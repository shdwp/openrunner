ui = {
    configured_slots = {},
    view_zoomed = false,
}

function ui:cardInstalled(card, slot)
    if not table.contains(self.configured_slots, slot) then
        self.configured_slots[#self.configured_slots] = slot
    end
end

function ui:focusCorp()
    main_camera.position = Vec3(0, 1.2, 0.5)
    main_camera.direction = Vec3(0, -1, -0.001)

    runner_hand_view.vertical_offset = -200
    corp_hand_view.vertical_offset = 0
end

function ui:focusRunner()
    main_camera.position = Vec3(0, 1.2, -0.5)
    main_camera.direction = Vec3(0, -1, 0.001)

    runner_hand_view.vertical_offset = 0
    corp_hand_view.vertical_offset = -200
end

function ui:zoomRunner()
    main_camera.position = Vec3(0, 1.2, 0.1)
    main_camera.direction = Vec3(0, -1, -0.001)
end

function ui:zoomCorp()
    main_camera.position = Vec3(0, 1.2, 0.03)
    main_camera.direction = Vec3(0, -1, 0.001)
end

function ui:focusCurrentPlayer()
    if game.current_side == SIDE_CORP then
        ui:focusCorp()
    else
        ui:focusRunner()
    end
end

--- @param slot string
--- @param widget StackWidget
function ui:onSlotConfiguration(slot, widget)
    if isSlotIce(slot) then
        widget.alignment = "min"
        widget.orientation = "vertical"
        widget.child_padding = 1.25
        widget.child_rotation = math.pi / 2
    elseif not isHandSlot(slot) and table.contains(RUNNER_SLOTS, slot) then
        widget.child_rotation = math.pi
    end
end

function ui:onTick(dt)
    if Input:keyPressed(KeyCode.LEFT_SHIFT) then
        if self.view_zoomed then
            self:focusCurrentPlayer()
            self.view_zoomed = false
        else
            self.view_zoomed = true
            if game.current_side == SIDE_CORP then
                ui:zoomRunner()
            else
                ui:zoomCorp()
            end
        end
    end
end

host:register(ui)
