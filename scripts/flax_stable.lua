-- flax_stable.lua v1.2 -- by Jimbly, tweaked by Cegaiel and
--   KasumiGhia, revised by Tallow.
--
-- Plant flax and harvest either flax or seeds.
--
-- Works Reliably: 2x2, 3x3, 4x4, 5x5
-- May Work (depends on your computer): 6x6, 7x7
--

dofile("common.inc")
dofile("settings.inc")

askText =
  singleLine(
  [[
  flax_stable v1.1 (by Jimbly, tweaked by Cegaiel and KasumiGhia,
  revised by Tallow. Updated for T7 by Skyfeather) --
  Plant flax and harvest either flax or seeds. --
  Make sure the plant flax window is pinned and on the RIGHT side of
  the screen. Your Automato window should also be on the RIGHT side
  of the screen. You may need to
  F12 at low resolutions or hide your chat window (if it starts
  planting and fails to move downward, it probably clicked on your
  chat window).
  Will plant a spiral grid heading North-East of current  location.
  'Plant all crops where you stand' must be ON.
  'Right click pins/unpins a menu' must be ON.
]]
)

-- Global parameters set by prompt box.
is_plant = true
extraGridSpacing = false
readClock = true
num_loops = 5
grid_w = 4
grid_h = 4
seeds_per_pass = 4
finish_up = 0
finish_up_message = ""
seedType = "Old"
harvest = "Harvest this"
weedAndWater = "Weed and Water"
weedThis = "Weed this"
harvestSeeds = "Harvest seeds"
thisIs = "This is"
utility = "Utility"
txtRipOut = "Rip out"

-- walkTo() Parameters
rot_flax = false
water_needed = false
water_location = {}
water_location[0] = 0
water_location[1] = 0

-- Tweakable delay values
refresh_time = 100 -- Time to wait for windows to update
walk_time = 750 -- Reduce to 300 if you're fast.

-- Don't touch. These are set according to Jimbly's black magic.
walk_px_x = 355
walk_px_y = 315

-- Declare an array
xyCenter = {}
xyFlaxMenu = {}

-- The flax bed window
window_h = 145

--[[
To allow 5x5 seeds on a 1920 width screen.
We need to tweak the arrangeStashed function to only allow 50px for automato window
--]]
space_to_leave = 50

--This is only used when Extra Grid Spacing checkbox is UN checked. The additional spacing between pinned up windows.
min_width_offset = 75

--[[
How much of the ATITD screen to ignore (protect the right side of screen from closing windows when finished
max_width_offset will prevent it from reading all the way to the right edge of game client
This should be about 425 if we can use aquaduct. We can use 350 if no aquaduct window is present (to refill jugs).
--]]
max_width_offset = 350

FLAX = 0
plantType = FLAX
CLICK_MIN_WEED = 15 * 1000
CLICK_MIN_SEED = 27 * 1000
numSeedsHarvested = 0

-------------------------------------------------------------------------------
-- initGlobals()
--
-- Set up black magic values used for trying to walk a standard grid.
-------------------------------------------------------------------------------

function initGlobals()
  -- Macro written with 1720 pixel wide window

  srReadScreen()
  xyWindowSize = srGetWindowSize()

  local pixel_scale = xyWindowSize[0] / 1720
  lsPrintln("pixel_scale " .. pixel_scale)

  walk_px_y = math.floor(walk_px_y * pixel_scale)
  walk_px_x = math.floor(walk_px_x * pixel_scale)

  local walk_x_drift = 14
  local walk_y_drift = 18
  if (lsScreenX < 1280) then
    -- Have to click way off center in order to not move at high resolutions
    walk_x_drift = math.floor(walk_x_drift * pixel_scale)
    walk_y_drift = math.floor(walk_y_drift * pixel_scale)
  else
    -- Very little drift at these resolutions, clicking dead center barely moves
    walk_x_drift = 1
    walk_y_drift = 1
  end

  xyCenter[0] = xyWindowSize[0] / 2 - walk_x_drift
  xyCenter[1] = xyWindowSize[1] / 2 + walk_y_drift
  if plantType == FLAX then
    xyFlaxMenu[0] = xyCenter[0] - 43 * pixel_scale
    xyFlaxMenu[1] = xyCenter[1] + 0
  else
    xyFlaxMenu[0] = xyCenter[0] - 20
    xyFlaxMenu[1] = xyCenter[1] - 10
  end
end

-------------------------------------------------------------------------------
-- checkForEnd()
--
-- Similar to checkBreak, but also looks for a clean exit.
-------------------------------------------------------------------------------

local ending = false

function checkForEnd()
  if ((lsAltHeld() and lsControlHeld()) and not ending) then
    ending = true
    cleanup()
    error "broke out with Alt+Ctrl"
  end
  if (lsShiftHeld() and lsControlHeld()) then
    if lsMessageBox("Break", "Are you sure you want to exit?", MB_YES + MB_NO) == MB_YES then
      error "broke out with Shift+Ctrl"
    end
  end
  if lsAltHeld() and lsShiftHeld() then
    -- Pause
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false)
    end
    local done = false
    while not done do
      local unpaused = lsButtonText(lsScreenX - 110, lsScreenY - 60, nil, 100, 0xFFFFFFff, "Unpause")
      statusScreen("Hold Alt+Shift to resume", 0xFFFFFFff, false)
      done = (unpaused or (lsAltHeld() and lsShiftHeld()))
    end
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false)
    end
  end
end

-------------------------------------------------------------------------------
-- checkWindowSize()
--
-- Set width and height of flax window based on whether they are guilded or Game Master is playing.
-------------------------------------------------------------------------------

window_check_done_once = false
function checkWindowSize()
  if not window_check_done_once then
    srReadScreen()
    window_check_done_once = true
    local pos = findText("Useable by")
    if pos then
      window_h = window_h + 15
    end
    pos = findText("Game Master")
    if pos then
      window_h = window_h + 30
    end
  end
end

-------------------------------------------------------------------------------
-- promptFlaxNumbers()
--
-- Gather user-settable parameters before beginning
-------------------------------------------------------------------------------

function promptFlaxNumbers()
  scale = 0.8

  local z = 0
  local is_done = nil
  -- Edit box and text display
  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak()

    -- lsEditBox needs a key to uniquely name this edit box
    --   let's just use the prompt!
    -- lsEditBox returns two different things (a state and a value)
    local y = 10

    seedType = readSetting("seedType", seedType)
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Flax Name:")
    is_done, seedType = lsEditBox("flaxname", 120, y, z, 100, 0, scale, scale, 0x000000ff, seedType)
    writeSetting("seedType", seedType)
    y = y + 26

    num_loops = readSetting("num_loops", num_loops)
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Passes:")

    is_done, num_loops = lsEditBox("num_loops", 120, y, z, 50, 0, scale, scale, 0x000000ff, num_loops)
    if not tonumber(num_loops) then
      is_done = nil
      lsPrint(10, y + 18, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER")
      num_loops = 1
    end

    num_loops = tonumber(num_loops)
    writeSetting("num_loops", num_loops)
    y = y + 26

    grid_w = readSetting("grid_w", grid_w)
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Grid size:")
    is_done, grid_w = lsEditBox("grid", 120, y, z, 50, 0, scale, scale, 0x000000ff, grid_w)
    if not tonumber(grid_w) then
      is_done = nil
      lsPrint(10, y + 18, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER")
      grid_w = 1
      grid_h = 1
    end
    grid_w = tonumber(grid_w)
    grid_h = grid_w
    writeSetting("grid_w", grid_w)
    y = y + 26

    if not is_plant then
      lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Seeds per:")
      seeds_per_pass = readSetting("seeds_per_pass", seeds_per_pass)
      is_done, seeds_per_pass = lsEditBox("seedsper", 120, y, z, 50, 0, scale, scale, 0x000000ff, seeds_per_pass)
      seeds_per_pass = tonumber(seeds_per_pass)
      if not seeds_per_pass then
        is_done = nil
        lsPrint(10, y + 18, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER")
        seeds_per_pass = 1
      end
      seeds_per_pass = tonumber(seeds_per_pass)
      writeSetting("seeds_per_pass", seeds_per_pass)
      y = y + 27
    end

    if readClock and is_plant then
      if rot_flax or water_needed then
        lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Water coords:")
        water_location[0] = readSetting("water_locationX", water_location[0])
        is_done, water_location[0] =
          lsEditBox("water_locationX", 120, y, z, 55, 0, scale, scale, 0x000000ff, water_location[0])
        water_location[0] = tonumber(water_location[0])
        if not water_location[0] then
          is_done = nil
          lsPrint(135, y + 28, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER")
          water_location[0] = 1
        end
        writeSetting("water_locationX", water_location[0])

        water_location[1] = readSetting("water_locationY", water_location[1])
        is_done, water_location[1] =
          lsEditBox("water_locationY", 180, y, z, 55, 0, scale, scale, 0x000000ff, water_location[1])
        water_location[1] = tonumber(water_location[1])
        if not water_location[1] then
          is_done = nil
          lsPrint(135, y + 28, z + 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER")
          water_location[1] = 1
        end
        writeSetting("water_locationY", water_location[1])
        y = y + 28
      end

      lsPrintWrapped(
        10,
        y,
        z + 10,
        lsScreenX - 20,
        0.7,
        0.7,
        0xffff40ff,
        "Walk To Settings:\n-------------------------------------------"
      )

      water_needed = readSetting("water_needed", water_needed)
      water_needed = CheckBox(10, y + 30, z + 10, 0xFFFFFFff, " Water Required", water_needed, 0.65, 0.65)
      writeSetting("water_needed", water_needed)

      rot_flax = readSetting("rot_flax", rot_flax)
      rot_flax = CheckBox(10, y + 45, z + 10, 0xFFFFFFff, " Rot Flax", rot_flax, 0.65, 0.65)
      writeSetting("rot_flax", rot_flax)

      lsPrintWrapped(
        10,
        y + 57,
        z + 10,
        lsScreenX - 20,
        0.7,
        0.7,
        0xffff40ff,
        "-------------------------------------------"
      )
      y = y + 65
    end

    readClock = readSetting("readClock", readClock)
    readClock = CheckBox(120, y + 5, z + 10, 0xFFFFFFff, " Read Clock Coords", readClock, 0.7, 0.7)
    writeSetting("readClock", readClock)
    y = y + 2

    clearUI = readSetting("clearUI",clearUI);
    clearUI = CheckBox(120, y + 19, z + 10, 0xFFFFFFff, " Pin grid below the UI", clearUI, 0.7, 0.7);
    writeSetting("clearUI",clearUI);
    y = y + 2

    extraGridSpacing = readSetting("extraGridSpacing", extraGridSpacing)
    extraGridSpacing = CheckBox(120, y + 33, z + 10, 0xFFFFFFff, " Extra Spacing on Grid", extraGridSpacing, 0.7, 0.7)
    writeSetting("extraGridSpacing", extraGridSpacing)
    y = y + 2

    is_plant = readSetting("is_plant", is_plant)
    is_plant = CheckBox(120, y + 47, z + 10, 0xFFFFFFff, " Grow Flax", is_plant, 0.7, 0.7)
    writeSetting("is_plant", is_plant)

    y = y + 50
    if ButtonText(10, y - 33, z, 100, 0x00ff00ff, "Start !", 0.9, 0.9) then
      is_done = 1
    end
    y = y + 10

    if is_plant then
      -- Will plant and harvest flax
      window_w = 285
      space_to_leave = false
      lsPrintWrapped(10, y+10, z + 10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff, 'Uncheck "Grow Flax" for SEEDS!')
      y = y + 24
      lsPrintWrapped(
        10,
        y + 7,
        z + 10,
        lsScreenX - 20,
        0.7,
        0.7,
        0xD0D0D0ff,
        "This will plant and harvest a " ..
          grid_w ..
            "x" ..
              grid_w ..
                " grid of " ..
                  seedType ..
                    " Flax " ..
                      num_loops ..
                        " times, requiring " ..
                          math.floor(grid_w * grid_w * num_loops) ..
                            " seeds, doing " .. math.floor(grid_w * grid_w * num_loops) .. " flax harvests."
      )
    else
      lsPrintWrapped(10, y+10, z + 10, lsScreenX - 20, 0.7, 0.7, 0x00ff00ff, 'Check "Grow Flax" for FLAX!')
      y = y + 24

      -- Will make seeds

      -- Flax window will grow to 333 px before returning to 290.
      -- This window MUST be big enough otherwise rip out seeds will hang automato!
      -- As a result, we need to reduce space on the right to accomodate a 5x5 grid on widescreen monitors
      window_w = 333
      space_to_leave = 50

      lsPrintWrapped(
        10,
        y + 7,
        z + 10,
        lsScreenX - 20,
        0.7,
        0.7,
        0xD0D0D0ff,
        "This will plant a " ..
          grid_w ..
            "x" ..
              grid_w ..
                " grid of " ..
                  seedType ..
                    " Flax and harvest it " ..
                      seeds_per_pass ..
                        " times, requiring " ..
                          (grid_w * grid_w) .. " seeds, and repeat this " .. num_loops .. " times, yielding " ..
                          (grid_w * grid_w * seeds_per_pass * num_loops) .. " seeds."
      )
    end

    if is_done and (not num_loops or not grid_w) then
      error "Canceled"
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff, "End script") then
      error "Clicked End Script button"
    end

    lsDoFrame()
    lsSleep(tick_delay)
  end
end

-------------------------------------------------------------------------------
-- getPlantWindowPos()
-------------------------------------------------------------------------------

function getPlantWindowPos()
  srReadScreen()
  local plantPos = findText(seedType)
  if plantPos then
    plantPos[0] = plantPos[0] + 20
    plantPos[1] = plantPos[1] + 10
  else
    plantPos = lastPlantPos
    if plantPos then
      safeClick(plantPos[0], plantPos[1])
      lsSleep(refresh_time)
    end
  end
  if not plantPos then
    error "Could not find plant window"
  end
  lastPlantPos = plantPos
  return plantPos
end

-------------------------------------------------------------------------------
-- getToggle()
--
-- Returns 0 or 2 alternately. Used to slightly shift position of windows
-- while collecting them.
-------------------------------------------------------------------------------

toggleBit = 0

function getToggle()
  if toggleBit == 0 then
    toggleBit = 2
  else
    toggleBit = 0
  end
  return toggleBit
end

-------------------------------------------------------------------------------
-- doit()
-------------------------------------------------------------------------------

function doit()
  promptFlaxNumbers()
  askForWindow(askText)
  initGlobals()
  local startPos

  if readClock then
    srReadScreen()
    startPos = findCoords()
    if not startPos then
      error("ATITD clock not found. Try unchecking Read Clock option if problem persists")
    end
    lsPrintln("Start pos:" .. startPos[0] .. ", " .. startPos[1])
  else
    rot_flax = false;
    water_needed = false;
  end

  setCameraView(CARTOGRAPHER2CAM)
  drawWater()
  startTime = lsGetTimer()

  for loop_count = 1, num_loops do
    checkBreak()
    quit = false
    numSeedsHarvested = 0
    clicks = {}
    plantAndPin(loop_count)
    dragWindows(loop_count)
    harvestAll(loop_count)
    if is_plant and (water_needed or rot_flax) then
      walk(water_location, false)
      if water_needed then
        drawWater()
        lsSleep(150)
        clickMax() -- Sometimes drawWater() misses the max button
      end
    end
    if rot_flax then
      rotFlax()
    end
    walkHome(startPos)
    drawWater()
    if finish_up == 1 or quit then
      break;
    end
  end
  lsPlaySound("Complete.wav")
  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1)
end

-------------------------------------------------------------------------------
-- cleanup()
--
-- Tears out any remaining beds and unpins menus.
-------------------------------------------------------------------------------

function cleanup()
  local tops = findAllText(thisIs)
  if #tops > 0 then
    for i = 1, #tops do
      ripOut(tops[i])
    end
  end
end

-------------------------------------------------------------------------------
-- rotFlax()
--
-- Rots flax in water.  Requires you to be standing near water already.
-------------------------------------------------------------------------------

function rotFlax()
  centerMouse()
  local escape = "\27"
  local pos = nil
  while (not pos) do
    lsSleep(refresh_time)
    srKeyEvent(escape)
    lsSleep(refresh_time)
    srReadScreen()
    pos = findText("Skills...")
  end
  clickText(pos)
  lsSleep(refresh_time)
  srReadScreen()
  local pos = findText("Rot flax")
  if pos then
    clickText(pos)
    lsSleep(refresh_time)
    srReadScreen()
    if not clickMax() then
      fatalError("Unable to find the Max button.")
    end
  end
end

-------------------------------------------------------------------------------
-- plantAndPin()
--
-- Walk around in a spiral, planting flax seeds and grabbing windows.
-------------------------------------------------------------------------------

function plantAndPin(loop_count)
  local icon_tray = srFindImage("icon_tray_opened.png");
  if icon_tray then
    safeClick(icon_tray[0] + 5, icon_tray[1] + 5);
  end

  local xyPlantFlax = getPlantWindowPos()

  -- for spiral
  local dxi = 1
  local dt_max = grid_w
  local dt = grid_w
  local dx = {1, 0, -1, 0}
  local dy = {0, -1, 0, 1}
  local num_at_this_length = 3
  local x_pos = 0
  local y_pos = 0
  local success = true

  for y = 1, grid_h do
    for x = 1, grid_w do
      sleepWithStatus(
        refresh_time,
        "(" ..
          loop_count ..
            "/" .. num_loops .. ") Planting " .. x .. ", " .. y .. "\n\nElapsed Time: " .. getElapsedTime(startTime),
        nil,
        0.7
      )
      success = plantHere(xyPlantFlax, y)
      if not success then
        break
      end

      -- Move to next position
      if not ((x == grid_w) and (y == grid_h)) then
        lsPrintln("walking dx=" .. dx[dxi] .. " dy=" .. dy[dxi])
        lsSleep(40)
        x_pos = x_pos + dx[dxi]
        y_pos = y_pos + dy[dxi]
        local spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1])
        safeClick(xyCenter[0] + walk_px_x * dx[dxi], xyCenter[1] + walk_px_y * dy[dxi], 0)
        spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1])
        if not waitForChange(spot, 1500) then
          error_status = "Did not move on click."
          break
        end
        lsSleep(walk_time)
        waitForStasis(spot, 1500)
        dt = dt - 1
        if dt == 1 then
          dxi = dxi + 1
          num_at_this_length = num_at_this_length - 1
          if num_at_this_length == 0 then
            dt_max = dt_max - 1
            num_at_this_length = 2
          end
          if dxi == 5 then
            dxi = 1
          end
          dt = dt_max
        end
      else
        lsPrintln("skipping walking, on last leg")
      end
    end
    checkBreak()
    if not success then
      break
    end
  end

  icon_tray = srFindImage("icon_tray_closed.png");
  if icon_tray then
    safeClick(icon_tray[0] + 5, icon_tray[1] + 5);
  end

  local finalPos = {}
  finalPos[0] = x_pos
  finalPos[1] = y_pos
  return finalPos
end

-------------------------------------------------------------------------------
-- plantHere(xyPlantFlax)
--
-- Plant a single flax bed, get the window, pin it, then stash it.
-------------------------------------------------------------------------------

function plantHere(xyPlantFlax, y_pos)
  -- Plant
  lsPrintln("planting " .. xyPlantFlax[0] .. "," .. xyPlantFlax[1])
  local bed = clickPlant(xyPlantFlax)
  if not bed then
    return false
  end

  -- Bring up menu
  lsPrintln("menu " .. bed[0] .. "," .. bed[1])
  if not openAndPin(bed[0], bed[1], 3500) then
    error_status = "No window came up after planting."
    return false
  end

  -- Check for window size
  checkWindowSize()

  -- Move window into corner
  stashWindow(bed[0] + 5, bed[1], BOTTOM_RIGHT)
  return true
end

function clickPlant(xyPlantFlax)
  local result = xyFlaxMenu
  local spot = getWaitSpot(xyFlaxMenu[0], xyFlaxMenu[1])
  safeClick(xyPlantFlax[0], xyPlantFlax[1], 0)

  local plantSuccess = waitForChange(spot, 1500)
  if not plantSuccess then
    error_status = "No flax bed was placed when planting."
    result = nil
  end
  return result
end

-------------------------------------------------------------------------------
-- dragWindows(loop_count)
--
-- Move flax windows into a grid on the screen.
-------------------------------------------------------------------------------

function dragWindows(loop_count)
  sleepWithStatus(
    refresh_time,
    "(" ..
      loop_count ..
        "/" .. num_loops .. ")  " .. "Dragging Windows into Grid" .. "\n\nElapsed Time: " .. getElapsedTime(startTime),
    nil,
    0.7
  )

  if not extraGridSpacing and is_plant then
    window_w = nil
    offsetWidth = min_width_offset
  end

  if clearUI then
    arrangeStashed(nil, true, window_w, window_h, space_to_leave, offsetWidth, offsetHeight);
  else
    arrangeStashed(nil, waterGap, window_w, window_h, space_to_leave, offsetWidth, offsetHeight);
  end

end

-------------------------------------------------------------------------------
-- harvestAll(loop_count)
--
-- Harvest all the flax or seeds and clean up the windows afterwards.
-------------------------------------------------------------------------------

function harvestAll(loop_count)
  local did_harvest = false
  local harvestLeft = 0
  local seedIndex = 1
  local seedWave = 1
  local lastTops = {}

  while not did_harvest do
    lsSleep(10);
    srReadScreen()

    -- Monitor for Weed This/etc
    local tops = findAllText(thisIs)
    for i = 1, #tops do
      checkBreak()
      safeClick(tops[i][0], tops[i][1])
    end

    if is_plant then
      harvestLeft = #tops
    else
      --harvestLeft = seeds_per_iter - numSeedsHarvested;
      harvestLeft = (seeds_per_pass * #tops) - numSeedsHarvested -- New method in case one or more plants failed and we have less flax beds than expected
    end

    sleepWithStatusHarvest(200, "(" .. loop_count .. "/" .. num_loops ..
         ") Harvests Left: " .. harvestLeft .. "\n\nElapsed Time: " .. getElapsedTime(startTime) ..
         finish_up_message, nil, 0.7, "Monitoring Windows");

    if is_plant then
      lsPrintln("Checking Weeds")
      lsPrintln("numTops: " .. #tops)

      local weeds = findAllText(weedThis)
      for i = #weeds, 1, -1 do
        lastClick = lastClickTime(weeds[i][0], weeds[i][1])
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_WEED then
          clickText(weeds[i])
          trackClick(weeds[i][0], weeds[i][1])
        end
      end

      local waters = findAllText(weedAndWater)
      for i = #waters, 1, -1 do
        lastClick = lastClickTime(waters[i][0], waters[i][1])
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_WEED then
          clickText(waters[i])
          trackClick(waters[i][0], waters[i][1])
        end
      end

      local harvests = findAllText(harvest)
      for i = #harvests, 1, -1 do
        lastClick = lastClickTime(harvests[i][0], harvests[i][1])
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_WEED then
          clickText(harvests[i])
          trackClick(harvests[i][0], harvests[i][1])
        end
      end

      -- check for beds needing ripping out
      local hsr = findText(harvestSeeds, nil, REGION)
      if hsr then
        clickText(findText(utility, hsr))
        ripLoc = waitForText(txtRipOut, 1000)
        if ripLoc then
          clickText(ripLoc)
        end
      end
    else -- if is_plant
      seedsList = findAllText(harvestSeeds)
      for i = #seedsList, 1, -1 do
        lastClick = lastClickTime(seedsList[i][0], seedsList[i][1])
        if lastClick == nil or lsGetTimer() - lastClick >= CLICK_MIN_SEED then
          clickText(seedsList[i])
          trackClick(seedsList[i][0], seedsList[i][1])
          numSeedsHarvested = numSeedsHarvested + 1
        end
        firstSeedHarvest = true
      end
    end -- if is_plant

    --if numSeedsHarvested >= seeds_per_iter and not is_plant  then
    if harvestLeft <= 0 and not is_plant then -- New method in case one or more plants failed and we have less flax beds than expected
      did_harvest = true
    end

    if #tops <= 0 then
      lsPrintln("finished harvest")
      did_harvest = true
    end
    checkBreak()
  end -- while not harvest
  lsPrintln("ripping out all seeds")
  ripOutAllSeeds()
  -- Wait for last flax bed to disappear
  sleepWithStatus(
    1500,
    "(" .. loop_count .. "/" .. num_loops .. ") ... Waiting for flax beds to disappear",
    nil,
    0.7,
    "Stand by"
  )
  closeAllWindows(0, 0, xyWindowSize[0] - max_width_offset, xyWindowSize[1])
end

-------------------------------------------------------------------------------
-- walkHome(loop_count, finalPos)
--
-- Walk back to the origin (southwest corner) to start planting again.
-------------------------------------------------------------------------------

function walkHome(finalPos)
  -- Close all empty windows
  --closeEmptyAndErrorWindows();
-- closeAllWindows is now above, at end of harvestAll()
--  closeAllWindows(0, 0, xyWindowSize[0] - max_width_offset, xyWindowSize[1])

  if readClock then
    walkTo(finalPos)
  end

  -- Walk back
  --  for x=1, finalPos[0] do
  --    local spot = getWaitSpot(xyCenter[0] - walk_px_x, xyCenter[1]);
  --    safeClick(xyCenter[0] - walk_px_x, xyCenter[1], 0);
  --    lsSleep(walk_time);
  --    waitForStasis(spot, 1000);
  --  end
  --  for x=1, -(finalPos[1]) do
  --    local spot = getWaitSpot(xyCenter[0], xyCenter[1] + walk_px_y);
  --    safeClick(xyCenter[0], xyCenter[1] + walk_px_y, 0);
  --    lsSleep(walk_time);
  --    waitForStasis(spot, 1000);
  --  end
end

-------------------------------------------------------------------------------
-- walk(dest,abortOnError)
--
-- Walk to dest while checking for menus caused by clicking on objects.
-- Returns true if you have arrived at dest.
-- If walking around brings up a menu, the menu will be dismissed.
-- If abortOnError is true and walking around brings up a menu,
-- the function will return.  If abortOnError is false, the function will
-- attempt to move around a little randomly to get around whatever is in the
-- way.
-------------------------------------------------------------------------------

function walk(dest, abortOnError)
  centerMouse()
  srReadScreen()
  local coords = findCoords()
  local failures = 0
  while coords[0] ~= dest[0] or coords[1] ~= dest[1] do
    centerMouse()
    lsPrintln("Walking from (" .. coords[0] .. "," .. coords[1] .. ") to (" .. dest[0] .. "," .. dest[1] .. ")")
    walkTo(makePoint(dest[0], dest[1]))
    srReadScreen()
    coords = findCoords()
    checkForEnd()
    if checkForMenu() then
      if (coords[0] == dest[0] and coords[1] == dest[1]) then
        return true
      end
      if abortOnError then
        return false
      end
      failures = failures + 1
      if failures > 50 then
        return false
      end
      lsPrintln("Hit a menu, moving randomly")
      walkTo(makePoint(math.random(-1, 1), math.random(-1, 1)))
      srReadScreen()
    else
      failures = 0
    end
  end
  return true
end

function checkForMenu()
  srReadScreen()
  pos = srFindImage("unpinnedPin.png", 5000)
  if pos then
    safeClick(pos[0] - 5, pos[1])
    lsPrintln("checkForMenu(): Found a menu...returning true")
    return true
  end
  return false
end

-------------------------------------------------------------------------------
-- ripOutAllSeeds
--
-- Use the Utility menu to rip out a flax bed that has gone to seed.
-- pos should be the screen position of the 'This Is' text on the window.
-------------------------------------------------------------------------------

function ripOutAllSeeds()
  checkBreak()
  sleepWithStatus(refresh_time, "Ripping Out" .. "\n\nElapsed Time: " .. getElapsedTime(startTime), nil, 0.7)
  srReadScreen()
  flaxRegions = findAllText("This is ", nil, REGION)
  for i = 1, #flaxRegions do
    checkBreak()
    local utloc = waitForText(utility, nil, nil, flaxRegions[i])
    lsPrintln("Clicking Utility.. button at: " .. utloc[0] .. ", " .. utloc[1])
    clickText(utloc)
    lsPrintln("Clicking rip out")
    clickText(waitForText(txtRipOut, 5000))
    lsSleep(refresh_time)
    lsPrintln("Unpinning region")
    unpinWindow(flaxRegions[i])
    lsSleep(refresh_time)
  end
end

clicks = {}
function trackClick(x, y)
  local curTime = lsGetTimer()
  lsPrintln("Tracking click " .. x .. ", " .. y .. " at time " .. curTime)
  if clicks[x] == nil then
    clicks[x] = {}
  end
  clicks[x][y] = curTime
end

function lastClickTime(x, y)
  if clicks[x] ~= nil then
    if clicks[x][y] ~= nil then
      lsPrintln("Click " .. x .. ", " .. y .. " found at time " .. clicks[x][y])
    end
    return clicks[x][y]
  end
  lsPrintln("Click " .. x .. ", " .. y .. " not found. ")
  return nil
end

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatusHarvest(delay_time, message, color, scale, waitMessage)
  if not waitMessage then
    waitMessage = "Waiting ";
  else
    waitMessage = waitMessage .. " ";
  end
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    newWaitMessage = waitMessage;
    if delay_time >= 1000 then
      newWaitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);

    if finish_up == 0 and tonumber(loop_count) ~= tonumber(num_loops) then
      if lsButtonText(lsScreenX - 110, lsScreenY - 60, nil, 100, 0xFFFFFFff, "Finish up") then
        finish_up = 1;
        finish_up_message = "\n\nFinishing up..."
      end
    end


      if lsButtonText(lsScreenX - 110, lsScreenY - 90, nil, 100, 0xFFFFFFff, "Rip Plants") then
        ripOutAllSeeds()
        quit = true
      end

    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end
