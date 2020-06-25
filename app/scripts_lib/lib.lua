--- 3rd party
-- @TODO: move to `require`
JSON = dofile(libpath .. "json-lua/JSON.lua")
inspect = dofile(libpath .. "inspect.lua/inspect.lua")

--- Logging
function info(fmt, ...) host:log(1, string.format(fmt, ...)) end
function verbose(fmt, ...) host:log(2, string.format(fmt, ...)) end
function error(fmt, ...) host:log(0, string.format(fmt, ...)) end

--- Cards
--- @param slot string
--- @return fun(): Card
function cardsIter(slot)
    local i = 0
    local n = board:count(slot)

    return function ()
        if i >= n then
            return nil
        else
            local value = board:cardGet(slot, i)
            i = i + 1
            return value
        end
    end
end

--- String
function string.starts_with(str, start)
    if not str then
        error("")
    end
    return str:sub(1, #start) == start
end

function string.ends_with(str, ending)
    if not str then
        error("")
    end
    return ending == "" or str:sub(-#ending) == ending
end

--- Table
function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.contains(t, elem)
    for _, v in ipairs(t) do
        if v == elem then
            return true
        end
    end

    return false
end

function table.indexOf(t, elem)
    for idx = 1, #t do

        if type(elem) == "function" and elem(t[idx]) then
            return idx
        elseif t[idx] == elem then
            return idx
        end
    end

    return nil
end

function table.array_concat(into, from)
    for _, v in pairs(from) do
        table.insert(into, v)
    end
end

--- Card debug description (for cpp)
function debugDescriptionTableCleanup(t)
    for k, v in pairs(t) do
        if k == "info" then
            t[k] = nil
        elseif k == "selected_ice" then
            t[k] = string.format("<card with uid %s>", v.info.code)
        elseif type(v) == "table" then
            debugDescriptionTableCleanup(v)
        end
    end
end

function debugDescription(item)
    if item.type == "Card" then
        local t = table.shallowcopy(item.meta)
        debugDescriptionTableCleanup(t)
        return inspect(t)
    end
end


--- OOP
function construct(self, a, b)
    a = a or {}
    b = b or {}

    for k, v in pairs(a) do
        b[k] = v
    end

    local mt = getmetatable(self)
    setmetatable(b, { __index = self, __tostring = mt.__tostring })
    return b
end

function class(typeid, parent, o)
    parent = parent or {
        debugDescription = function () return "" end
    }

    local t = o or {}
    local mt = {
        __tostring = function (self)
            return "<" .. typeid .. " " .. self:debugDescription() .. ">"
        end
    }

    if parent then
        mt.__index = parent
    end

    setmetatable(t, mt)
    return t
end
