function isSlotRemote(slot)
    return string.starts_with(slot, "corp_remote_") and not string.ends_with(slot, "_ice")
end

function isSlotIce(slot)
    return string.starts_with(slot, "corp_remote_") and string.ends_with(slot, "_ice")
end

function iceSlotOfRemote(slot)
    return slot .. "_ice"
end

function isPlayDeckSlot(slot)
    return slot == SLOT_CORP_RND or slot == SLOT_RUNNER_STACK
end

function isHandSlot(slot)
    return slot == SLOT_CORP_HAND or slot == SLOT_RUNNER_HAND
end

function isCreditsPoolSlot(slot)
    return string.ends_with(slot, "_credits_pool")
end

function isSlotInstallable(slot)
    return isSlotIce(slot) or isSlotRemote(slot) or slot == SLOT_RUNNER_CONSOLE or slot == SLOT_RUNNER_PROGRAMS or slot == SLOT_RUNNER_HARDWARE or slot == SLOT_RUNNER_RESOURCES
end

function remoteSlot(n)
    return "corp_remote_" .. n
end

function remoteIceSlot(n)
    return "corp_remote_" .. n .. "_ice"
end

function sideHandSlot(side)
    if side == SIDE_CORP then
        return SLOT_CORP_HAND
    else
        return SLOT_RUNNER_HAND
    end
end

function sideForId(id)
    if id == SIDE_CORP then
        return game.corp
    else
        return game.runner
    end
end

function sideSlots(id)
    if id == SIDE_CORP then
        return CORP_SLOTS
    else
        return RUNNER_SLOTS
    end
end

-- interaction
INTERACTION_PRIMARY = "primary"
INTERACTION_SECONDARY = "secondary"
INTERACTION_TERTIARY = "tertiary"
INTERACTION_CANCEL = "cancel"

-- sides
SIDE_CORP = "corp"
SIDE_RUNNER = "runner"

-- slots
SLOT_CORP_HAND = "corp_hand"
SLOT_CORP_RND = "corp_rnd"
SLOT_CORP_ARCHIVES = "corp_archives"
SLOT_CORP_HQ = "corp_hq"
-- SLOT_CORP_ = "corp_"

SLOT_RUNNER_HAND = "runner_hand"
SLOT_RUNNER_STACK = "runner_stack"
SLOT_RUNNER_CONSOLE = "runner_console"
SLOT_RUNNER_PROGRAMS = "runner_software"
SLOT_RUNNER_HARDWARE = "runner_hardware"
SLOT_RUNNER_RESOURCES = "runner_resources"

RUNNER_SLOTS = {
    SLOT_RUNNER_HAND,
    SLOT_RUNNER_STACK,
    SLOT_RUNNER_CONSOLE,
    SLOT_RUNNER_PROGRAMS,
    SLOT_RUNNER_HARDWARE,
    SLOT_RUNNER_RESOURCES,
}

CORP_SLOTS = {
    SLOT_CORP_HAND,
    remoteSlot(1),
    remoteSlot(2),
    remoteSlot(3),
    remoteSlot(4),
    remoteSlot(5),
    remoteSlot(6),
    remoteIceSlot(1),
    remoteIceSlot(2),
    remoteIceSlot(3),
    remoteIceSlot(4),
    remoteIceSlot(5),
    remoteIceSlot(6),
    SLOT_CORP_HQ,
    SLOT_CORP_RND,
    SLOT_CORP_ARCHIVES,
}

