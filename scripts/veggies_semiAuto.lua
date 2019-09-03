--- Veggies SemiAuto v1.4.1 by Cegaiel
-- Credits to the Author of veggies.lua (Submitted to Github by MHoroszowski on Sep 19, 2015) for his work as a starting point.

-- New for v1.4.0: Full Auto Mode implemented. Once you run this in semi-auto mode once or twice and are sure it's clicking everything ok, then
-- you can use the new button "Stats/Full Auto Mode".  This button will show how many ms each time you tapped Shift for each watering. Those values are recorded in memory.
-- Once inside this menu, there is a "Engage Auto Mode" button.  It will now start pinning, watering and harvesting your plants automatically.

-- Make sure Automato is not at the bottom right corner, as this is where the plant windows are stashed, prior to pinning.
-- Also beware, if you have the stand alone version of Discord running, you will want to turn off Notifications or Mute Servers.
-- Those notifications that appear on bottom right of screen will eventually mess up the pinning process, if it tries to stash windows while the notification exists.

-- Pin your plant window, showing the seed you want to plant.  Enter the name of seed (partial name is fine -- ie you can enter 'Tears' for 'Tears of Sinai'). It is ok to move the plant window between plantings.
-- You can typically plant 8 plants and get the first watering done, before they die with 1 watering seeds. 2 to 3 watering seeds might be pushing it. May want to use 4-6 plants on those.
-- If you are unsure how many waterings a seed takes, try checking wiki: https://wiki.desert-nomad.com/index.php?title=Vegetable

-- Options:
-- Plant Veggies Closer together: This will plant your veggies in a small radius around your avatar.
-- Auto Gather Water: If you are planting near a water source, it will refill your jugs prior to each planting. You can optionally pin a Rain Barrel window and it will draw water from the barrel.
-- Pause/Wait for Trigger after Harvest: Due to current variations in lag and duck time, sometimes it takes a few moments before all your veggies disappear, even after you stop moving.
-- This will pause the macro until you press your hotkey, to be sure all veggies are off the screen. If you uncheck this box, then it plants in continuous mode. You can adjust the timer below (delayAfterHarvestPerPlant) 
-- Let me Pin my windows manually: The macro does pin up all your plant windows manually and form a grid (but you have to Tap Shift (optionally Ctrl, Alt, click MouseWheel). If you feel you can do it faster, then thats what this option is for.
-- 'Remember plant coords' between planting: Prior to v1.3.0 you had to tap Shift over each plant, every time you planted.  This option remembers the last positions and attempts to use the same coordinates every round.
-- 'Remember plant coords' can be inconsistent, sometimes. I think if you move too far while watering/harvesting, it can throw off coords by a pixel or two, sometimes resulting in a right click to miss the plant.
-- If you find that some windows don't appear (or none at all), then this is likely the reason.
-- And experiment, to give consistent results, there is now a repositionAvatar() function. This simply attempts to make your avatar face the same direction every time, prior to planting.
-- I find that using the "Plant Veggies closer together' option usually gives better results. But for small plants, like Leeks, it can be tricky to click each one when Plant > 6.
-- Just remember, for the most reliable results, don't use 'Remember plant coords' options. Expect some minor issues when you do.  But the macro should be able to recover and continue regardless.

-- How to Use:
-- Pin your your plant menu, so that your seed name shows.
-- Your veggies will be planted. Quickly (before they die), tap Shift (or your trigger key) over each plant. As soon as you tap key over your last veggie, macro will automatically begin:
-- It will now pin all your plant windows up, arrange the windows in a grid and give it it's first watering.  Then it will Pause.
-- When you see ALL of your plants grow Tap key and it will water all your plants again. Keep doing this until the windows shows Harvest.  Another tap of the key will Harvest them, close out windows and ready for next round.


dofile("common.inc");
dofile("settings.inc");


Button = {};
Button[0] = makePoint(45, 60); --NW
Button[1] = makePoint(75, 62); --NE
Button[2] = makePoint(45, 87); --SW
Button[3] = makePoint(75, 91); --SE
Button[4] = makePoint(59, 51); --N
Button[5] = makePoint(60, 98); --S
Button[6] = makePoint(84, 74); --E
Button[7] = makePoint(37, 75); --W
BuildButton = makePoint(31, 135);

dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
waterImage = "WaterThese.png";
harvestImage = "HarvestThese.png";
thisIs = "This is";
plantCloser = true;
autoWater = true;
pauseAfterHarvest = true;
manualPin = false;
saveCoords = true;
seedName = "Tears";

delayAfterHarvestPerPlant = 3000;
grid_x = 260; -- Watermelon seeds are widest window width, 260
grid_y = 100;
max_window_size = 425; -- We don't want to close out the Aquaduct window. This should be about 425. We can use 350 if no aquaduct window is present (to refill jugs).

firstLoop = 1;
totalHarvests = 0;
click_delay = 75;

function doit()
  askForWindow("This macro will assist you by planting seeds, watering/harvesting your pinned windows when you tap the hotkey. After seeds are planted, you will tap hotkey over each plant, it will then pin the windows for you and do first watering automatically. After first watering, you will then tap hotkey to water (after you see it grow).\n\nMust have 'Plant all crops where you stand': OFF! Right-Click pins/unpins a Menu: ON! Right-Click opens a Menu as Pinned: ON! One-Click: Auto-take Piles: ON!\n\nMake sure plant seed menu window AND Automato is in the TOP-RIGHT corner of the screen.");

  center = getCenterPos();
  size = srGetWindowSize();
  thisSessionTimer = lsGetTimer();
	refreshWindows();
	closeAllWindows(0,0, size[0]-max_window_size, size[1]); -- Look for windows for any left over planted windows
	closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.

	chooseMethod();

	if saveCoords and not plantCloser then
	  message = "NOTE:\n\nWhen using 'Remember Plant Coords' option, you may find that also using the 'Plant veggies closer' option MIGHT provide better results (when trying to use previous coordinates).\n\nThis is not required, but might be worth experimenting!\n\n" .. key .. " to continue!";
	  displayError(message);
	end

	if autoWater and not manualPin and saveCoords then
	  message = "NOTE:\n\nWhen using 'Auto Gather Water' option, you MUST be standing near water (so the water icon appears) or have a Rain Barrel pinned.\n\nThere needs to be a pause (gather water delay) before pinning windows so that the 'Water these' option has enough time to appear on plant windows.\n\nUncheck 'Auto Gather Water' if you are NOT near a water source (so macro can add the needed delay)!\n\n" .. key .. " to continue!";
	  displayError(message);
	end


	setCameraView(CARTOGRAPHER2CAM);
	lsSleep(500);
	repositionAvatar();
	closeAllWindows(0,0, size[0]-max_window_size, size[1]); -- Look for windows for any left over planted windows

  while 1 do
	refreshWindows();
	drawWater(1);
	firstWater = 1;
	abort = nil;
	finalTending = nil;

	if not fullAutoMode then
	  vegclickTimer = {};
	end

	closeAllWindows(0,0, size[0]-max_window_size, size[1]); -- Look for windows for any left over planted windows
	closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.

	 if autoWater and (manualPin or not saveCoords or firstLoop) then --If using manual Pin mode or not saving coords, then do autowater first, to avoid it getting in the way later.
	   drawWater();
	 end

--	if saveCoords then
--	  repositionAvatar();	
--	end

	main();

	 if autoWater and not manualPin and saveCoords and not firstLoop then
		if not drawWater() then -- Attempt to gather water. If water not found or player is already full of water, then add 3 seconds below, otherwise gather animation takes 3 seconds
		  sleepWithStatus(3000,"Slight pause for 'Water These' to appear on plants, before we pin",nil, 0.7, 0.7);
		end
	 elseif not autoWater and not manualPin and saveCoords and not firstLoop then -- If we pin windows too quickly, then the 'Water These' option doesn't appear, right away. Wait a moment...
  	  sleepWithStatus(3000,"Slight pause for 'Water These' to appear on plants, before we pin",nil, 0.7, 0.7);
	 end


	if not manualPin then
		if firstLoop or not saveCoords then
		  getPoints();
		  firstLoop = false;
		end
	  pinWindows();
	end


	waterThese();
	closeAllWindows(0,0, size[0]-max_window_size, size[1]); -- Look for windows for any left over planted windows
	closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.


	if (pauseAfterHarvest and not fullAutoMode) or abort then
	  waitForShift();
	else
	  sleepWithStatus(delayAfterHarvestPerPlant*#harvest, "Harvesting vegetables ...",nil, 0.7, 0.7);
	end

  end
end


function waterThese()
  harvestTimer = lsGetTimer();
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;
  while not is_done do
	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Abort") then
	  abort = 1;
	  fullAutoMode = nil;
	  break;
	end

    checkBreak();
    local is_shifted = lsShiftHeld();
    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end


  if fullAutoMode then
    statusScreen("Waiting on Harvest ...\n\n[" .. tended .. "] Tendings -- All Plants Watered\n\n\nClick Abort button if something went wrong. This will close all veggie windows and start over.", nil, 0.7, 0.7);
  refreshWindows();
  elseif not firstWater then
    statusScreen("When ALL plants GROW:\n" .. key .. " to Water plants\n\n[" .. tended-1 .. "] Tendings -- All Plants Watered\n\nYou can " .. key .. " even if you are still watering (animations) last growth. Watering/Harvests will be queued!\n\n\nClick Abort button if something went wrong. This will close all veggie windows and start over.", nil, 0.7, 0.7);
  refreshWindows();
  elseif firstWater == 1 and manualPin then
    statusScreen("After you pin your windows:\n\n" .. key .. " to water pinned plants", nil, 0.7, 0.7);
  end

    if (is_shifted and not was_shifted) or (firstWater and not manualPin) or harvestReady or (fullAutoMode and not finalTending) then
  refreshWindows();

	checkBreak();
	if #waters == 0 and #harvest == 0 then
	  message = "Could not find any pinned veggies!\n\nThis usually happens if you missed a plant when you " .. key .. ".\n\nHigh resolutions, such as 1920x1080 has such a small margin of where you clicked on veggie.\n\nIf avatar moves or body is facing a certain direction MIGHT be a factor...\n\n" .. key .. " to return to Main menu."
	  abort = 1;
	  fullAutoMode = nil;
	  displayError(message);
	  break;
	end


	  if #harvest >= 1 and #waters == 0 then  --If there is any 'Water these' remaining and some can be harvested, that suggests one plant is lagging behind or shrunk and you're still trying to catch up. Don't harvest yet.
			statusScreen("Harvesting [".. #harvest .. "] plants ...");
			stats = stats .. "\nHarvested @ " .. (lsGetTimer() - harvestTimer) .. " ms - " .. round((lsGetTimer() - waterTimer)/1000, 2) .. " s\n";

		  for i=#harvest,1,-1 do
			checkBreak();
			safeClick(harvest[i][0] + 5, harvest[i][1]);
			lsSleep(click_delay);
			totalHarvests = totalHarvests + 1;
		  end

			if #harvest < count and (not pauseAfterHarvest or fullAutoMode) then	-- If the # of harvests is < than number of plantings, then something went wrong. Don't break, force user to click abort or manually handle any issues.
			  abort = 1;
			  fullAutoMode = nil;
			  sleepWithStatus(3000, "Something went wrong, you harvested less plants than expected!\n\nAborting and disengaging Full Auto Mode\n\nVerify you don't have any seeds on ground.", nil, 0.7, 0.7);
			end
			  break;  -- Break the loop after Harvest found and clicked

	  else

			statusScreen("Watering [".. #waters .. "] plants ...");

			if (fullAutoMode and tended-1 < #vegclickTimer) or not fullAutoMode then
			  tended = tended + 1
			end

			  if tended == 1 then
			    stats = stats .. "Tend #" .. tended-1 .. " @ First Water / Timer Started\n"; 
			    waterTimer = lsGetTimer();
			    waterTimerAuto = lsGetTimer();
			  else
			    stats = stats .. "Tend #" .. tended-1 .. " @ " .. (lsGetTimer() - waterTimer) .. " ms - " .. round((lsGetTimer() - waterTimer)/1000, 2) .. " s\n";
				if not fullAutoMode then
				  vegclickTimer[#vegclickTimer + 1] = {lsGetTimer() - waterTimerAuto}
				  waterTimerAuto = lsGetTimer();
				end
			  end


		  for i=#waters,1,-1 do
			checkBreak();
			  for water=1,water_req do
				if (fullAutoMode and tended <= #vegclickTimer+1 and not finalTending) or not fullAutoMode then
				  safeClick(waters[i][0] + 5, waters[i][1] + 5);
				  lsSleep(click_delay);
				end
		           end
		  firstWater = nil;
		  end
	  end
    end
    was_shifted = is_shifted;


		if fullAutoMode and tended == 1 then
		  sleepWithStatus(vegclickTimer[tended][1]-3000, "Tended: " .. tended-1 .. "\nTimer: " .. vegclickTimer[tended][1] .. "\n              (-3000 water gather =" .. vegclickTimer[tended][1]-3000 .. ")",nil, 0.7, 0.7);
		elseif fullAutoMode and (tended == #vegclickTimer+1) then
		  finalTending = 1;
		  --lsSleep(100);
		elseif fullAutoMode then
		  sleepWithStatus(vegclickTimer[tended][1], "Tended: " .. tended .. "\nTimer: " .. vegclickTimer[tended][1],nil, 0.7, 0.7);
		--else
		    --lsSleep(100);
		end
  lsSleep(10);
  end
end


function main()
  getPlantWindowPos();
  tended = 0;
  stats = "";

  for i = 0, count-1 do
	checkBreak();
	--Click Seed in Plant Window	
	safeClick(plantPos[0], plantPos[1]);
	lsSleep(click_delay);
        if buildCheck == nil then
          lsSleep(100); -- Add an extra delay. I've seen it miss it, super rare.
          buildCheck = 1; -- One time check to make sure player has plant where you stand unchecked.
          srReadScreen();
          build = srFindImage("build.png")
            if not build then
              lsPlaySound("fail.wav")
              error('Could not find Build menu. Options, One-Click, \'Plant all crops where you stand must be UN-CHECKED!');
          end
        end

	--Click Build window to move veggies on ground
    safeClick(Button[i][0], Button[i][1]);
    lsSleep(click_delay);
	if not plantCloser then
    safeClick(Button[i][0], Button[i][1]);
    lsSleep(click_delay);
	end
    safeClick(BuildButton[0], BuildButton[1]);
    lsSleep(click_delay);
  end
end


function chooseMethod()
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  local is_done = false;
  count = 1;
  while not is_done do
	checkBreak();
	local y = 10;
	lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff,
            "Key or Mouse to Trigger Watering/Harvest:");
	y = y + 35;
	lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
  	dropdown_cur_value = readSetting("dropdown_cur_value",dropdown_cur_value);
	dropdown_cur_value = lsDropdown("ArrangerDropDown", 10, y, 0, 200, dropdown_cur_value, dropdown_values);
	writeSetting("dropdown_cur_value",dropdown_cur_value);
	lsSetCamera(0,0,lsScreenX*1.1,lsScreenY*1.1);
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Seed Name:");
	seedName = readSetting("seedName",seedName);
      is_done, seedName = lsEditBox("seedName", 120, y-5, 0, 190, 30, 0.8, 0.8, 0x000000ff, seedName);
	writeSetting("seedName",seedName);
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "How many plants (1-8):");
	count = readSetting("count",counter);
      is_done, count = lsEditBox("count", 200, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, count);
      count = tonumber(count);
      if not count then
        is_done = false;
        lsPrint(10, y+19, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        count = 6;
      end
	writeSetting("count",count);
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Water per plant:");
	water_req = readSetting("water_req",water_req);
      is_done, water_req = lsEditBox("water_req", 200, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, water_req);
      water_req = tonumber(water_req);
      if not water_req then
        is_done = false;
        lsPrint(10, y+19, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        water_req = 1;
      end
	writeSetting("water_req",water_req);
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Click Delay (ms):");
	click_delay = readSetting("click_delay",click_delay);
      is_done, click_delay = lsEditBox("click_delay", 200, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, click_delay);
      click_delay = tonumber(click_delay);
      if not click_delay then
        is_done = false;
        lsPrint(10, y+19, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        click_delay = 75;
      end
	writeSetting("click_delay",click_delay);
	y = y + 105;
      lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);
	autoWater = readSetting("autoWater",autoWater);
      autoWater = lsCheckBox(15, y, z, 0xffffffff, " Auto Gather Water", autoWater);
	writeSetting("autoWater",autoWater);
	y = y + 25;
	pauseAfterHarvest = readSetting("pauseAfterHarvest",pauseAfterHarvest);
      pauseAfterHarvest = lsCheckBox(15, y, z, 0xffffffff, " Pause/Wait for Trigger after Harvest", pauseAfterHarvest);
	writeSetting("pauseAfterHarvest",pauseAfterHarvest);
	y = y + 25;
	saveCoords = readSetting("saveCoords",saveCoords);
      saveCoords = lsCheckBox(15, y, z, 0xffffffff, " Remember plant coords between plantings", saveCoords);
	writeSetting("saveCoords",saveCoords);
	y = y + 25;
	plantCloser = readSetting("plantCloser",plantCloser);
      plantCloser = lsCheckBox(15, y, z, 0xffffffff, " Plant Veggies closer together", plantCloser);
	writeSetting("plantCloser",plantCloser);
	y = y + 25;
	manualPin = readSetting("manualPin",manualPin);
      manualPin = lsCheckBox(15, y, z, 0xffffffff, " Let me Pin plant windows Manually", manualPin);
	writeSetting("manualPin",manualPin);
	y = y + 25;
	clearUI = readSetting("clearUI",clearUI);
    clearUI = lsCheckBox(15, y, z, 0xffffffff, " Start pinning the plant grid below the UI", clearUI);
	writeSetting("clearUI",clearUI);
	y = y + 25;
      lsPrint(10, y, 0, 0.9, 0.9, 0xffffffff, "Click Delay: Pause between clicking each plant");
	y = y + 20;
      lsPrint(10, y, 0, 0.9, 0.9, 0xffffffff, "Plant closer: Not for large veggy, like cabbage");
      lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);



    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(10);
  end
  return count;
end


function closeAllWindows(x, y, width, height)
  if not x then
    x = 0;
  end
  if not y then
    y = 0;
  end
  if not width then
    width = srGetWindowSize()[0];
  end
  if not height then
    height = srGetWindowSize()[1];
  end

  local closeImages = {"ThisIs.png", "Ok.png", "UnPin.png"};
  local closeRight = {1, 1, nil};
  local found = true;

  while found do
    found = false;
    for i=1,#closeImages do

      local image = closeImages[i];
      local right = closeRight[i];
      srReadScreen();
      local images = findAllImagesInRange(image, x, y, width, height);
      while #images >= 1 do
	done = true;
	safeClick(images[#images][0], images[#images][1], right);
	sleepWithStatus(click_delay, "Closing Windows",nil, 0.7, 0.7);
	srReadScreen();
	images = findAllImagesInRange(image, x, y, width, height);
      end
    end
  end
      --We just harvested and closed any windows... Is there anything we want to do before we continue to next round?
	if fullAutoModeQueuedOff then
	  fullAutoMode = nil; -- We clicked disengage button, turn off, reset flag
	  fullAutoModeQueuedOff = nil;
        sleepWithStatus(1500, "Disengaging Auto Mode...\n\nReturning to Menu, after Harvest!",nil, 0.7, 0.7)
	end
end


function refreshWindows()
  srReadScreen();
  waters = findAllImages(waterImage);
  harvest = findAllImages(harvestImage);
  unPin = findAllImages("UnPin.png");
  if #unPin > 0 then
    for i=1,#unPin do
      safeClick(unPin[i][0]-10, unPin[i][1]);
      lsSleep(10);
      end
  end
  tops = findAllText(thisIs);
	for i=1,#tops do
      	  safeClick(tops[i][0], tops[i][1]);
	  --lsSleep(10);
       end

  if #harvest >= 1 and #waters == 0 then
    harvestReady = 1;
  else
    harvestReady = nil;
  end
end


function getCenterPos()
	xyWindowSize = srGetWindowSize()
	bottomRightX = xyWindowSize[0] - 20;
	bottomRightY = xyWindowSize[1] - 20;
	local ret = {};
	ret[0] = xyWindowSize[0] / 2;
	ret[1] = xyWindowSize[1] / 2;
	return ret;
end


function pinWindows()
	srSetMousePos(bottomRightX, bottomRightY);
	lsSleep(click_delay);

    for i=1,#vegclickList do
	checkBreak();
	srSetMousePos(bottomRightX, bottomRightY);
	safeClick(vegclickList[i][1], vegclickList[i][2], 1);
	lsSleep(click_delay);
    end
	
	if clearUI then 
	arrangeStashed(false, true, grid_x, grid_y, max_window_size);
	else
	arrangeStashed(false, false, grid_x, grid_y, max_window_size);
	end
	srSetMousePos(center[0],center[1]);
end


function pinWindowsSLOW()
--Alternative method (currently NOT used), but it's a bit slower
    for i=1,#vegclickList do
      openAndPin(vegclickList[i][1], vegclickList[i][2], 500)
      stashWindow(vegclickList[i][1] + 5, vegclickList[i][2], BOTTOM_RIGHT);
    end
	if clearUI then 
	arrangeStashed(false, true, grid_x, grid_y, max_window_size);
	else
	arrangeStashed(false, false, grid_x, grid_y, max_window_size);
	end
	srSetMousePos(center[0],center[1]);
end


function getPoints()
fullAutoMode = nil;
vegclickList = {};
  local was_shifted = lsShiftHeld();
  
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;
  local mx = 0;
  local my = 0;
  local z = 0;
  while not is_done do
    mx, my = srMousePos();
    local is_shifted = lsShiftHeld();
    
    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    
    if is_shifted and not was_shifted then
      vegclickList[#vegclickList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 0.7, 0.7, 0xffff80ff,
	    "Set Planted Veggy Locations (" .. #vegclickList .. "/" .. count .. ")");
    lsPrint(10, 50, z, 0.9, 0.9, 0xff8080ff, "Quickly!");
    lsPrint(10, 85, z, 0.7, 0.7, 0x80ff80ff, key .. " over each veggie on ground!");

    local index = 0;
    local y = 130;
    local start = math.max(1, #vegclickList - 20);
    for i=start,#vegclickList do
      local xOff = (index % 4) * 70;
      local yOff = (index - index%4)/2 * 7;
      lsPrint(5 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              i .. ": (" .. vegclickList[i][1] .. ", " .. vegclickList[i][2] .. ")");
      index = index + 1;
    end

    imageSize = 15;
    rectangleSize = 30;
    srReadScreen();
    pixelColor = srReadPixel(mx, my)
    --srMakeImage("mousePos", mx-(imageSize/2), my-(imageSize/2), imageSize, imageSize);
    --srShowImageDebug("mousePos", 10, lsScreenY-140, 0.0, 2.0);
    --lsPrint(80, lsScreenY-140, z, 0.7, 0.7, 0xffffffff, "Mouse Position Image Preview");
    lsDrawRect(10, lsScreenY-70, rectangleSize+40, lsScreenY-10, 0, pixelColor)
    lsPrint(80, lsScreenY-70, z, 0.7, 0.7, 0xffffffff, "Mouse Position Pixel Color");

    if #vegclickList == count then -- Break out of loop once #plants clicked
    lsDoFrame();
	break;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 110, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(10);
  end
end


function waitForShift()
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;

  while not is_done do
	if ButtonText(5, lsScreenY - 30, z, 150, 0xFFFFFFff, "Pick Seeds Up") then
	  pickUpSeeds();
	  closeAllWindows(0,0, size[0]-max_window_size, size[1]); -- Look for windows for any left over planted windows
	  closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.
	end

	if saveCoords then
		if ButtonText(5, lsScreenY - 60, z, 150, 0xFFFFFFff, "Reset Coords+Replant") then
	  	  firstLoop = 1;
		  srSetMousePos(center[0],center[1]);
	  	  break;
		end
	end

	if #harvest > 0 and not manualPin then
	  if ButtonText(lsScreenX - 140, lsScreenY - 60, z, 160, 0xFFFFFFff, "Stats/Full Auto Mode", 0.8, 0.8) then
	    Stats();
	  end
	end

    statusScreen(key .. " to continue planting!\n\nWait until ALL animations STOP and ALL plants disappear, FIRST.\n\nNote: 'Pick Seeds Up' button isn\'t foolproof.\n\nIt simply right-clicks where you previously set plant locations.\n\nIf you moved too far from starting position, it will likely misclick and fail!", nill, 0.7, 0.7);
    local is_shifted = lsShiftHeld();

    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    
    if is_shifted and not was_shifted or fullAutoMode then
	break;
    end
    was_shifted = is_shifted;
    lsSleep(10);
  end
end


function getPlantWindowPos()
  srReadScreen();
  plantPos = findText(seedName);
  if plantPos then
    plantPos[0] = plantPos[0] + 20;
    plantPos[1] = plantPos[1] + 10;
  end
  if not plantPos then
    error("Could not find \'" .. seedName .. "\' seed in any pinned windows");
  end
  return plantPos;
end

function displayError(message)
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;

  while not is_done do
    checkBreak();
    statusScreen(message, nil, 0.7, 0.7);

    local is_shifted = lsShiftHeld();
    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    
    --if is_shifted and not was_shifted then
    if lsShiftHeld() and not was_shifted then
	break;
    end
    was_shifted = is_shifted;
  end
end


function repositionAvatar()
  statusScreen("Repositioning Avatar to face N/S ...");
  safeClick(center[0],center[1]-200);
  lsSleep(500);
  safeClick(center[0],center[1]+200);
  lsSleep(500);
end


function pickUpSeeds()
  srSetMousePos(center[0],center[1]);
  lsSleep(75);
  srKeyEvent(string.char(27));  -- Send Esc Key to close the window
  lsSleep(75);
  srReadScreen();
  utility = findText("Utility");
  lsSleep(200);
	if utility then
	  srClickMouseNoMove(utility[0]+12,utility[1]+5);
	  lsSleep(75);
  	else
	  sleepWithStatus(1250, "Error: Could not find menu option 'Utility'\n\nWas part of the menu obscured behind Automato, perhaps?",nil, 0.7, 0.7);
  	end
  srReadScreen();

  bags = findText("nearby");
  lsSleep(75);

	if bags then
	  srClickMouseNoMove(bags[0]+12,bags[1]+5);
	  lsSleep(200);
	else
	  sleepWithStatus(1250, "Error: Could not find menu option 'Make nearby portables look like bags'\n\nWas part of the menu obscured behind Automato, perhaps?",nil, 0.7, 0.7);
  end


  if bags then
    for i=1,#vegclickList do
	checkBreak();
	safeClick(vegclickList[i][1], vegclickList[i][2], 1);
	--lsSleep(click_delay);
    end
  end
end


function Stats()
    lsDoFrame();
  while 1 do
	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Back") then
	  break;
	end
	  if ButtonText(10, lsScreenY - 30, z, 175, 0x80ff80ff, "Engage Auto Mode!") then
	    saveWaterTimer();
	    sleepWithStatus(1500, "Engaging Auto Water Mode!\n\nAlso wrote times to veggie_semiAuto.txt", nil, 0.7, 0.7);
	    break;
	  end
--	if lsButtonText(10, lsScreenY - 60, z, 100, 0xFFFFFFff, "Load File") then
--	  parseWaterTimer()
--	end


    checkBreak();
    statusScreen("Macro has been running: " .. getElapsedTime(thisSessionTimer) .. "\n\nTotal Harvests: " .. totalHarvests .. "\n\nLast Tending/Harvest Timer Report:\n\n" .. stats, nil, 0.7, 0.7);
    lsSleep(10);
  end
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function saveWaterTimer()
fullAutoMode = 1;
--pauseAfterHarvest = nil;
  local file = io.open("veggie_semiAuto.txt", "w+");
    for i=1,#vegclickTimer do
	checkBreak();
	if i ~= 1 then
      file:write("," .. vegclickTimer[i][1]);
	else
      file:write(vegclickTimer[i][1]);
      end
    end
  io.close(file);
end

--This is the same function in common.inc/sub files.  This is added so that some buttons continue to display while "sleeping" 
function sleepWithStatus(delay_time, message, color, scale)

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;


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
    local waitMessage = "Waiting ";
    if delay_time >= 1000 then
      waitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
		   waitMessage .. waitChars[frame]);
    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end

--Add Extra Buttons here...

	if fullAutoMode and not fullAutoModeQueuedOff then
	  if ButtonText(10, lsScreenY - 30, z, 175, 0xff6666ff, "Disengage Auto Mode/Finish Up") then
	    fullAutoModeQueuedOff = 1;
          sleepWithStatus(1500, "Disengaging Auto Mode...\n\nReturning to Menu, after Harvest!",nil, 0.7, 0.7)
	  end
	end
end


function statusScreen(message, color, allow_break, scale)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if allow_break == nil then
    allow_break = true;
  end
  if not scale then
    scale = 0.8;
  end
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, scale, scale, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, scale, scale, 0xffd0d0ff,
		 error_status);
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
		  0xFFFFFFff, "End script") then
    error(quit_message);
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
	    "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
	      "Hold Alt+Shift to pause this script.");
    end
    checkBreak();
  end

--Add Extra Buttons here...

	if fullAutoMode and not fullAutoModeQueuedOff then
	  if ButtonText(10, lsScreenY - 30, z, 175, 0xff6666ff, "Disengage Auto Mode/Finish Up") then
	    fullAutoModeQueuedOff = 1;
          statusScreen("Disengaging Auto Mode...\n\nReturning to Menu, after Harvest!",nil, 0.7, 0.7)
	  end
	end



  lsSleep(tick_delay);
  lsDoFrame();
end
