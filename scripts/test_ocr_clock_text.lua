dofile("common.inc");

zoomLevel = 1.0;
xOffset = 0;
yOffset = 0;
pointingSpeed = 2000; --ms


function doit()
  askForWindow("Find Text on Clock.\n\nHover ATITD window and Press Shift to continue.");

  clockRegion = findClockRegion();

  while 1 do
    checkBreak();
    srReadScreen();
    lsPrintWrapped(10, 100, 0, lsScreenX - 20, 0.7, 0.7, 0xFFFFFFff, "Search Text:");
    foo, searchChar = lsEditBox("searchChar", 10, 120, z, 240, 25, 1.0, 1.0, 0x000000ff);
    message = "Searching Text: " .. searchChar .. "\n\nResults: ";

    if searchChar ~= "" then
    	find = findText(searchChar, clockRegion);
    	findQty = findAllText(searchChar, clockRegion);

    	if find then
        --srSetMousePos(find[0],find[1]);
        message = message .. "FOUND on " .. #findQty .. " Line (s)"
    	else
        message = message .. "not found";
    	end

    else
      message = "Enter Text to being searching";
    end

    srMakeImage("clock-region", clockRegion.x, clockRegion.y, clockRegion.width, clockRegion.height);
    srShowImageDebug("clock-region", 5, 5, 1, zoomLevel);

    lsPrintWrapped(10, lsScreenY - 160, 0, lsScreenX - 20, 0.7, 0.7, 0xFFFFFFff, message);

    if find then
      if lsButtonText(10, lsScreenY - 30, 20, 100, 0xFFFFFFff, "Point") then
        pointToLocation();
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 1000, 100, 0xFFFFFFff, "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(10);
  end
end


function pointToLocation()
  window = 1;
  xOffset = 0;
  yOffset = 0;

  while 1 do
    if lsMouseIsDown(1) then
      lsSleep(50);
      -- Don't move mouse until we let go of mouse button
    else
      lsSleep(100); -- wait a moment in case we moved mouse while clicking
      if not tonumber(xOffset) then
        xOffset = 0;
      end
      if not tonumber(yOffset) then
        yOffset = 0;
      end

  findBlah = findAllText(searchChar, clockRegion);

      for i=#findBlah, 1, -1 do
        srSetMousePos(findBlah[i][0]+xOffset,findBlah[i][1]+yOffset);
        sleepWithStatus(pointingSpeed, "Pointing to Location " .. window .. "/" .. #findBlah .. "\n\nX Offset: " 
          .. xOffset .. "\nY Offset: " .. yOffset .. "\n\nMouse Location: " .. findBlah[i][0]+xOffset .. ", " .. 
        findBlah[i][1]+yOffset, nil, 0.7, 0.7);
        window = window + 1;
      end

      break;
    end
  end
end
