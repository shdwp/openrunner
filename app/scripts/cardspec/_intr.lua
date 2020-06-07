intr = {

}

--- @param slot string
--- @param n number amount of cards
--- @param limit number limit to top N
--- @param cb function accepting Card
--- @return boolean
function intr:promptDeckSelect(slot, n, limit, cb)
    return true
end

--- @param slot string
--- @param cb function accepting Card
--- @return boolean
function intr:promptStackSelect(slot, cb)
    return true
end

--- @param card userdata Card
--- @return boolean
function intr:promptInstall(card)
    return true
end

--- @param cb function accepting Card
--- @return boolean
function intr:promptInstalled(cb)
    return true
end

