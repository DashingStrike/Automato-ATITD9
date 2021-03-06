dofile("ui_utils.inc");
dofile("settings.inc");
dofile("constants.inc");
dofile("screen_reader_common.inc");
dofile("common.inc");
dofile("serialize.inc");

steepNames = {"Wool Cloth", "Canvas"};
hotkeyTaskNames = {"Sulphurous Water", "Salt Water", "Make Max Pulp", "Rot Max Dung", "Rot Max Flax"};

evaporationTimer = 15;
duckTeppyOffset = 10; -- How many extra seconds to add (to each real-life minute) to compensate for game time
timer = 0;   -- Just a default to prevent error
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;

waterPause = 300;

arrangeWindows = true;
unpinWindows = true;

function doit()
  askForWindow("Automated tub related material production, written by Rhaom for T9\n\nPinned Window Mode\n- Automatically Steep 'Canvas' or 'Wool Cloth' in Clay\n\nHotkey Mode\n- Automatically gather 'Water' and produce 'Potash & Salt', 'Saltpeter', 'Rotten Flax' or 'Pulp' from any given water type");
  promptParameters();
  if pinnedMode then
    if(arrangeWindows) then
      arrangeInGrid(nil, nil, nil, nil,nil, 10, 25);
    end  
      checkBreak();
      sleepWithStatus(1200, "Preparing to Start ...\n\nHands off the mouse!"); 
      claySteep();
        if(unpinWindows) then
          closeAllWindows();
        end
  elseif hotkeyMode then
    arrangeWindows = false;
    getPoints();
    clickSequence();
  end
end

function promptParameters()
  scale = 1.1;

  local z = 0;
  local is_done = nil;
  local value = nil;
  -- Edit box and text display
  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak();

    local y = 40;

    lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

    lsPrintWrapped(10, y-35, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
      "Tubs.lua - Written by Rhaom for T9\n\n");

    if pinnedMode and not hotkeyMode then
        steepInClay = readSetting("steepInClay",steepInClay);
        lsPrint(10, y-5, z, scale, scale, 0xFFFFFFff, "Steep in Clay:");
        steepInClay = lsDropdown("steepInClay", 155, 35, 0, 150, steepInClay, steepNames);
        writeSetting("steepInClay",steepInClay);
        y = y + 32;

        passCount = readSetting("passCount",passCount);
        lsPrint(10, y-5, z, scale, scale, 0xffffffff, "Passes:");
        is_done, passCount = lsEditBox("passes", 100, y-5, z, 50, 30, scale, scale, 0x000000ff, passCount);
        if not tonumber(passCount) then
        is_done = false;
        lsPrint(10, y+20, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        passCount = 1;
        end
        y = y + 32;
        writeSetting("passCount",passCount);

        if (steepInClay == 1) then
            product = "Wool Cloth";
        elseif (steepInClay == 2) then
            product = "Canvas";
        end
    else
        pinnedMode = false;
    end

    if hotkeyMode and not pinnedMode then
        lsPrint(10, y-5, z, scale, scale, 0xFFFFFFff, "Hotkey:");
        dropdown_cur_value = lsDropdown("ArrangerDropDown", 100, 35, 0, 200, dropdown_cur_value, dropdown_values);
        y = y + 32;

        hotkeyTask = readSetting("hotkeyTask",hotkeyTask);
        lsPrint(10, y-5, z, scale, scale, 0xFFFFFFff, "Task:");
        hotkeyTask = lsDropdown("hotkeyTask", 100, 65, 0, 200, hotkeyTask, hotkeyTaskNames);
        writeSetting("hotkeyTask",hotkeyTask);
        y = y + 32;

        passCount = readSetting("passCount",passCount);
        lsPrint(10, y-5, z, scale, scale, 0xffffffff, "Passes:");
        is_done, passCount = lsEditBox("passes", 100, y-5, z, 50, 30, scale, scale, 0x000000ff, passCount);
        if not tonumber(passCount) then
        is_done = false;
        lsPrint(10, y+20, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        passCount = 1;
        end
        y = y + 32;
        writeSetting("passCount",passCount);
    else
        hotkeyMode = false;
    end

    if pinnedMode then
        lsPrintWrapped(10, y+5, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
        "Global Settings\n-------------------------------------------");

        arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
        arrangeWindows = CheckBox(10, y+30, z, 0xFFFFFFff, " Arrange windows (Grid format)", arrangeWindows, 0.65, 0.65);
        writeSetting("arrangeWindows",arrangeWindows);

        unpinWindows = readSetting("unpinWindows",unpinWindows);
        unpinWindows = CheckBox(10, y+50, z, 0xFFFFFFff, " Unpin windows on exit", unpinWindows, 0.65, 0.65);
        writeSetting("unpinWindows",unpinWindows);
        y = y + 62;
    elseif hotkeyMode then
        lsPrintWrapped(10, y+5, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
        "Task Settings\n-------------------------------------------");

        arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
        arrangeWindows = CheckBox(10, y+30, z, 0xFFFFFFff, " Arrange windows (Grid format)", arrangeWindows, 0.65, 0.65);
        writeSetting("arrangeWindows",arrangeWindows);

        if gatherWater then
            gatherWaterColor = 0x80ff80ff;
          else
            gatherWaterColor = 0xffffffff;
          end
          gatherWater = readSetting("gatherWater",gatherWater);
        
          if gatherWater then
            gatherWater = CheckBox(10, y+50, z, gatherWaterColor, " Auto Gather Water",
                      gatherWater, 0.65, 0.65);
          elseif not gatherWater then
            gatherWater = CheckBox(10, y+50, z, gatherWaterColor, " Auto Gather Water",
                        gatherWater, 0.65, 0.65);
          end
        
          writeSetting("gatherWater",gatherWater);
          y = y + 62;
    else
        lsPrintWrapped(10, y+5, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
        "Global Settings\n-------------------------------------------");

        lsPrintWrapped(10, y+45, z, lsScreenX - 20, 0.7, 0.7, 0xFF0000ff,
        "You must select a mode setting!");
        y = y + 62;
    end

    lsPrintWrapped(10, y+15, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
    "Mode Settings\n---------------------------------------");

    if pinnedMode then
      pinnedModeColor = 0x80ff80ff;
    else
      pinnedModeColor = 0xffffffff;
    end
    if hotkeyMode then
      hotkeyModeColor = 0x80ff80ff;
    else
      hotkeyModeColor = 0xffffffff;
    end
        
    pinnedMode = readSetting("pinnedMode",pinnedMode);
    hotkeyMode = readSetting("hotkeyMode",hotkeyMode);

    if not hotkeyMode then
      pinnedMode = CheckBox(10, y+50, z, pinnedModeColor, " Pinned Window Mode", pinnedMode, 0.65, 0.65);
      writeSetting("pinnedMode",pinnedMode);
		  y = y + 22;
		else
		  pinnedMode = false
		end

    if not pinnedMode then
      hotkeyMode = CheckBox(10, y+50, z, hotkeyModeColor, " Hotkey Mode", hotkeyMode, 0.65, 0.65);
      writeSetting("hotkeyMode",hotkeyMode);
		  y = y + 22;
		else
		  hotkeyMode = false
    end

    y = y + 50
    if pinnedMode then
      helpText = "Uncheck Pinned Mode to switch to Hotkey Mode"
    elseif hotkeyMode then
      helpText = "Uncheck Hotkey Mode to switch to Pinned Mode"
    else
      helpText = "Check Hotkey or Pinned Mode to Begin"
    end

    lsPrint(10, y+3, z, 0.65, 0.65, 0xFFFFFFff, helpText);

    lsPrintWrapped(10, y+30, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
	  "Stand where you can reach all tubs with all ingredients on you.");
	  
	if pinnedMode and passCount ~= 1 then
		if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Begin") then
			is_done = 1;
        end
    else
        if hotkeyMode and passCount ~= 1 then
            if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Next") then
                is_done = 1;
            end
        end
	end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff,
      "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(tick_delay);
  end

end

function claySteep()
  for i=1, passCount do
      -- refresh windows
    statusScreen("Refreshing Windows");
    refreshWindows();
    lsSleep(500);

    statusScreen("Opening 'Steep in Clay...' menu");
    clickAllText("Steep")
    lsSleep(500);

    statusScreen("Clicking " .. product);

    message = "Clicking " .. product;

    if product == "Wool Cloth" then
      clickAllText("Wool Cloth");
    elseif product == "Canvas" then
      clickAllText("Canvas");
    end

    lsSleep(500);
    srReadScreen();
    noResources = srFindImage("tubs/dontHave.png");
      if noResources then
        closePopUp();
        error("Out of resources");
      end
    closePopUp();
    checkSteeping();
  end
  srReadScreen();
  clickAllText("Take...");
  lsSleep(250);
  srReadScreen();
  clickAllText("Everything");
end

function refreshWindows()
  srReadScreen();
  this = findAllText("This");
  for i = 1, #this do
      clickText(this[i]);
  end
  lsSleep(100);
end

function checkSteeping()
    while 1 do
        refreshWindows();
        srReadScreen();
        steeping = findAllText("Steeping")
          if #steeping == 0 then
              break; --We break this while statement because Steeping is not detect, hence we're done with this round
          end
        sleepWithStatus(999, "Waiting for " .. product .. " to finish steeping", nil, 0.7, "Monitoring Pinned Window(s)");
    end
end

function closePopUp()
    while 1 do -- Perform a loop in case there are multiple pop-ups behind each other; this will close them all before continuing.
        checkBreak();
        srReadScreen();
        OK = srFindImage("OK.png");
        if OK then
            srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
            lsSleep(100);
        else
            break;
        end
    end
end

function clickSequence()
	sleepWithStatus(500, "Starting... Don\'t move mouse!");
	startTime = lsGetTimer();
  for l=1, passCount do
    if gatherWater then
      drawWater();	
    end
    	for i=1,#clickList do
		checkBreak();
		srSetMousePos(clickList[i][1], clickList[i][2]);
		lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
		evaporateWaterType(i);
		count = i;
      end
    sleepWithStatus(adjustedTimer, "Waiting for " .. product .. " to finish", nil, 0.7);
	end
	    
    for i=1,#clickList do
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
	takeProduct(i);
	count = i;
	end
	
  lsPlaySound("Complete.wav");
  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1);
end

function evaporateWaterType()
  checkBreak();
  closePopUp(); -- Screen clean up
  local OK = true;
  if hotkeyTask == 1 then
    srKeyEvent('s');
    product = "Sulfur";    
  end
  if hotkeyTask == 2 then
    srKeyEvent('x');
    product = "Potash & Salt";   
  end
  if hotkeyTask == 3 then
    srKeyEvent('w');
    srReadScreen();
      noWater = srFindImage("tubs/dontHave.png");
        if noWater then
          closePopUp();
          error("You do not have any water")
        end
    lsSleep(waterPause);
    srKeyEvent('p');
    product = "Paper Pulp";
  end
  if hotkeyTask == 4 then
    srKeyEvent('w');
    srReadScreen();
      noWater = srFindImage("tubs/dontHave.png");
        if noWater then
          closePopUp();
          error("You do not have any water")
        end
    lsSleep(waterPause);
    srKeyEvent('d');
    product = "Saltpeter";
  end
  if hotkeyTask == 5 then
    srKeyEvent('w');
    srReadScreen();
      noWater = srFindImage("tubs/dontHave.png");
        if noWater then
          closePopUp();
          error("You do not have any water")
        end
    lsSleep(waterPause);
    srKeyEvent('f');
    product = "Rotten Flax";
  end

  msTimer = (evaporationTimer * 60) * 1000
  msTimerTeppyDuckOffset = (duckTeppyOffset * evaporationTimer) * 160 -- Add extra time to compensate for duck/teppy time
  adjustedTimer = msTimer + msTimerTeppyDuckOffset;  

  closePopUp(); -- Screen clean up
end

function takeProduct()
  checkBreak();
  closePopUp(); -- Screen clean up
  local OK = true;
  srKeyEvent('t'); -- Take Everything [T]
end

function getPoints()
    clickList = {};
      local was_shifted = lsShiftHeld();
      
      if (dropdown_cur_value == 1) then
      was_shifted = lsShiftHeld();
      key = "tap Shift";
      elseif (dropdown_cur_value == 2) then
      was_shifted = lsControlHeld();
      key = "tap Ctrl";
      elseif (dropdown_cur_value == 3) then
      was_shifted = lsAltHeld();
      key = "tap Alt";
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
          clickList[#clickList + 1] = {mx, my};
        end
        was_shifted = is_shifted;
        checkBreak();
        lsPrint(10, 10, z, 0.7, 0.7, 0xFFFFFFff,
            "Set Tub Locations (" .. #clickList .. ")");
        local y = 60;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Select camera and zoom level");
        y = y + 20
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "that best fits the tubs in screen.")
        y = y + 20
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Suggest: F8F8 view.")
        y = y + 20
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Lock ATITD screen with Alt+L")
        y = y + 40;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "MAKE SURE CHAT IS MINIMIZED!")
        y = y + 40;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "1) Set all tub locations:");
        y = y + 20;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Hover mouse, " .. key .. " over each")
        y = y + 20;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "tub.")
        y = y + 30;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "2) After setting all tub locations:")
        y = y + 20;
        lsPrint(5, y, z, 0.6, 0.6, 0xf0f0f0ff, "Click Start to begin checking tubs.")
    
        if #clickList >= 1 then -- Only show start button if one or more pottery wheel was selected.
          if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Start") then
            is_done = 1;
          end
        end
    
        if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff,
                        "End script") then
          error "Clicked End Script button";
        end
    
        lsDoFrame();
        lsSleep(50);
      end
    end
