dofile("common.inc");

function doit()
	askForWindow("Test ATITD Clock.\n\nHover ATITD window and Press Shift to continue.");

dofile("ocr_clock.inc");

  zoomLevel = 1.0; -- Default Zoom Level
  zoomeLevelStep = 0.5; -- If you want smaller/larger zoom levels, then change to 0.25, 0.50, 0.75, 1.0, or whatever

  while 1 do
    checkBreak();	
      srReadScreen();

    --  srStripRegion(853,14, 214,48); -- Works at least on 1920x1080
    srStripRegion(clockUpperLeftX, clockUpperLeftY, clockWidth, clockHeight);
    --  srSaveLastReadScreen("screen_background.png");

    --srSetMousePos(centerX-110,15)  -- clock upper left
    --srSetMousePos(centerX+110,65)  -- clock lower right
    --srSetMousePos(centerX,12)  -- Where to fetch pixel color to determine faction and color range we need

    --srMakeImage(const char *name, int x, int y, int w, int h)
    srMakeImage("clock-region", clockUpperLeftX, clockUpperLeftY, clockWidth, clockHeight);
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
             "\nClock Region: " .. math.floor(clockUpperLeftX) .. ", " .. math.floor(clockUpperLeftY) .. ", " .. math.floor(clockWidth) .. ", " .. 
              math.floor(clockHeight) .. "\nFaction Detected: " .. faction .. "\nZoom Level: " .. zoomLevel  );


    lsDoFrame();
    lsSleep(10);
  end
end
