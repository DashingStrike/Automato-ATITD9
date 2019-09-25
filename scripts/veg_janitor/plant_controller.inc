dofile("veg_janitor/util.inc")
dofile("veg_janitor/plant.inc")
dofile("veg_janitor/vector.inc")
dofile("veg_janitor/screen.inc")

BLACK = 0x000000ff
WHITE = 0xFFFFFFff
RED = 0xFF2020ff
GREEN = 0x66CD00ff
YELLOW = 0xffff00ff
PINK = 0xffc0cbff
BROWN = 0xFFEBCDff
BLUE = 0x0000ffff
PURPLE = 0xcd00ffff
LIGHT_BLUE = 0x00ffe4ff

PlantController = {}
function PlantController:new(index, location, alternate_drag, window_pos, seed_name, seed_type, num_water_times, config)
    if index == nil or location == nil or alternate_drag == nil or window_pos == nil or num_water_times == nil or config == nil then

        error("Invalid or missing arguments for PlantController:new")
    end
    local o = {}
    o.config = config
    o.index = index
    o.state = "unplanted"
    o.location = location
    o.alternate_drag = alternate_drag
    o.window_pos = window_pos
    o.seed_name = seed_name
    o.seed_type = seed_type
    o.last_ticked_time = 0
    o.saved_plant_location = false
    o.saved_plant_pixel = false
    o.window_open = false
    o.num_water_times = num_water_times
    o.plant = nil
    o.plant_time = nil
    o.beforePlantPixels = nil
    o.last_clicked_plant_at = 0
    o.undragged_window_open = false
    o.dragged_at = 0
    return newObject(self, o)
end

function PlantController:resetOtherThanSavedPosition()
    self.state = "unplanted"
    self.last_ticked_time = 0
    self.window_open = false
    self.plant = nil
    self.plant_time = nil
    self.beforePlantPixels = nil
    self.last_clicked_plant_at = 0
    self.undragged_window_open = false
    self.dragged_at = 0
    self.saved_plant_location = false
    self.saved_plant_pixel = false
    self.search_box = nil
end

function PlantController:time_till_death()
    if self.state == "unplanted" then
        return 10000
    elseif self.state == "searching" then
        return 10000
    elseif self.state == "opening" then
        return 10000
    elseif self.state == "growing" then
        return self.plant:time_till_death()
    elseif self.state == "complete" then
        return 100000
    elseif self.state == "closed" then
        return 100000
    else
        error("Unknowng controller state in time_till_death " .. self.state)
    end
end
function PlantController:status()
    if self.state == "unplanted" then
        return "unplanted"
    elseif self.state == "searching" then
        return "searching"
    elseif self.state == "opening" then
        return "opening"
    elseif self.state == "growing" then
        return self.plant:status()
    elseif self.state == "complete" then
        return "complete"
    elseif self.state == "closed" then
        return "closed"
    else
        error("Unknowng controller state in status " .. self.state)
    end
end

function PlantController:finished()
    return self.state == "complete"
end

function PlantController:tick()
    self.last_ticked_time = lsGetTimer()
    if self.state == "closed" then
        return self.state
    end
    if self:dead() then
        self.state = "complete"
        return self.state
    end
    if self.state == "unplanted" then
        self:grow_plant()
        self.state = "searching"
    elseif self.state == "searching" then
        if self:search() then
            self.state = "opening"
        end
    elseif self.state == "opening" then
        if self:openBedWindow() then
            local pin = find_and_click_image("pin", self.window_pos)
            self.window_open = true
            self.state = "growing"
        end
    elseif self.state == "growing" then
        if self.plant:tick() ~= "growing" then
            self.state = "complete"
        end
    elseif self.state == "complete" then
        self:close()
        self.state = "closed"
    end
    return self.state
end

function PlantController:dead()
    local search_box = makeBox(self.window_pos.x - 10, self.window_pos.y - 50, 150, 70)
    srReadScreen()
    local dead = findImage("veg_janitor/dead.png", search_box)
    return dead or not self.window_open and (self.plant_time and (lsGetTimer() - self.plant_time) > 7000)
end

function PlantController:close()
    -- New UI changes affected the closing of finished windows.
    -- Now look for the UnPin image, and safeClick it closed if found.

    local search_box = makeBox(self.window_pos.x + 20, self.window_pos.y - 50, 220, 80)
    srReadScreen()
    local unpin_loc = srFindImageInRange("UnPin.png", search_box.left, search_box.top, search_box.width, search_box.height, 4800)
    if unpin_loc then
        safeClick(unpin_loc[0], unpin_loc[1]);
    else
        lsPrintln("Didn't find unpin image for plant " .. self.index .. " looking left:" .. search_box.left .. ", top: " .. search_box.top .. ", width: " .. search_box.width .. ", height: " .. search_box.height .. ".");
        return
    end
end

function PlantController:snapshot()
    self.beforePlantPixels = getBoxPixels(self.location.box)
end

function PlantController:grow_plant()
    -- Take of a snapshot of the area in which we are guessing the plant will be placed before we actually create
    -- and place it.
    if not self.saved_plant_location then
        lsSleep(click_delay)
        lsPrintln("Haven't got a saved plant location, taking snapshot of before pixels now at " .. tostring(self.location))
        self:snapshot()
    end

    local buildButton = clickPlantButton(self.seed_name)
    self.location:move()
    safeClick(buildButton[0], buildButton[1])
    self.plant_time = lsGetTimer()
    self.plant = Plant:new(self.index, self.plant_time, self, self.config)
end

function PlantController:findPlantAndSave(no_plants_pixels, box, previous_plants)
    local vec_and_pix = ScreenSearcher:new(self.index, self.seed_type, previous_plants, self.config):findChangedRow(no_plants_pixels, box)
    if vec_and_pix then
        --        self.saved_plant_location = vec_and_pix.vector
        --        self.saved_plant_pixel = vec_and_pix.pixel
        --        moveMouse(self.saved_plant_location)
        --        lsSleep(2000)
        return true
    else
        return false
    end
end

function clickPlantButton(seed_name)
    local build_menu_opened = false
    while not build_menu_opened do
        local plantButton = findText(seed_name)
        if plantButton then
            clickText(plantButton, 1)
            build_menu_opened = waitForImage("veg_janitor/build_button.png", 1000, "Waiting for build button to appear")
        else
            playErrorSoundAndExit("Text " .. seed_name .. " Not found.")
        end
        sleepWithStatus(tick_delay, "Planting...") --Retrying build menu open
    end
    return build_menu_opened
end

function checkPlantButton()
    local plantButton = findText(seed_name)
    if not plantButton then
        playErrorSoundAndExit("Text " .. seed_name .. " Not found.")
    end

end

function PlantController:find_and_click_self()
    return find_and_click_image("this_is", self.window_pos)
end

function PlantController:harvest()
    local this_vec = self:find_and_click_self()
    if not this_vec then
        return false
    end

    local harvest_vec = findImageInWindowVec("harvest", self.window_pos)
    if not harvest_vec then
        return false
    end
    if harvest_vec then
        click(harvest_vec)
        lsSleep(click_delay / 2)
        return self:dead()
    else
        return false
    end
end

function PlantController:water()
    local water_vec = findImageInWindowVec("water", self.window_pos)
    if not water_vec then
        local this_vec = self:find_and_click_self()
        if not this_vec then
            return false
        end
        water_vec = findImageInWindowVec("water", self.window_pos)
        if not water_vec then
            return false
        end
    end

    for _ = 1, self.num_water_times do
        click(water_vec)
        lsSleep(20)
    end
    return true
end

function PlantController:search()
    if not self.saved_plant_location then
        local searcher = ScreenSearcher:new(self.index, self.seed_type, false, self.config, self.search_box)
        local vec_and_pix = searcher:findChangedRow(self.beforePlantPixels, self.location.box)
        if vec_and_pix then
            self.saved_plant_location = vec_and_pix.vector
            self.saved_plant_pixel = vec_and_pix.pixel
            return true
        else
            --self.beforePlantPixels = searcher.new_pixels
            return false
        end
    else
        return true
    end
end

function PlantController:openBedWindow()
    -- TODO: problably do something different as this is the only thing that takes mouse control from the user.
    if self.alternate_drag then

        if not self.undragged_window_open and (not self.last_clicked_plant_at or (lsGetTimer() - self.last_clicked_plant_at) > 500) then
            local current_pixel = srReadPixel(self.saved_plant_location.x, self.saved_plant_location.y)
            local new_colour = classifyColour(current_pixel, self.seed_type)
            local click_colour = classifyColour(self.saved_plant_pixel, self.seed_type)
            local pixel_same = new_colour == click_colour
            if pixel_same then
                self.last_clicked_plant_at = lsGetTimer()
                click(self.saved_plant_location, true, true)
                lsSleep(100)
            else
                lsPrintln("Pixel doesn't match " .. click_colour .. " instead it's " .. new_colour)
            end
        end
        if findImageInWindowVec("this_is", self.saved_plant_location) and (not self.dragged_at or (lsGetTimer() - self.dragged_at) > 500) then
            self.undragged_window_open = true
            drag(self.saved_plant_location.x + 10, self.saved_plant_location.y + 10, self.window_pos.x, self.window_pos.y, click_delay * 2)
            lsSleep(100)
            self.dragged_at = lsGetTimer()
            self.window_open = findImageInWindowVec("this_is", self.window_pos)
            return self.window_open
        else
            self.window_open = findImageInWindowVec("this_is", self.window_pos)
            return self.window_open
        end
    else
        -- Wierd hacky thing, move the mouse to where the window will be and then safeClick the plant which causes
        -- the window to open instantly at the desired location and not where we clicked the plant.
        moveMouse(self.window_pos)
        click(self.saved_plant_location, 1)
        self.window_open = findImageInWindowVec("this_is", self.window_pos)
        return self.window_open
    end
end

function PlantController:set_search_box(box, area)
    self.search_box = { box = box, area = area }
    self.location.box = box
end

ScreenSearcher = {}
function ScreenSearcher:new(index, seed_type, previous_plants, config, search_box)
    local o = {}
    o.config = config
    o.index = index
    o.labels = {}
    o.current_label = 1
    o.total_changed = 0
    o.new_pixels = {}
    o.max = 0
    o.max_label = 0
    o.search_box = search_box
    o.seed_type = seed_type
    o.previous_plants = previous_plants
    return newObject(self, o)
end

function ScreenSearcher:findChangedRow(pixels, box)

    srReadScreen()

    if self.search_box then
        box = self.search_box.box
    end
    lsPrintln("Using :" .. box.left .. " top:" .. box.top .. " width : " .. box.width .. " height " .. box.height)

    local max_label_queue
    self.label_widths = {}

    for y = 0, box.height, 1 do
        self.new_pixels[y] = self.new_pixels[y] or {}
        self.labels[y] = self.labels[y] or {}
        for x = 0, box.width do
            self:getAndCacheNewPixels(box, x, y)
            if not self.labels[y][x] then
                if self:pixelDiff(pixels, x, y, box, self:should_classify()) then


                    local queue = List.new()
                    local current_label_queue = List.new()
                    self.labels[y][x] = self.current_label
                    local current_label_count = 1
                    List.pushright(queue, { y = y, x = x })

                    self.label_widths[self.current_label] = { widths = {}, min_x = {} }
                    self.label_widths[self.current_label].widths[y] = 1
                    self.label_widths[self.current_label].min_x[y] = x
                    repeat
                        local next_pixel = List.popright(queue)
                        if next_pixel then
                            current_label_count = current_label_count + 1
                            List.pushright(current_label_queue, { y = next_pixel.y, x = next_pixel.x })
                            self.total_changed = self.total_changed + 1
                            self:update(queue, pixels, next_pixel.y - 1, next_pixel.x, box)
                            self:update(queue, pixels, next_pixel.y + 1, next_pixel.x, box)
                            self:update(queue, pixels, next_pixel.y, next_pixel.x + 1, box)
                            self:update(queue, pixels, next_pixel.y, next_pixel.x - 1, box)
                        end
                        if current_label_count > self.max then
                            max_label_queue = current_label_queue
                            self.max_label = self.current_label
                            self.max = current_label_count
                        end
                    until not next_pixel

                    self.current_label = self.current_label + 1

                else
                    self.labels[y][x] = -1
                end
            end

            if self.previous_plants and self:pixelDiff(pixels, x, y, box, self:should_classify()) then
                if not self.previous_plants[y] then
                    self.previous_plants[y] = {}
                end
                self.previous_plants[y][x] = (self.previous_plants[y][x] or 0) | (1 << self.index)
            end
        end
    end

    lsPrintln("TOTAL CHANGED " .. self.total_changed .. " MAX " .. (self.max_label or "no max") .. " has changed size " .. (self.max or " no max "))

    if self:number_of_changed_pixels_is_large_enough() then
        if true or self.seed_type == "Leeks" then
            local innermost_pixel = self:find_innermost_pixel_for_label(max_label_queue)
            local x = box.left + innermost_pixel.x
            local y = box.top + innermost_pixel.y
            return { vector = Vector:new { x, y }, pixel = srReadPixelFromBuffer(x, y) }
        else

            local max_width = 0
            local max_width_y = false
            for k, v in pairs(self.label_widths[self.max_label].widths) do
                if v > max_width then
                    max_width_y = k
                    max_width = v
                end
            end
            local max_segment_length = 0
            local max_segment_start = false
            local current_segment_start = false
            local current_segment_length = 0
            for x = 0, box.width do
                local check = self.labels[max_width_y][x] == self.max_label
                if check and not current_segment_start then
                    current_segment_start = x
                    current_segment_length = 1
                elseif check and current_segment_start then
                    current_segment_length = current_segment_length + 1
                elseif not check and current_segment_start then
                    current_segment_start = false
                end
                if current_segment_length > max_segment_length then
                    max_segment_length = current_segment_length
                    max_segment_start = current_segment_start
                end
            end

            local box_x = max_segment_start + math.floor(max_segment_length / 2)
            local box_y = max_width_y
            local x = box.left + box_x
            local y = box.top + box_y
            return { vector = Vector:new { x, y }, pixel = srReadPixelFromBuffer(x, y) }
        end
    else
        return false
    end
end

function ScreenSearcher:find_innermost_pixel_for_label(queue)
    local last_pixel
    local edge_pixels = {}
    local i = 1
    local inner_pixels = List.new()
    local start = lsGetTimer()
    repeat
        repeat
            local next_pixel = List.popright(queue)
            if next_pixel then
                local is_edge = false
                is_edge = is_edge or self:get_label(next_pixel.x, next_pixel.y - 1, edge_pixels, i) ~= self.max_label
                is_edge = is_edge or self:get_label(next_pixel.x, next_pixel.y + 1, edge_pixels, i) ~= self.max_label
                is_edge = is_edge or self:get_label(next_pixel.x + 1, next_pixel.y, edge_pixels, i) ~= self.max_label
                is_edge = is_edge or self:get_label(next_pixel.x - 1, next_pixel.y, edge_pixels, i) ~= self.max_label
                if not is_edge then
                    List.pushright(inner_pixels, next_pixel)
                else
                    edge_pixels[next_pixel.y] = edge_pixels[next_pixel.y] or {}
                    edge_pixels[next_pixel.y][next_pixel.x] = i
                end
                last_pixel = next_pixel
            end
        until not next_pixel
        i = i + 1
        queue = inner_pixels
        inner_pixels = List.new()
    until List.empty(queue) or i > 4
    print("Found click for " .. self.index .. " in " .. (lsGetTimer() - start))
    return last_pixel
end

function ScreenSearcher:get_label(x, y, edge_pixels, i)
    if edge_pixels[y] and edge_pixels[y][x] and i > edge_pixels[y][x] then
        return "-1"
    else
        return self.labels[y] and self.labels[y][x]
    end
end

function ScreenSearcher:number_of_changed_pixels_is_large_enough()
    if self.config.required_number_of_changed_pixels_before_clicking[self.seed_type] then
        return self.max_label > 0 and self.max > self.config.required_number_of_changed_pixels_before_clicking[self.seed_type]
    else
        return self.max_label > 0 and self.max > self.config.required_number_of_changed_pixels_before_clicking["Default"]
    end
end

function ScreenSearcher:update(queue, pixels, y, x, box)
    if (not self.labels[y] or not self.labels[y][x]) then
        self.labels[y] = self.labels[y] or {}
        if self:pixelDiff(pixels, x, y, box, self:should_classify()) then
            self.labels[y][x] = self.current_label
            if not self.label_widths[self.current_label].widths[y] then
                self.label_widths[self.current_label].widths[y] = 1
                self.label_widths[self.current_label].min_x[y] = x
            else
                self.label_widths[self.current_label].widths[y] = self.label_widths[self.current_label].widths[y] + 1
                if self.label_widths[self.current_label].min_x[y] > x then
                    self.label_widths[self.current_label].min_x[y] = x
                end
            end
            List.pushright(queue, { y = y, x = x })
        else
            self.labels[y][x] = -1
        end
    end
end

function ScreenSearcher:getAndCacheNewPixels(box, x, y)
    if not self.new_pixels[y] then
        self.new_pixels[y] = {}
    end
    if not self.new_pixels[y][x] then
        self.new_pixels[y][x] = srReadPixelFromBuffer(box.left + x, box.top + y)
    end
    return self.new_pixels[y][x]
end

function boxesOverlap(a, b)
    return a.left <= b.right and a.right >= b.left and a.top <= b.bottom and a.bottom >= b.top
end

function classifyColour(colourRGBA, seed_type)
    local colour = toColour(colourRGBA)
    local r = colour[1]
    local g = colour[2]
    local b = colour[3]
    if seed_type == "Onions" then
        --        lsPrintln("R " .. r .. " G " .. g .. " B " .. b)
        if b < 40 then
            return "G"
        elseif g >= r and b > 120 then
            return "W"
        else
            return "Y"
        end
    else
        return colourRGBA
    end
end

function ScreenSearcher:should_classify()
    return self.seed_type == "Onions"
end

function ScreenSearcher:pixelDiff(pixels, x, y, box, classify)
    if not self.search_box or (y >= 0 and y <= box.height and x >= 0 and x <= box.width and self.search_box.area[y][x]) then
        local inside_player = inside(Vector:new { box.left + x, box.top + y }, PLAYER_BOX)
        if not inside_player then
            if classify then
                local old_colour = "Y"
                local new_colour = "W"
                if (pixels[y] and pixels[y][x] and classifyColour(pixels[y][x], self.seed_type)) == old_colour then
                    local new_pixel = self:getAndCacheNewPixels(box, x, y)
                    return classifyColour(new_pixel, self.seed_type) == new_colour
                end
                --if (pixels[y] and pixels[y][x] and classifyColour(pixels[y][x], self.seed_type)) then
                --    local new_pixel = self:getAndCacheNewPixels(box, x, y)
                --    return classifyColour(new_pixel, self.seed_type) ~= classifyColour(pixels[y][x], self.seed_type)
                --end
            else
                if pixels[y] and pixels[y][x] then
                    local new_pixel = self:getAndCacheNewPixels(box, x, y)
                    return new_pixel ~= pixels[y][x]
                end
            end
        end
    end
    return false
end

function toColour(pixelRGBA)
    local rgb = math.floor(pixelRGBA / 256)
    local red = (rgb >> 16) & 0xFF;
    local green = (rgb >> 8) & 0xFF;
    local blue = rgb & 0xFF;
    --  lsPrintln("White R=" .. red .. " G=" .. green .. " B=" .. blue)
    return { red, green, blue }
end

function inside(vector, box)
    local x, y = vector.x, vector.y
    return (x >= box.left and x <= box.right) and (y >= box.top and y <= box.bottom)
end


