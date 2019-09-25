dofile("veg_janitor/io.inc")
-- Used to place gui elements sucessively.
current_y = 0
-- How far off the left hand side to place gui elements.
X_PADDING = 5
DEFAULT_CONFIG_FILENAME_VEG = "default_veg_janitor_deep_config_file.txt"
TYPES = {
    "Cabbage",
    "Carrots",
    "Cucumbers",
    "Eggplant",
    "Garlic",
    "Leeks",
    "Onions",
    "Peppers",
    "Watermelon",
}
TYPES_WITH_DEFAULT = {
    "Default",
    "Cabbage",
    "Carrots",
    "Cucumbers",
    "Eggplant",
    "Garlic",
    "Leeks",
    "Onions",
    "Peppers",
    "Watermelon",
}
STAGES_WITH_DEFAULT = {
    "Default",
    1,
    2,
    3,
    4,
    5
}
function sub_screen(o, config)
    local done = false
    local open = true
    if o.open_button then
        open = button(o.open_button or "Open")
    end
    config = config or o.config

    if open then
        while not done do
            current_y = 0
            done = done or o.draw_screen(config)
            done = done or drawBottomButton(lsScreenX - 5, o.done_button_text or "Done")
            if drawBottomButton(110, "Exit Script", RED) then
                error "Script exited by user"
            end
            write_config(config)
            lsDoFrame()
            lsSleep(10)
        end
    end
end

function attribute_edit_screen(config, title, descriptive_name, name, default)
    sub_screen {
        config = config,
        done_button_text = "Back",
        open_button = title,
        draw_screen = function()
            local types_with_values = {}
            for i, type in ipairs(TYPES_WITH_DEFAULT) do
                local v = config[name][type]
                table.insert(types_with_values, type .. (v and (" (" .. v .. ")") or ""))

            end
            local k = dropdown(name .. config.name, 1, types_with_values, "Type", TYPES_WITH_DEFAULT)
            if config[name][k] == nil then
                local create = button("Create " .. descriptive_name .. " for " .. k)
                if create then
                    config[name][k] = default
                end
            else
                config[name][k] = drawEditBox(name .. config.name .. k, descriptive_name .. "for " .. k, config[name][k], type(default) == "number")
                if k ~= "Default" then
                    local unset = button("Unset for " .. k .. " to use default again")
                    if unset then
                        config[name][k] = nil
                    end
                end
            end
        end
    }

end

function edit_config_screen(config)
    sub_screen {
        config = config,
        done_button_text = "Back",
        draw_screen = function()
            attribute_edit_screen(config, "Edit Plant Batch Size", "Planting Batch Size", "planting_batch_size", 4)
            attribute_edit_screen(config, "Edit Plant Detection Algorithm", "pixel requirement", "required_number_of_changed_pixels_before_clicking", 125)
            sub_screen {
                config = config,
                done_button_text = "Back",
                open_button = "Edit Plant Placement Ordering",
                draw_screen = function()
                end
            }
            sub_screen {
                config = config,
                done_button_text = "Back",
                open_button = "Edit Stage Water Timings",
                draw_screen = function()
                    local name = "stage_advance_timings"
                    local descriptive_name = "Stage Advance Timings"
                    local types_with_values = {}
                    for i, type in ipairs(TYPES_WITH_DEFAULT) do
                        local v = config[name][type]
                        local display = ""
                        for k, timing in pairs(v or {}) do
                            if timing then

                                display = display .. k .. "=" .. (timing/1000).. "s,"
                            end
                        end
                        table.insert(types_with_values, type .. (v and (" (" .. display .. ")") or ""))

                    end
                    local k = dropdown(name .. config.name, 1, types_with_values, "Plant type:", TYPES_WITH_DEFAULT)
                    if config[name][k] == nil then
                        local create = button("Create " .. descriptive_name .. " for " .. k)
                        if create then
                            config[name][k] = { [1] = 14000, ["Default"] = 17000 }
                        end
                    else
                        local sub_types_with_values = {}
                        for i, type in ipairs(STAGES_WITH_DEFAULT) do
                            local v = config[name][k][type]
                            table.insert(sub_types_with_values, type .. (v and (" (" .. v .. ")") or ""))
                        end
                        local stage = dropdown("stage" .. name .. config.name, 1, sub_types_with_values, "Stage:", STAGES_WITH_DEFAULT)
                        if config[name][k][stage] == nil then
                            local create = button("Create timing for " .. k .. " in stage " .. stage)
                            if create then
                                config[name][k][stage] = 14000
                            end
                        else
                            config[name][k][stage] = drawEditBox("stage" .. name .. config.name .. k .. stage, descriptive_name .. "for " .. stage, config[name][k][stage], true)
                        end
                        if stage ~= "Default" and config[name][k][stage] ~= nil then
                            local unset = button("Unset stage " .. stage .. " to use default again")
                            if unset then
                                config[name][k][stage] = nil
                            end
                        end
                        if k ~= "Default" and config[name][k] ~= nil then
                            local unset = button("Unset for " .. k .. " to use default again")
                            if unset then
                                config[name][k] = nil
                            end
                        end
                    end
                end
            }
            sub_screen {
                config = config,
                done_button_text = "Back",
                open_button = "Edit or Create Plants",
                draw_screen = function()
                    plant_creator(config)
                end
            }
            local copy_to_clipboard = button("Copy config to clipboard")
            if copy_to_clipboard then
                lsClipboardSet(serializeToString(config))
            end
            local set_from_clipboard = button("Set config from clipboard")
            if set_from_clipboard then
                local config_string = lsClipboardGet()
                local success, new_config = deserializeFromString(config_string)
                assert(success, "Failed to load config from clipboard")
                assert(new_config.filename, "Invalid config string, no filename found")
                assert(new_config.name, "Invalid config string, no name found")
                for k, v in pairs(config) do
                    config[k] = nil
                end
                for k, v in pairs(new_config) do
                    config[k] = v
                end
                update_configs(new_config)
                return true
            end
        end
    }
end

function update_configs(new_config)
    writeSetting("current_config", new_config.name)
    local config_string = readSetting("config_names") or "default"
    local configs = config_string:split(",")
    local config_set = {}
    for _, c in ipairs(configs) do
        config_set[c] = true
    end
    if not config_set[new_config.name] then
        local new_config_string = config_string .. "," .. new_config.name
        writeSetting("config_names", new_config_string)
    end
    write_config(new_config)

end

unique_edit_index = 1

button_widths = {}
function button(text, colour, right_align)
    if not button_widths[text] then
        button_widths[text] = lsPrint(-100, -100, 10, 1.2, 1.2, colour or WHITE, text)
    end
    if right_align then
        current_y = current_y - 30
    end
    local x = right_align and (lsScreenX - (button_widths[text] + 10)) or 5
    local result = lsButtonText(x, current_y, 1, button_widths[text], colour or WHITE, text)
    current_y = current_y + 30
    return result
end

function config_attribute_setter(config)

end

function config_selector(starting_config)
    drawTextUsingCurrent("Select configuration to use:", WHITE)
    local config_string = readSetting("config_names") or "default"
    local setting_config = readSetting("current_config") or "default"
    local configs = config_string:split(",")
    local current_config, changed = dropdown("config_selector" .. setting_config, setting_config, configs, "Configuration Preset")
    if changed then
        writeSetting("current_config", current_config)
        local success, config = deserialize(current_config .. "_veg_janitor_config.txt")
        starting_config = config
        starting_config.filename = current_config .. "_veg_janitor_config.txt"
        starting_config.name = current_config
        if not success then
            writeSetting("current_config", "default")
            error("Failed to open config file " .. current_config)
        end
    end
    local add = button("Create New Config", GREEN)
    if add then
        sub_screen {
            config = starting_config,
            done_button_text = "Back",
            draw_screen = function()
                local new_config_name = drawEditBox("config_name", "Name", "", false)
                local valid = new_config_name and new_config_name ~= ""
                for _, c in ipairs(configs) do
                    valid = valid and c ~= new_config_name
                end
                local create = button(new_config_name and ("Create with name: " .. new_config_name) or "Enter a valid config name", valid and GREEN or RED)
                if valid and create then
                    config_string = config_string .. "," .. new_config_name
                    writeSetting("config_names", config_string)
                    writeSetting("current_config", new_config_name)
                    local success, default_config = deserialize("default_veg_janitor_config.txt")
                    if not success then
                        error("Failed to load default config to copy when making new config, it should be found in default_veg_janitor_config.txt")
                    end
                    starting_config = default_config
                    starting_config.filename = new_config_name .. "_veg_janitor_config.txt"
                    starting_config.name = new_config_name
                    write_config(starting_config)
                    return true
                end
            end
        }
    end

    return starting_config
end

function load_current_config()
    local success, default_config = deserialize("default_veg_janitor_config.txt")
    if not success then
        serialize(default_deep_config(), "default_veg_janitor_config.txt")
    end
    local current_config = readSetting("current_config") or "default"
    local success, config = deserialize(current_config .. "_veg_janitor_config.txt")
    starting_config = config
    if not success then
        writeSetting("current_config", "default")
        error("Failed to open config file " .. current_config)
    end
    config.filename = current_config .. "_veg_janitor_config.txt"
    config.name = current_config
    return config
end

dropdown_index = 1
function plant_creator(config)
    local existing_plants = { "Create New" }
    config.plants = config.plants or {}
    for k, v in pairs(config.plants) do
        table.insert(existing_plants, k)
    end
    drawTextUsingCurrent("Select existing plant to edit or Create New:", WHITE)
    local plant_name = dropdown("existing_plants" .. (dropdown_index), selected_plant or 1, existing_plants)
    local new_plant = plant_name == "Create New"
    local plant_config = {}
    if new_plant then
        plant_name = drawEditBox("plant_name", "Plant Name", "", false) or ""
    else
        plant_config = config.plants[plant_name]
    end

    local seed_type = dropdown("seed_types" .. plant_name, plant_config.type or 1,
            TYPES, "Type")
    local stages = drawEditBox("watering_stages" .. plant_name, "Number of  watering stages", plant_config.stages or 3, true)
    local waters = drawEditBox("number_of_waters_per_stage" .. plant_name, "Number of waters per stage", plant_config.waters or 2, true)
    local yield = drawEditBox("yield" .. plant_name, "Yield", plant_config.yield or 2, true)
    local valid = (plant_name and plant_name ~= "") and seed_type and stages and waters and yield and (not new_plant or not config.plants[plant_name])
    if new_plant and config.plants[plant_name] then
        drawTextUsingCurrent("Plant with name " .. plant_name .. " already exists, please edit it directly.")
    end
    local add = button(new_plant and "Add Plant" or "Edit Plant", valid and GREEN or RED)
    if valid and add then
        config.plants[plant_name] = { type = seed_type, stages = stages, waters = waters, yield = yield }
        write_config(config)
        selected_plant = plant_name
        dropdown_index = dropdown_index + 1
    end
    if not new_plant then
        local delete = button("Delete Plant", RED)
        if delete then
            config.plants[plant_name] = nil
            write_config(config)
        end
    end
end

function write_config(config)
    serialize(config, config.filename, false, true)
end

dropdown_indexs = {}
function dropdown(key, starting_index, values, text, return_values)
    if text then
        drawTextUsingCurrent(text)
    end
    if type(starting_index) == "string" then
        for i, v in ipairs(values) do
            if v == starting_index then
                starting_index = i
                break
            end
        end
    end
lsSetCamera(0,0,lsScreenX*1.2,lsScreenY*1.2);
    local before = dropdown_indexs[key]
    dropdown_indexs[key] = lsDropdown(key, X_PADDING, current_y, 10, lsScreenX - 10, dropdown_indexs[key] or starting_index, values)
    current_y = current_y + 30
    return_values = return_values or values
    return return_values[dropdown_indexs[key]], before ~= dropdown_indexs[key]
end

function getUserParams()
    local is_done = false
    local got_user_params = false

    local config = load_current_config()
    local edit_config = false
    while not is_done do
        current_y = 10
        if edit_config then
            edit_config_screen(config)
            edit_config = false
        else
            if not got_user_params then
                current_y = 0
                config = config_selector(config)
                edit_config = button("Edit config", WHITE, true)
                config.selected_seed_type = dropdown("seed_type_selector", config.selected_seed_type or 1, TYPES, "Seed type filter")
                local yields = { "All", 1, 2, 3, 4 }
                config.yield_filter_index = dropdown("yield_filter", config.yield_filter_index or 1,
                        yields, "Yield filter", {1,2,3,4,5})
                config.yield_filter = yields[config.yield_filter_index]
                local plants = {}
                for n, plant in pairs(config.plants) do
                    table.insert(plants, n)
                end
                table.sort(plants, function(a, b)
                    local type_a = config.plants[a].type
                    local type_b = config.plants[b].type
                    if type_a ~= type_b then
                        return type_a < type_b
                    else
                        return a < b
                    end
                end)
                local display_seed_names = {}
                local filtered_plants = {}
                local starting_index = 1
                local i = 1
                for _, name in ipairs(plants) do
                    local plant = config.plants[name]
                    if plant.type == config.selected_seed_type or config.selected_seed_type == "All" then
                        if config.yield_filter == "All" or config.yield_filter == plant.yield then
                            if name == config.seed_name then
                                starting_index = i
                            end
                            table.insert(filtered_plants, name)
                            local width = lsPrint(-100, -100, 10, 1, 1, colour or WHITE, name)
                            local padded_name = string.lpad(name, math.floor((180 - width) / 5))
                            table.insert(display_seed_names, padded_name .. " (" .. plant.type .. ",Yield:" .. plant.yield .. ")")
                            i = i + 1
                        end
                    end
                end
                if #display_seed_names > 0 then
                    config.seed_name = dropdown("seed_name", starting_index, display_seed_names, "Seed to use", filtered_plants)
                end
                config.num_plants = drawNumberEditBox("num_plants", "How many to plant per run? ", 6)
                config.num_runs = drawNumberEditBox("num_runs", "How many runs? ", 20)
                config.click_delay = drawNumberEditBox("click_delay", "What should the click delay be? ", 100)
                config.alternate_drag = CheckBox(X_PADDING, current_y, 10, WHITE, "Alternate (slow) dragging?", config.alternate_drag or true)
                config.pre_look = CheckBox(X_PADDING, current_y + 20, 10, WHITE, "Pre-find plant locations?", config.pre_look or true)
                config.reposition_avatar = CheckBox(X_PADDING, current_y + 40, 10, WHITE, "Reposition avatar?", config.reposition_avatar or true)
                config.debug = CheckBox(X_PADDING, current_y + 60, 10, WHITE, "Show pretty debug pictures?", config.debug)
                config.sorting_mode = CheckBox(X_PADDING, current_y + 80, 10, WHITE, "Prioritize plants mode?", config.sorting_mode or true)
                got_user_params = true
                for k, v in pairs(config) do
                    got_user_params = got_user_params and v
                end
lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
                got_user_params = got_user_params and drawBottomButton(lsScreenX - 5, "Next step")
            else
                drawWrappedText(WARNING, RED, X_PADDING, current_y)

                is_done = drawBottomButton(lsScreenX - 5, "Start Script")
            end
        end
        if drawBottomButton(110, "Exit Script", RED) then
            error "Script exited by user"
        end

        write_config(config)
        lsDoFrame()
        lsSleep(10)
    end
    config.num_stages = config.plants[config.seed_name].stages
    config.num_waterings = config.plants[config.seed_name].waters
    config.seed_type = config.plants[config.seed_name].type
    click_delay = config.click_delay
    return config
end

string.lpad = function(str, len, char)
    if char == nil then
        char = ' '
    end
    if len <= 0 then
        return str
    else
        return str .. string.rep(char, len - 1)
    end
end

function seed_list(config)

end

function default_deep_config()
    return {
        ["plants"] = {
            ["Mut's Fruiton"] = {
                ["type"] = "Cabbage",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Bastet's Yielding"] = {
                ["type"] = "Cabbage",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Green Leaf"] = {
                ["type"] = "Carrots",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Osiris' Orange"] = {
                ["type"] = "Carrots",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Wadjet's Garden"] = {
                ["type"] = "Cucumbers",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Ma'ats Plow"] = {
                ["type"] = "Cucumbers",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Apep's Crop"] = {
                ["type"] = "Garlic",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Heket's Reaping"] = {
                ["type"] = "Garlic",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Hapi's Harvest"] = {
                ["type"] = "Leeks",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Horus' Grain"] = {
                ["type"] = "Leeks",
                ["waters"] = 3,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Tears of Sinai"] = {
                ["type"] = "Onions",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Amun's Bounty"] = {
                ["type"] = "Onions",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Isis' Bounty"] = {
                ["type"] = "Peppers",
                ["waters"] = 3,
                ["stages"] = 4,
                ["yield"] = 4,
            },
            ["Ptah's Breed"] = {
                ["type"] = "Peppers",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Ra's Fire"] = {
                ["type"] = "Peppers",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Isis' Bount"] = {
                ["type"] = "Watermelon",
                ["waters"] = 3,
                ["stages"] = 4,
                ["yield"] = 4,
            },
            ["Set's Vintage"] = {
                ["type"] = "Watermelon",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Geb's Produce"] = {
                ["type"] = "Watermelon",
                ["waters"] = 1,
                ["stages"] = 3,
                ["yield"] = 1,
            },
            ["Stranger's Solana"] = {
                ["type"] = "Eggplant",
                ["waters"] = 2,
                ["stages"] = 4,
                ["yield"] = 2,
            },
            ["Qetesh's Soil"] = {
                ["type"] = "Eggplant",
                ["waters"] = 2,
                ["stages"] = 3,
                ["yield"] = 2,
            },
            ["Isis' Boun"] = -- TODO DEAL WITH SAME SEED NAME FOR DIFFERENT TYPES
            {
                ["type"] = "Eggplant",
                ["waters"] = 3,
                ["stages"] = 4,
                ["yield"] = 4,
            },
            ["Isis Seed"] = -- TODO DEAL WITH SAME SEED NAME FOR DIFFERENT TYPES
            {
                ["type"] = "Eggplant",
                ["waters"] = 1,
                ["stages"] = 1,
                ["yield"] = 1,
            },
        },
        ["required_number_of_changed_pixels_before_clicking"] = {
            ["Leeks"] = 75,
            ["Cabbages"] = 25,
            ["Garlic"] = 25,
            ["Onions"] = 175,
            ["Default"] = 125
        },
        ["plant_yield_bonus"] = 0,
        ["end_of_run_wait"] = 3000,
        ["planting_batch_size"] = {
            ["Default"] = 4,
        },
        ["plant_location_order"] = {
            ["Default"] = {
                { direction = "SOUTH_EAST", number_of_moves = 1 },
                { direction = "NORTH_WEST", number_of_moves = 1 },
                { direction = "NORTH_EAST", number_of_moves = 1 },
                { direction = "SOUTH_WEST", number_of_moves = 1 },
                { direction = "NORTH", number_of_moves = 3 },
                { direction = "EAST", number_of_moves = 3 },
                { direction = "SOUTH", number_of_moves = 3 },
                { direction = "WEST", number_of_moves = 3 },
                { direction = "SOUTH_EAST", number_of_moves = 2 },
                { direction = "NORTH_WEST", number_of_moves = 2 },
                { direction = "NORTH_EAST", number_of_moves = 2 },
                { direction = "SOUTH_WEST", number_of_moves = 2 },
            }
        },
        ["stage_advance_timings"] = {
            ["Leeks"] = {
                [1] = 15000,
                ["Default"] = 13500,
            },
            ["Cabbages"] = {
                [1] = 16000,
                ["Default"] = 15000,
            },
            ["Carrots"] = {
                [1] = 16500,
                ["Default"] = 16000,
            },
            ["Garlic"] = {
                [1] = 17000,
                ["Default"] = 16000,
            },
            ["Default"] = {
                [1] = 17000,
                ["Default"] = 14000,
            },
        }
    }
end

function drawNumberEditBox(key, text, default)
    return drawEditBox(key, text, default, true)
end

function drawEditBox(key, text, default, validateNumber)
    drawTextUsingCurrent(text, WHITE)
    local width = lsPrint(-100, -100, 10, 0.7, 0.7, WHITE, text)
    local height = 30
    local done, result = lsEditBox(key, X_PADDING, current_y, 0, width, height, 1.0, 1.0, BLACK, default)
    if validateNumber then
        result = tonumber(result)
    elseif result == "" then
        result = false
    end
    if not result then
        local error = validateNumber and "Please enter a valid number!" or "Enter text!"
        drawText(error, RED, X_PADDING + width + 5, current_y + 5)
        result = false
    end
    current_y = current_y + 35
    return result
end

function drawTextUsingCurrent(text, colour)
    if not colour then
        colour = WHITE
    end
    drawText(text, colour, X_PADDING, current_y)
    current_y = current_y + 20
end

function drawText(text, colour, x, y)
    lsPrint(x, y, 10, 0.7, 0.7, colour, text)
end

function drawWrappedText(text, colour, x, y)
    current_y = current_y + lsPrintWrapped(x, y, 10, lsScreenX - 10, 0.6, 0.6, colour, text)
end

function drawBottomButton(xOffset, text, colour)
    return lsButtonText(lsScreenX - xOffset, lsScreenY - 30, z, 100, colour or WHITE, text)
end

function string:split(inSplitPattern, outResults)
    if not outResults then
        outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
    while theSplitStart do
        table.insert(outResults, string.sub(self, theStart, theSplitStart - 1))
        theStart = theSplitEnd + 1
        theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
    end
    table.insert(outResults, string.sub(self, theStart))
    return outResults
end
