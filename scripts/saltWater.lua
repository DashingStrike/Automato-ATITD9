-- saltWater.lua v1.0 -- by Rhaom.
--

dofile("common.inc");
dofile("settings.inc");

askText = "Salt Water v1.0 by Rhaom - Make Salt Water and Potash in tubs \n\nAllows you to quickly set all of your tub locations by tapping the selected key over each one.\n\nThen run and it will wait for the salt water to evaporate in all marked tubs.\n\nMake sure CHAT IS MINIMIZED!\n\nPress Shift over ATITD window to continue.";

saltwaterTimer = 21;
duckTeppyOffset = 10; -- How many extra seconds to add (to each real-life minute) to compensate for game time
timer = 0;   -- Just a default to prevent error
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;

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
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Start") then
        is_done = 1;
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(50);
  end
end

function doit()
  askForWindow(askText);
  promptDelays();
  getPoints();
  clickSequence();
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

	drawWater();

	sleepWithStatus(500, "Starting... Don\'t move mouse!");
	startTime = lsGetTimer();
	for l=1, passCount do  
    	for i=1,#clickList do
		checkBreak();
		srSetMousePos(clickList[i][1], clickList[i][2]);
		lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
		EvaporateSaltWater(i);
		count = i;
    	end
    sleepWithStatus(adjustedTimer, "Waiting for " .. product .. " to finish", nil, 0.7, 0.7);
	end
	    
    for i=1,#clickList do
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(100); -- ~65+ delay needed before the mouse can actually move.
	TakeSaltPotash(i);
	count = i;
	end
	
  lsPlaySound("Complete.wav");
  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1);
end

function EvaporateSaltWater()
  checkBreak();
  closePopUp(); -- Screen clean up
  local OK = true;
  srKeyEvent('x'); -- Make Jug [J]
  closePopUp(); -- Screen clean up
end

function TakeSaltPotash()
  checkBreak();
  closePopUp(); -- Screen clean up
  local OK = true;
  srKeyEvent('t'); -- Take Everything [T]
end

function promptDelays()
  scale = 0.8;
  local z = 0;
  local is_done = nil;
  local count = 1;
  while not is_done do
	checkBreak();
	local y = 10;
	lsPrint(5, y, 0, 0.8, 0.8, 0xffffffff,
            "Key or Mouse to Select Nodes:");
	y = y + 35;
	lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_cur_value = lsDropdown("ArrangerDropDown", 5, y, 0, 200, dropdown_cur_value, dropdown_values);
	lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
	y = y + 30;
	
	passCount = readSetting("passCount",passCount);
    lsPrint(15, y, z, scale, scale, 0xffffffff, "Passes:");
    is_done, passCount = lsEditBox("passes", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, passCount);
    if not tonumber(passCount) then
      is_done = false;
      lsPrint(10, y+30, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passCount = 1;
    end
	y = y + 50;
    writeSetting("passCount",passCount);
	 
    if saltwater then
      saltwaterColor = 0x80ff80ff;
    else
      saltwaterColor = 0xffffffff;
    end
    saltwater = readSetting("saltwater",saltwater);

	if saltwater then
		saltwater = CheckBox(15, y, z+10, saltwaterColor, " Make Potash & Salt from Salt Water",
							saltwater, 0.65, 0.65);
	elseif not saltwater then
		saltwater = CheckBox(15, y, z+10, saltwaterColor, " Make Potash & Salt from Salt Water",
							 saltwater, 0.65, 0.65);
	end

	writeSetting("saltwater",saltwater);

    if saltwater then
      product = "Potash & Salt";
      timer = saltwaterTimer;
    end

	msTimer = (timer * 60) * 1000
    msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1300 -- Add extra time to compensate for duck/teppy time
	adjustedTimer = msTimer + msTimerTeppyDuckOffset;


    if saltwater or medstone or pulley then
    lsPrintWrapped(15, y+25, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
                   "Uncheck box to see more options!\n\n" .. product .. " requires " .. timer .. "m per pass\n\n" .. timer .. "m = " .. msTimer .. " ms\n" .. "+ Game Time Offset: " ..  msTimerTeppyDuckOffset .. " ms\n= " .. msTimer + msTimerTeppyDuckOffset .. " ms per pass");

      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(50);
  end
  return count;
end
