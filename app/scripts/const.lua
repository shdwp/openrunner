-- sides
SIDE_CORP = "corp"
SIDE_RUNNER = "runner"

-- slots
SLOT_CORP_HAND = "corp_hand"
SLOT_CORP_RND = "corp_rnd"
SLOT_CORP_ARCHIVES = "corp_archives"
-- SLOT_CORP_ = "corp_"

function isSlotRemote(slot)
    return string.starts_with(slot, "corp_remote_") and not string.ends_with(slot, "_ice")
end

function isSlotIce(slot)
    return string.starts_with(slot, "corp_remote_") and string.ends_with(slot, "_ice")
end

