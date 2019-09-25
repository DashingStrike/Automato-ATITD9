dofile("veg_janitor/util.inc")

Plant = {}
function Plant:new(index, plant_time, controller, config)
    if plant_time == nil or index == nil or controller == nil then
        error("Invalid or missing arguments for Plant:new")
    end
    local o = {}
    o.config = config
    o.index = index
    o.number_of_growth_stages = 3
    o.stage = 1
    o.plant_time = plant_time
    o.seed_type = controller.seed_type
    o.current_stage_started_at = plant_time
    o.previous_stage_ended_at = plant_time
    o.next_stage_starts_at = plant_time + time_till_stage_advances(o.stage, o.seed_type, o.config)
    o.current_stage_watered = false
    o.controller = controller
    return newObject(self, o)
end

function Plant:fully_grown()
    return self.stage > self.number_of_growth_stages
end

function Plant:dead()
    return self.stage == 0
end

function Plant:status()
    local stage_times = {}
    for i = self.stage, 1, -1 do
        stage_times[i] = time_till_stage_advances(i, self.seed_type, self.config)
    end
    return { stage = self.stage, next = stage_times[self.stage] - (self.next_stage_starts_at - lsGetTimer()),
             times = stage_times, next_in = self.next_stage_starts_at - lsGetTimer() }
end

function Plant:tick()
    if self:dead() then
        return "dead"
    end
    if self:fully_grown() then

        -- TODO Move out of Plant class
        if not self.last_harvest_attempt or (lsGetTimer() - self.last_harvest_attempt) > 500 then
            self.last_harvest_attempt = lsGetTimer()
            if self.controller:harvest() then
                self.harvested = true
                return "harvested"
            end
        end
    else
        if lsGetTimer() > self.next_stage_starts_at then
            self.previous_stage_ended_at = self.next_stage_starts_at
            self:change_stage(self.current_stage_watered and 1 or -1)
        end
        if self.stage <= self.number_of_growth_stages then
            if not self.current_stage_watered then
                self.current_stage_watered = self:water()
            end
        end
    end
    return "growing"
end

function Plant:finished()
    return self:dead() or (self.harvested)
end

function Plant:change_stage(direction)
    lsPrintln("Plant " .. self.index .. " changing stage at " .. (lsGetTimer() - self.plant_time) ..
            " in stage " .. self.stage .. " to stage " .. (self.stage + direction))
    self.stage = self.stage + direction
    self.current_stage_watered = false
    self.next_stage_starts_at = lsGetTimer() + time_till_stage_advances(self.stage, self.seed_type, self.config)
end

function time_till_stage_advances(stage, seed_type, config)
    local timings = config.stage_advance_timings[seed_type] or config.stage_advance_timings["Default"]
    return timings[stage] or timings["Default"]
end

function Plant:time_till_death()
    if self:fully_grown() or self:dead() or self.harvested then
        return 100000
    end
    local next_stage = self.current_stage_watered and self.stage + 1 or self.stage - 1
    local regress_times = 0
    if self.stage > 0 then
        for i = next_stage, 1, -1 do
            regress_times = regress_times + time_till_stage_advances(i, self.seed_type, self.config)
        end
    end

    return (self.next_stage_starts_at + regress_times) - lsGetTimer()
end

function Plant:water()
    local result = self.controller:water()
    lsPrintln("Plant " .. self.index .. "water delay is " .. (lsGetTimer() - self.previous_stage_ended_at) .. " watered at " .. (lsGetTimer() - self.plant_time) ..
            " in stage " .. self.stage .. " death " .. self:time_till_death() .. " next " .. (self.next_stage_starts_at - lsGetTimer()))
    return result
end

function Plant:harvest()
    return self.controller:harvest()
end
