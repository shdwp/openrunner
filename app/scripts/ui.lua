ui = {
    configured_slots = {},
}

function ui:iceCardInstalled(card, slot)
    if not table.contains(self.configured_slots, slot) then
        local ice_1 = board_view:getSlotStackWidget(slot)
        ice_1.alignment = "min"
        ice_1.orientation = "vertical"
        ice_1.child_padding = 1.25
        ice_1.child_rotation = math.pi / 2

        self.configured_slots[#self.configured_slots] = slot
    end
end

function ui:focusCorp()
    main_camera.position = Vec3(0, 1.2, 0.5)
    main_camera.direction = Vec3(0, -1, -0.001)
end

function ui:focusRunner()
    main_camera.position = Vec3(0, 1.2, -0.5)
    main_camera.direction = Vec3(0, -1, 0.001)
end

host:register(ui)
