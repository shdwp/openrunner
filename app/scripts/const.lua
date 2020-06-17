-- general
CLICK = "click"
ALTCLICK = "altclick"
CANCEL = "cancel"

-- sides
SIDE_CORP = "corp"
SIDE_RUNNER = "runner"

-- slots
SLOT_CORP_HAND = "corp_hand"
SLOT_CORP_RND = "corp_rnd"
SLOT_CORP_ARCHIVES = "corp_archives"
-- SLOT_CORP_ = "corp_"

SLOT_RUNNER_HAND = "runner_hand"
SLOT_RUNNER_STACK = "runner_stack"
SLOT_RUNNER_CONSOLE = "runner_console"
SLOT_RUNNER_PROGRAMS = "runner_software"
SLOT_RUNNER_HARDWARE = "runner_hardware"
SLOT_RUNNER_RESOURCES = "runner_resources"

RUNNER_BOARD_SLOTS = {
    SLOT_RUNNER_STACK,
    SLOT_RUNNER_CONSOLE,
    SLOT_RUNNER_PROGRAMS,
    SLOT_RUNNER_HARDWARE,
    SLOT_RUNNER_RESOURCES,
}

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