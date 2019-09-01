-- potteryAuto.lua
-- by Rhaom - v1.0 added August 21, 2019

dofile("common.inc");
dofile("settings.inc");

-- times are in minutes.  They are converted to ms and daffy/teppy time is also adjusted later
jugTimer = 1;
mortarTimer = 1;
duckTeppyOffset = 10; -- How many extra seconds to add (to each real-life minute) to compensate for game time
timer = 0;   -- Just a default to prevent error
arrangeWindows = true;

askText = "potteryAuto v1.0 - by Rhaom\n\nMould Jugs or Clay Mortars, without the mouse being used.\n\nPin up windows manually or select the arrange windows checkbox.";


function doit()
	askForWindow(askText);
	config();
		if(arrangeWindows) then
			arrangeInGrid(nil, nil, nil, nil,nil, 8, 35);
		end
	unpinOnExit(start);
end

function start()
	for i=1, passCount do
		-- refresh windows
		clickAllText("This is");
		lsSleep(500);
		
		message = "Clicking " .. product;

        if jug then
			clickAllText("Mould a Jug");
        elseif mortar then
			clickAllText("Mould a Clay Mortar");
        end

		lsSleep(500);
		closePopUp();  --If you don't have enough cuttable stones in inventory, then a popup will occur. We don't want these, so check.
		sleepWithStatus(adjustedTimer, "Waiting for " .. product .. " to finish", nil, 0.7, 0.7);
	end
	lsPlaySound("Complete.wav");
end

function config()
  scale = 0.8;
  
  local z = 0;
  local is_done = nil;
	-- Edit box and text display
	while not is_done do
		checkBreak("disallow pause");
		lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Configure Pottery Wheel");
		local y = 40;

		passCount = readSetting("passCount",passCount);
		lsPrint(10, y, z, scale, scale, 0xffffffff, "Passes:");
		is_done, passCount = lsEditBox("passes", 100, y, z, 50, 30, scale, scale,
									   0x000000ff, passCount);
		if not tonumber(passCount) then
		  is_done = nil;
		  lsPrint(10, y+30, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
		  passCount = 1;
		end
		
		passCount = tonumber(passCount);
		writeSetting("passCount",passCount);
		y = y + 35;
		
		arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
		arrangeWindows = CheckBox(10, y, z, 0xFFFFFFff, "Arrange windows", arrangeWindows, 0.65, 0.65);
		writeSetting("arrangeWindows",arrangeWindows);
		y = y + 32;

		unpinWindows = readSetting("unpinWindows",unpinWindows);
		unpinWindows = CheckBox(10, y, z, 0xFFFFFFff, "Unpin windows on exit", unpinWindows, 0.65, 0.65);
		writeSetting("unpinWindows",unpinWindows);
		y = y + 32;
		
	if jug then
      jugColor = 0x80ff80ff;
    else
      jugColor = 0xffffffff;
    end
    if mortar then
      mortarColor = 0x80ff80ff;
    else
      mortarColor = 0xffffffff;
    end

    jug = readSetting("jug",jug);
    mortar = readSetting("mortar",mortar);

    if not mortar then
      jug = CheckBox(15, y, z+10, jugColor, " Mould a Jug",
                           jug, 0.65, 0.65);
      y = y + 32;
    else
      jug = false
    end

    if not jug then
      mortar = CheckBox(15, y, z+10, mortarColor, " Mould a Clay Mortar",
                              mortar, 0.65, 0.65);
      y = y + 32;
    else
      mortar = false
    end

    writeSetting("jug",jug);
    writeSetting("mortar",mortar);
	
	if jug then
      product = "Wet Clay Jug";
	  timer = jugTimer;
    elseif mortar then
      product = "Wet Clay Mortar";
	  timer = mortarTimer;
	end
	
	msTimer = (timer * 60) * 1000
    msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1600 -- Add extra time to compensate for duck/teppy time
	adjustedTimer = msTimer + msTimerTeppyDuckOffset;

    if jug or mortar then
    lsPrintWrapped(15, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
                   "Uncheck box to see more options!\n\n A " .. product .. " requires " .. timer .. "m per pass\n\n" .. timer .. "m = " .. msTimer .. " ms\n" .. "+ Game Time Offset: " ..  msTimerTeppyDuckOffset .. " ms\n= " .. msTimer + msTimerTeppyDuckOffset .. " ms per pass");

      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
        is_done = 1;
      end
    end

	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end

	lsDoFrame();
	lsSleep(tick_delay);
	end
	
	if(unpinWindows) then
		setCleanupCallback(cleanup);
	end;
end

function closePopUp()
  while 1 do
    srReadScreen()
    local ok = srFindImage("OK.png")
    if ok then
      statusScreen("Found and Closing Popups ...", nil, 0.7, 0.7);
      srClickMouseNoMove(ok[0]+5,ok[1],1);
      lsSleep(100);
    else
      break;
    end
  end
end