-- Vegetable Macro for Tale 7 by thejanitor.
--
-- Thanks to veggies.lua for the build button locations
-- Updated 29-SEP-2017 by Silden to take into account UI changes that meant the windows would not close properly
-- Updated 30-SEP-2017 by Silden to increase default values to cater for long veg names, such as Cabbage

dofile("common.inc")
dofile("settings.inc")
--[[
dofile("veg_janitor/plant.inc")
dofile("veg_janitor/plant_controller.inc")
dofile("veg_janitor/util.inc")
dofile("veg_janitor/ui.inc")
dofile("veg_janitor/list.inc")
dofile("veg_janitor/vector.inc")
dofile("veg_janitor/screen.inc")
--]]
dofile("plant.inc")
dofile("plant_controller.inc")
dofile("util.inc")
dofile("ui.inc")
dofile("list.inc")
dofile("vector.inc")
dofile("screen.inc")


WARNING = [[
THIS IS A BETA MACRO YOU ARE USING AT YOUR OWN RISK
You must be in the fully zoomed in top down F8 F8 F8 view, Alt+L to lock the camere once there.
In User Options -> Interface Options -> Menu You must DISABLE: "Right-Click Pins/Unpins a Menu"
You Must ENABLE: "Right-Click opens a Menu as Pinned"
You Must ENABLE: "Use the chat area instead of popups for many messages"
In Options -> One-Click and Related -> You must DISABLE: "Plant all crops where you stand"
In Options -> Video -> You must set: Shadow Quality and Time of Day lighting to the lowest possible.
Do not move once the macro is running and you must be standing on a tile with water available to refill.
Do not stand directly on or within planting distance of actual animated water.
]]

RED = 0xFF2020ff
BLACK = 0x000000ff
WHITE = 0xFFFFFFff


-- Used to control the plant window placement and tiling.
WINDOW_HEIGHT = 120 -- Was 80
WINDOW_WIDTH = 240 -- Was 220
WINDOW_OFFSET_X = 150
WINDOW_OFFSET_Y = 150

function doit()
    while true do
        local config = makeReadOnly(getUserParams())
        askForWindowAndSetupGlobals(config)
        gatherVeggies(config)
    end
end

function askForWindowAndSetupGlobals(config)
    local min_jugs = config.num_waterings * config.num_plants * config.num_stages
    local min_seeds = config.num_plants
    local one = 'You will need ' .. min_jugs .. ' jugs of water and ' .. min_seeds .. ' seeds \n'
    local two = '\n Press Shift over ATITD window to continue.'
    askForWindow(one .. two)
    setupGlobals(config)
end

function setupGlobals(config)
    NORTH = Vector:new { 0, -1 }
    SOUTH = Vector:new { 0, 1 }
    WEST = Vector:new { -1, 0 }
    EAST = Vector:new { 1, 0 }
    NORTH_WEST = NORTH + WEST
    NORTH_EAST = NORTH + EAST
    SOUTH_WEST = SOUTH + WEST
    SOUTH_EAST = SOUTH + EAST
    DOUBLE_SOUTH = SOUTH * 2
    DOUBLE_NORTH = NORTH * 2
    DOUBLE_WEST = WEST * 2
    DOUBLE_EAST = EAST * 2

    MOVE_BTNS = {
        [NORTH] = Vector:new { 48, 30 },
        [SOUTH] = Vector:new { 48, 71 },
        [NORTH_EAST] = Vector:new { 70, 30 },
        [WEST] = Vector:new { 30, 50 },
        [EAST] = Vector:new { 70, 50 },
        [NORTH_WEST] = Vector:new { 30, 30 },
        [SOUTH_EAST] = Vector:new { 70, 67 },
        [SOUTH_WEST] = Vector:new { 30, 67 }
    }
    PLANT_LOCATIONS = { next = 1 }

    DIRECTIONS = {
        ['NORTH'] = NORTH,
        ['SOUTH'] = SOUTH,
        ['WEST'] = EAST,
        ['EAST'] = WEST,
        ['NORTH_WEST'] = NORTH_WEST,
        ['NORTH_EAST'] = NORTH_EAST,
        ['SOUTH_WEST'] = SOUTH_WEST,
        ['SOUTH_EAST'] = SOUTH_EAST
    }

    -- TODO FIX HORRIBLE GLOBAL HACK
    seed_type = config.seed_type
    for i, direction in ipairs(config.plant_location_order[config.seed_type] or config.plant_location_order["Default"]) do
        PlantLocation:new { direction_vector = DIRECTIONS[direction.direction], num_move_steps = (direction.number_of_moves or 1) }
    end

    makeReadOnly(PLANT_LOCATIONS)

    local mid = getScreenMiddle()
    ANIMATION_BOX = makeBox(mid.x - 60, mid.y - 50, 105, 85)
    PLAYER_BOX = makeBox(mid.x - 40, mid.y - 7, 80, 55)
    ARM_BOX = makeBox(mid.x - 90, mid.y - 20, 80, 25)
end

PlantLocation = {}
function PlantLocation:new(o)
    o.move_btn = MOVE_BTNS[o.direction_vector]
    if o.num_move_steps then
        o.direction_vector = o.direction_vector * o.num_move_steps
    else
        o.num_move_steps = 1
    end
    PLANT_LOCATIONS[o.direction_vector] = o
    PLANT_LOCATIONS[PLANT_LOCATIONS.next] = o
    PLANT_LOCATIONS.next = PLANT_LOCATIONS.next + 1
    o.box = makeSearchBox(o.direction_vector, seed_type)
    return newObject(PlantLocation, o, true)
end

function PlantLocation:move()
    -- TODO Only search in the top left region of the screen to improve performance
    local build_arrows = findImage("veg_janitor/build_arrows.png")
    if not build_arrows then
        playErrorSoundAndExit("Failed to find the build arrows")
    end
    for step = 1, self.num_move_steps do
        click(self.move_btn + Vector:new { build_arrows[0], build_arrows[1] }, false, false)
    end
end

function PlantLocation:show()
    lsPrintln("shOWing")
    displayBox(self.box, false, 3000)
end

function displayBox(box, forever, time)
    local start = lsGetTimer()
    moveMouse(Vector:new { box.left, box.top })
    while forever or (time and (lsGetTimer() - start) < time) do
        srReadScreen()
        srMakeImage("box", box.left, box.top, box.width, box.height)
        srShowImageDebug("box", 0, current_y, 0, 1)
        checkBreak()
        if forever or time then
            lsDoFrame()
            lsSleep(10)
        else
            current_y = current_y + box.height
        end
    end
end

function displayBoxes(boxes, forever)
    while forever do
        for i, v in ipairs(boxes) do
            srShowImageDebug(v, 0, (i - 1) * 200, 0, 1)
        end
        checkBreak()
        lsDoFrame()
        lsSleep(10)
    end
end

function saveBox(box, name)
    srReadScreen()
    srMakeImage(name, box.left, box.top, box.width, box.height)
end

function repositionAvatar()
    local mid = getScreenMiddle()
    statusScreen("Repositioning Avatar to face N/S ...");
    safeClick(mid.x - 10, mid.y - 100);
    lsSleep(500);
    safeClick(mid.x - 10, mid.y + 170);
    lsSleep(500);
end

SPEED_MODE = false

function checkBreakIfNotSpeed()
    if not SPEED_MODE then
        checkBreak()
    end
end

function debugSearchBoxes(config, plants)
    for i = 1, config.num_plants do
        srReadScreen()
        local buildButton = clickPlantButton(config.seed_name)
        srReadScreen()

        plants[i].location:move()
        plants[i].location:show()
        safeClick(buildButton[0] + 70, buildButton[1])
    end
end

function preLocatePlants(config, plants)
    local box = makeLargeSearchBoxAroundPlayer()
    local starting_pixels = getBoxPixels(box)
    local previous_plants = {}
    for i = 1, config.num_plants do
        srReadScreen()
        local buildButton = clickPlantButton(config.seed_name)
        srReadScreen()

        plants[i].location:move()
        lsSleep(100)
        while not plants[i]:findPlantAndSave(starting_pixels, box, previous_plants) do
            checkBreakIfNotSpeed()
            lsSleep(100)
        end

        safeClick(buildButton[0] + 70, buildButton[1])
    end
    for i = 1, config.num_plants do
        local min_x, min_y, max_x, max_y = box.width, box.height, 0, 0
        local plant_search_area = {}
        local total = 0
        for y = 0, box.height, 1 do
            plant_search_area[y] = {}
            for x = 0, box.width do
                if previous_plants[y] and previous_plants[y][x] then
                    local bit = 1 << i
                    if previous_plants[y][x] == bit then
                        total = total + 1
                        plant_search_area[y][x] = true
                        if x > max_x then
                            max_x = x
                        end
                        if y > max_y then
                            max_y = y
                        end
                        if min_y > y then
                            min_y = y
                        end
                        if min_x > x then
                            min_x = x
                        end
                    end
                end
            end
        end
        local shrunk_area = {}
        local shrunk_box = makeBox(box.left + min_x, box.top + min_y, max_x - min_x, max_y - min_y)
        for y = 0, shrunk_box.height, 1 do
            shrunk_area[y] = {}
            for x = 0, shrunk_box.width do
                if plant_search_area[y + min_y][x + min_x] then
                    shrunk_area[y][x] = true
                end
            end
        end

        plants[i]:set_search_box(shrunk_box, shrunk_area)
    end
    if config.debug then
        for i = 1, config.num_plants do
            for y = box.top, box.top + box.height, 1 do
                for x = box.left, box.left + box.width do
                    local sbox = plants[i].search_box.box
                    local area = plants[i].search_box.area
                    local colour = BLACK
                    local inside_player = inside(Vector:new { x, y }, sbox)
                    if inside_player then
                        colour = WHITE
                    end
                    if inside_player and area[y - sbox.top] and area[y - sbox.top][x - sbox.left] then
                        colour = RED
                    end
                    lsDisplaySystemSprite(1, x - box.left, y - box.top, 1, 1, 1, colour)
                end
            end
            lsDoFrame()
            lsSleep(500)
        end
        local colours = { GREEN, RED, BLUE, YELLOW, PINK, BROWN, PURPLE, LIGHT_BLUE, GREEN, RED, BLUE, YELLOW }
        for y = box.top, box.top + box.height, 1 do
            for x = box.left, box.left + box.width do
                local found = false
                local colour = BLACK
                for i = 1, config.num_plants do
                    local sbox = plants[i].search_box.box
                    local area = plants[i].search_box.area
                    local inside_player = inside(Vector:new { x, y }, sbox)
                    if colour == BLACK and inside_player then
                        colour = WHITE
                    end
                    if inside_player and area[y - sbox.top] and area[y - sbox.top][x - sbox.left] then
                        colour = colours[i]
                        if found then
                            error("Already found at " .. x .. " ," .. y)
                        end
                        found = true
                    end
                end
                lsDisplaySystemSprite(1, x - box.left, y - box.top, 1, 1, 1, colour)
            end
        end
        lsDoFrame()
        lsSleep(500)
    end
end

function gatherVeggies(config)
    safeBegin()
    srReadScreen()
    closeEmptyAndErrorWindows()
    drawWater()
    local plants = Plants:new { num_plants = config.num_plants, seed_type = config.seed_type,
                                seed_name = config.seed_name,
                                alternate_drag = config.alternate_drag, config = config }
    for i = 1, config.num_runs do
        checkPlantButton()
        if config.reposition_avatar then
            repositionAvatar()
        end
        if config.pre_look then
            preLocatePlants(config, plants)
        end
        local batch_size = config.planting_batch_size[config.seed_type] or config.planting_batch_size["Default"]
        local sortable_plant_list = {}
        for i = 1, math.min(batch_size, config.num_plants) do
            table.insert(sortable_plant_list, plants[i])
        end
        lsPrintln("Config run " .. i)
        local start = lsGetTimer()

        checkBreakIfNotSpeed()
        local num_finished = 0
        local plant_finished = {}
        local num_watering = 0
        local found = {}
        local i = 1
        while num_finished < #sortable_plant_list do
            checkBreakIfNotSpeed()
            local plant = sortable_plant_list[i]
            if plant:finished() and not plant_finished[plant.index] then
                num_finished = num_finished + 1
                plant_finished[plant.index] = true
            end
            if not found[plant.index] and (plant.window_open and not plant_finished[plant.index]) then
                num_watering = num_watering + 1
                found[plant.index] = true
            end
            local num_planted = #sortable_plant_list
            if num_watering == num_planted then
                for i = num_planted + 1, math.min(num_planted + batch_size, config.num_plants) do
                    table.insert(sortable_plant_list, plants[i])
                end
            end

            plant:tick(config)
            if config.sorting_mode then
                sort_plants(sortable_plant_list)
            else
                i = i + 1
                if i > #sortable_plant_list then
                    i = 1
                end
            end
            display_plants(plants)
            checkBreakIfNotSpeed()
        end

        lsSleep(click_delay)
        drawWater()
        lsSleep(click_delay * 5)
        checkBreak()

        closeEmptyAndErrorWindows()
        local stop = lsGetTimer() + config.end_of_run_wait
        local yield = config.plant_yield_bonus + config.plants[config.seed_name].yield
        local total = math.floor((3600 / ((stop - start) / 1000)) * config.num_plants * yield) -- default 3, currently 9 veggie yield with pyramids bonus
        sleepWithStatus(config.end_of_run_wait, "Running at " .. total .. " veg per hour. ")
        for i = 1, config.num_plants do
            plants[i]:resetOtherThanSavedPosition()
        end
    end
end

function sort_plants(plants)
    table.sort(plants, function(first, second)
        --local comp = first:time_till_death() - second:time_till_death()
        --if comp > 0 then
        --    return false
        --elseif comp < 0 then
        --    return true
        --else
        --    return first.last_ticked_time < second.last_ticked_time
        --end
        --        return first.last_ticked_time < second.last_ticked_time
        if first:time_till_death() < 16000 or second:time_till_death() < 16000 then
            local comp = first:time_till_death() - second:time_till_death()
            if comp > 0 then
                return false
            elseif comp < 0 then
                return true
            else
                return first.last_ticked_time < second.last_ticked_time
            end
        else
            return first.last_ticked_time < second.last_ticked_time
        end
    end)
end

function display_plants(plants)
    current_y = 10
    for index, plant in ipairs(plants) do
        local last_ticked_string = plant.last_ticked_time == 0 and "never" or (lsGetTimer() - plant.last_ticked_time)
        local status = plant:status()
        if type(status) == "string" then
            drawTextUsingCurrent(plant.index .. " is " .. plant:status() .. " ticked " .. last_ticked_string)
        else
            drawTextUsingCurrent(plant.index .. " in growth stage " .. status.stage .. " , next stage in: " .. math.floor(status.next_in / 1000) .. "s, ticked at " .. last_ticked_string)
            local colours = {PINK, PURPLE, BLUE, LIGHT_BLUE}
            local x_so_far = 5
            for i, time in ipairs(status.times) do
                local width
                local colour = colours[i]
                if i == status.stage then
                    width = status.next / 250
                    colour = RED
                else
                    width = time / 250
                end
                lsDisplaySystemSprite(1, x_so_far, current_y, 1, width, 30, colour)
                x_so_far = x_so_far + width
            end
            current_y = current_y + 30
        end
    end
    lsDoFrame()
end

-- Simple container object which constructs N plants and allows iteration over them.
Plants = {}
function Plants:new(o)
    for index = 1, o.num_plants do
        local location = PLANT_LOCATIONS[index]
        lsPrintln("Making plant " .. index .. " with location " .. location.direction_vector.x .. " , " .. location.direction_vector.y)
        self[index] = PlantController:new(
                index,
                location,
                o.alternate_drag,
                indexToWindowPos(index),
                o.seed_name,
                o.seed_type,
                o.config.num_waterings,
                o.config
        )
    end
    return newObject(self, o, true)
end

function Plants:iterate(func, args)
    for index = 1, self.num_plants do
        func(self[index], args)
    end
end

-- Tiling method from Cinganjehoi's original bash script. Tried out the automato common ones but they are slow
-- and broke sometimes? This is super simple and its not the end of the world if it breaks a little during a run.
function indexToWindowPos(index)
    local columns = getNumberWindowColumns()
    local x = WINDOW_WIDTH * ((index - 1) % columns) + WINDOW_OFFSET_X
    local y = WINDOW_HEIGHT * math.floor((index - 1) / columns) + WINDOW_OFFSET_Y
    return Vector:new { x, y }
end

function getNumberWindowColumns()
    local xyWindowSize = srGetWindowSize()
    local width = xyWindowSize[0] * 0.6
    return math.floor(width / WINDOW_WIDTH);
end



-- Create a table of direction string -> box. Each box is where we will search the plant placed for that given direction
-- string.
-- Full of janky hardcoded values.
-- TODO: Make debuging this easier, figure out pixel scaling for different resolutions, get rid of magic numbers.
function makeSearchBox(direction, seed_type)
    local xyWindowSize = srGetWindowSize()
    local search_size = (seed_type == "Onions") and 125 or 75
    local mid = getScreenMiddle()

    local centre_of_plant = direction * 40 + mid
    --    local offset_mid = mid - { math.floor(search_size / 3), math.floor(search_size / 3) }
    --
    --    local top_left = offset_mid + direction * 40 - Vector:new { 25, 20 }
    local top_left = mid + direction * 40 - { math.floor(search_size / 2), math.floor(search_size / 2) }

    local box = makeBox(top_left.x, top_left.y, search_size, search_size)
    box.direction = direction
    return box
end

function makeLargeSearchBoxAroundPlayer()
    local search_size = 500
    local mid = getScreenMiddle()
    local top_left = mid - { math.floor(search_size / 2), math.floor(search_size / 2) }
    return makeBox(top_left.x, top_left.y, search_size, search_size)
end
