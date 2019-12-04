-- Note: Script does not attempt to read clock's region via OCR.
-- Instead it reads the coordinates, then looks them up using function coords2region on common_gps.inc (valid for T9)

dofile("common.inc");
dofile("settings.inc");

walkX = 0;
walkY = 0;
showTime = nil;

function doit()

askForWindow("Test OCR on ATITD Clock.\n\nReturn Coordinates and Lookup Regions");

  while 1 do
    checkBreak();
    srReadScreen();
    local startPos = findCoords();
    --faction is a global returned from findCoords() -- common_find.inc
    local message = "Note: You can run around and see coordinates update ...\n\nFaction Region: " .. faction .. "\n";
    if startPos then
      local x = startPos[0];
      local y = startPos[1];
      coord2region(x,y);
      message = message .. "Region: " .. regionName .. "\nCoordinates: " .. startPos[0] .. ", " .. startPos[1];
    else
      message = message .. "Coordinates NOT Found";
    end


    if showTime then
      srReadScreen(); -- on purpose we have another srReadScreen(), after the one above; or else it'll error
      local fetchTime = getTime(1);

        if fetchTime then
          message = message .. "\n\nTime: " .. getTime(1)
        else
          message = message .. "\n\nTime NOT Found";
        end
    end

    sleepWithStatus(250, message, nil, 0.7, "Reading ATID Clock");
    lsSleep(10);
  end
end



--Custom sleepWithStatus to add extra boxes, buttons, etc
local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatus(delay_time, message, color, scale, waitMessage)
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

  local y = 240;
  local z = 0;
  local scale = 0.7;
  showTime = CheckBox(10, y-28, z, 0xFFFFFFff, " Show Clock Time", showTime, 0.65, 0.65);
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Walk to Coordinates:");
  y = y + 25;
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "X:");
  walkX = readSetting("walkX",walkX);
  foo, walkX = lsEditBox("walkX", 30, y, z, 70, 0, scale, scale, 0x000000ff, walkX);
		if not tonumber(walkX) then
			lsPrint(110, y+2, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			walkX = 0;
		end
  writeSetting("walkX",walkX);
  y = y + 20;
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Y:");
  walkY = readSetting("walkY",walkY);
  foo, walkY = lsEditBox("walkY", 30, y, z, 70, 0, scale, scale, 0x000000ff, walkY);
		if not tonumber(walkY) then
			lsPrint(110, y+2, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			walkY = 0;
		end
  writeSetting("walkY",walkY);
    if not globalWalking then

	  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Walk") then
	        while lsMouseIsDown() do
	          sleepWithStatus(16, "Release Mouse !", nil, 0.7, "Preparing to Walk");
	        end
	    if not firstWalk then
	      setCameraView(CARTOGRAPHERCAM); -- Set to F8 camera
	      srClickMouse(5,5, 1); -- Right click to put ATITD back in focus
	      lsSleep(100);
	      srSetMousePos(0,0); -- Move Mouse to top left corner of screen
	      sleepWithStatus(2000, "Please wait ...", nil, 0.7, "Zooming in slightly");
	      center = srGetWindowSize();
	      srSetMousePos((center[0]/2)-50, (center[1]/2)+50); -- Move mouse away to stop zooming
	      toPos = makePoint(tonumber(walkX), tonumber(walkY));
	    end
	    walkTo(toPos);
	    firstWalk = 1;
	  end

    else

	  if not globalWalkingStop then
	    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Stop") then
	      globalWalkingStop = 1;
	        while lsMouseIsDown() do
	          sleepWithStatus(16, "Release Mouse !", nil, 0.7, "Preparing Brakes");
	        end
	    end
	  end

    end

    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   waitMessage .. waitChars[frame]);
    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end
