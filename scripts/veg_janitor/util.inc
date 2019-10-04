

function playErrorSoundAndExit(message)
    lsPlaySound("fail.wav");
    error(message)
end
-- Helper function used in an objects constructor to setup its metatable correctly allowing for basic inheritence.
function newObject(class, o, read_only)
    o = o or {}
    setmetatable(o, class)
    class.__index = class
    if read_only then
        makeReadOnly(o)
    end
    return o
end

function makeReadOnly(table)
    local mt = getmetatable(table)
    if not mt then
        mt = {}
        if not table then print(debug.traceback()) end
        setmetatable(table, mt)
    end
    mt.__newindex = function(t, k, v)
        error("Attempt to update a read-only table", 2)
    end
    return table
end
