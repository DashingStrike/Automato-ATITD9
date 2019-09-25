

function writeCsvFileTo(filename, table)
    local csv = createCSV(table)
    serialize(csv, filename .. ".txt", true)
    serialize(table, filename .. "_lua_table.txt")
end


function createCSV(table)
    local csv = ""
    for index, row in ipairs(table) do
        for index, cell in ipairs(row) do
            csv = csv .. cell .. ","
        end
        csv = csv .. "\n"
    end
    return csv
end

-- Hacky modified serialize.lua
write_cache = {}
function serialize(o, filename, append, cache)
    local str = serializeToString(o)
    if write_cache[filename] == str then
        return
    end
    write_cache[filename] = str
    local outputFile = io.open("data/" .. filename, append and "a" or "w");
    if type(o) == "table" then outputFile:write("return\n"); end
    serializeInternal(o, outputFile);
    outputFile:close();
end

function serializeToString(o)
    local outputFile = StringFile:new()
    if type(o) == "table" then outputFile:write("return\n"); end
    serializeInternal(o, outputFile);
    return outputFile.data
end

function deserialize(filename)
    filename = "data/" .. filename
    print("Reading from " .. filename)

    if (pcall(dofile, filename)) then
        return true, dofile(filename);
    else
        return false, nil;
    end
end

function deserializeFromString(str)
    serialize(str, "temp_veg_janitor.txt")
    return deserialize("temp_veg_janitor.txt")
end


StringFile = {}
function StringFile:new()
    o = {}
    o.data = ""
    return newObject(self, o)
end

function StringFile:write(str)
    self.data = self.data .. str
end


function serializeInternal(o, outputFile, indentStr, format_string)
    if (not indentStr) then
        indentStr = "";
    end
    if type(o) == "number" then
        outputFile:write(o);
    elseif type(o) == "string" then
        if format_string then
            o = string.format("%q", o)
        end
        outputFile:write(o);
    elseif type(o) == "boolean" then
        if (o) then
            outputFile:write("true");
        else
            outputFile:write("false");
        end
    elseif type(o) == "table" then
        outputFile:write(indentStr .. "{\n");
        if o.serialize then
            o = o.serialize(o)
        end
        if o.class_name then
            serializeKeyValue(outputFile, indentStr, "class_name", o.class_name)
        end

        local ignore = o.ignore_for_serialization or {}

        for k, v in pairs(o) do
            if not ignore[k] then
                serializeKeyValue(outputFile, indentStr, k, v)
            end
        end
        outputFile:write(indentStr .. "}\n");
    else
        print(debug.traceback())
        error("cannot serialize a " .. type(o));
    end
    end

function serializeKeyValue(outputFile, indentStr, k,v)
    if (type(k) == "number") then
        outputFile:write(indentStr .. "\t[" .. k .. "] = ");
    else
        outputFile:write(indentStr .. "\t[" .. string.format("%q", k) .. "] = ");
    end
    if (type(v) == "table") then
        outputFile:write("\n");
    end
    serializeInternal(v, outputFile, indentStr .. "\t", true);
    if (type(v) == "table") then
        outputFile:write(indentStr .. "\t,\n");
    else
        outputFile:write(",\n");
    end
end

function print_table(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    lsPrintln(output_str)
end
