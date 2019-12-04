dofile("common.inc");

function doit()
	askForWindow("Test ATITD Clock.\n\nHover ATITD window and Press Shift to continue.");

  local size = srGetWindowSize()
  local x = size[0];
  local y = size[1];
  local centerX = x/2;
  local centerY = y/2;
  local zoomLevel = 1.0; -- Default Zoom Level
  local zoomeLevelStep = 0.5; -- If you want smaller/larger zoom levels, then change to 0.25, 0.50, 0.75, 1.0, or whatever

  srReadScreen();
  local clockRegion = findClockRegion();

  while 1 do
    checkBreak();	
    srReadScreen();

    srStripRegion(clockRegion.x, clockRegion.y, clockRegion.width, clockRegion.height);
    srMakeImage("clock-region", clockRegion.x, clockRegion.y, clockRegion.width, clockRegion.height);
    srShowImageDebug("clock-region", 5, 150, 1, zoomLevel);

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "Exit") then
      error "Clicked End Script button";
    end


    if ButtonText(60, lsScreenY - 30, 0, 20, 0xFFFFFFff, "-") then
      zoomLevel = zoomLevel - zoomeLevelStep;
    end

    if ButtonText(84, lsScreenY - 30, 0, 20, 0xFFFFFFff, "+") then
      zoomLevel = zoomLevel + zoomeLevelStep;
    end

    lsPrint(10, lsScreenY - 28, 0, 0.7, 0.7, 0xFFFFFFff, "Zoom:");

    lsPrintWrapped(10, 10, 0, lsScreenX-15, 0.7, 0.7, 0xFFFFFFff,
             "Screen Size: " .. x .. " x " .. y .. "\nCenterX/Y: " .. math.floor(centerX) .. ", " .. math.floor(centerY) .. 
             "\nClock Region: " .. math.floor(clockRegion.x) .. ", " .. math.floor(clockRegion.y) .. ", " .. math.floor(clockRegion.width) .. ", " .. 
              math.floor(clockRegion.height) .. "\nFaction Detected: " .. faction .. "\nZoom Level: " .. zoomLevel  );

    lsDoFrame();
    lsSleep(10);
  end
end
