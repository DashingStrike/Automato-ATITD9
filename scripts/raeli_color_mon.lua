-- Revamped by Cegaiel

lsRequireVersion(2,50) -- v2.50 adds srSaveImageDebug used in this script. Give error if user tries to use lower version.

dofile("common.inc");

allow_break = false; -- Change to true if you want to allow Ctrl+Shift or Alt+Shift (false will Help prevent accidentally exiting macro)

function doit()

  askForWindow("Pin a Raeli Oven window.\n\nMacro will monitor the window for change based on the color / text (inside color bar) on window and take a screenshot when it occurs.\n\nScreenshots appear as raeli_#.png in C:\\Games\\Automato folder.\n\nWrites a log to raeli.txt, in ATITD9 folder, showing other useful information.");

  settings();
  srReadScreen();
  oven = findText("This is [a-z]+ Raeli Oven", nil, REGEX)
  if not oven then
    error('Could not find a Raeli Oven pinned')
  end
  raeliRegion()
  makeImage()
  lastImage = srFindImageInRange("last-raeli", topLeftX, topLeftY, width, height)
  getPixel()
  startTime = lsGetTimer();
  lastReset = lsGetTimer()
  lsPlaySound("beepping.wav")
  screenshot()
  DeleteLog()

  while 1 do
    if changes == 0 then
      word = "Inital"
    else
      word = "Last"
    end

    findOven()

    if not lastImage and oven then -- Change has occured
      makeImage()
      getPixel()
      changes = changes + 1
      lsPlaySound("beepping.wav")
      resetTimer()
	screenshot()
    end

    sleepWithStatus(500, extraSpace .. "Pixel: " .. px .. "\nRGBA: " .. rgba .. "\n" .. "HSV: " .. hsv .. "\n\nChanges Occurred: " .. changes .. "\n\nLast Change Elapsed: " .. formatLastChange(lastChange) .. "\n\nTotal Elapsed Time: " .. getElapsedTime(startTime) .. "\n\n" .. word .. " Image Saved: " .. screenshot_filename_prefix .. changes .. screenshot_filename_suffix .. ".png\n\nNote: Moving your raeli window or quickly Alt+Tabbing will NOT break the macro!", nil, 0.7, status)

  end
end


function settings()
  changes = 0;
  lastChange = 0
  screenshot_filename_prefix = "raeli_"
  if allow_break then
    messageY = 50
    imageY = 80
    extraSpace = "\n\n\n"
  else
    messageY = 10
    imageY = 40
    extraSpace = "\n";
  end

  while 1 do
  local y = 10;
  local scale = 0.7;
  checkBreak()
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Extra Text on Filename?  (Optional)");
  y = y + 25;
  is_done, screenshot_filename_suffix = lsEditBox("screenshot_filename_suffix", 10, y, z, 260, 25, scale, scale, 0x000000ff);
  y = y + 35;
  if screenshot_filename_suffix ~= "" then
    screenshot_filename_suffix = "_" .. screenshot_filename_suffix
  end
  lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Filename:");
  lsPrint(80, y-1, z, 0.8, 0.8, 0xffb43fff, screenshot_filename_prefix .. "#" .. screenshot_filename_suffix .. ".png");
  y = y + 35;
  lsPrintWrapped(10, y, z, lsScreenX - 20, scale, scale, 0xFFFFFFff, "Macro will save screenshots of your oven when a color/text change has occured. By default they are saved as raeli_0.png, raeli_1.png, etc. Optionally, you can add text above to alter the filename in case you are testing different ovens.\n\nAlso note log files are saved in raeli.txt which records useful information (Egypt Date/Time, coordinates, Time elapsed since last change, total time running.");

  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Start") then
      while lsMouseIsDown() do
        sleepWithStatus(16, "Release Mouse to continue ...", nil, 0.7, "Preparing to Click");
      end
    break;
  end
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
    error "Clicked End Script button";
  end
  lsDoFrame()
  lsSleep(10)
  end
end


function findOven()
  srReadScreen();
  oven = findText("This is [a-z]+ Raeli Oven", nil, REGEX)
  if oven then
    status = "Monitoring for change"
    raeliRegion()
    lastImage = srFindImageInRange("last-raeli", topLeftX, topLeftY, width, height)
  else
    status = "Can\'t find Raeli Oven"
  end
end


function makeImage()
  srReadScreen(); -- Don't remove this. We always need to do another Read (even if one occured recently) to prevent stripped background from previous findText()'s
  srMakeImage("last-raeli", topLeftX, topLeftY, width, height);  -- The color part of oven window
  srMakeImage("raeli-oven", window.x, window.y, window.width, window.height); -- The entire oven window
end


function screenshot()
  srReadScreen(); -- Re-Read screen so that the screenshot doesn't show a white (stripped window) from earlier findText()
  srSaveImageDebug("raeli-oven", screenshot_filename_prefix .. changes .. screenshot_filename_suffix .. ".png");
  WriteLog()
end


function getPixel()
  px = srReadPixel(topLeftX+10, topLeftY);
  rgba = (math.floor(px/256/256/256) % 256) .. ", " .. (math.floor(px/256/256) % 256) .. ", " .. (math.floor(px/256) % 256) .. ", " .. (px % 256);
  hsv = lsRGBAtoHSV(px)
  hsv = round(hsv[0]) .. ", " .. round(hsv[1]*100) .. "%, " .. round(hsv[2]*100) .. "%"
end


function resetTimer()
  lastChange = lsGetTimer() - lastReset
  lastReset = lsGetTimer()
end


function raeliRegion()
  window = getWindowBorders(oven[0], oven[1]);
  --This is the color portion of oven window
  bottomRightX = window.width + window.x - 15
  bottomRightY = window.height + window.y - 55
  topLeftX = window.x+15
  topLeftY = bottomRightY-35
  width = bottomRightX - topLeftX
  height = bottomRightY - topLeftY
end


function fetchGameClock()
  srReadScreen();
  if getTime() then
    dateTime = getTime(1)
  else
    dateTime = "Unknown Date/Time"
  end
  local startPos = findCoords();
  if startPos then
    local x = startPos[0];
    local y = startPos[1];
    coord2region(x,y); -- Fetch Region Name
    location = x .. ", " .. y .. " (" .. regionName .. ")" 
  else
    location = "Unknown Location"  
  end
end


function round(num)
  return math.floor(num + 0.5)
end


function formatLastChange(theTime)
  local duration = math.floor(theTime / 1000);
  local hours = math.floor(duration / 60 / 60);
  local minutes = math.floor((duration - hours * 60 * 60) / 60);
  local seconds = duration - hours * 60 * 60 - minutes * 60;
  return string.format("%02d:%02d:%02d",hours,minutes,seconds);
end


function DeleteLog()
  fetchGameClock()
  logfile = io.open("raeli.txt","w+");
  logfile:write("0: " ..dateTime .. " @ " .. location .. "\nFile: " .. screenshot_filename_prefix .. "0" .. screenshot_filename_suffix .. ".png\nPixel: " .. px .. "\nRGB: " .. rgba .. "\nHSV: " .. hsv .. "\n\n\n");
  logfile:close();
end


function WriteLog()
  fetchGameClock()
  local Text = changes .. ": " ..dateTime .. " @ " .. location .. "\nFile: " .. screenshot_filename_prefix .. changes .. screenshot_filename_suffix .. ".png\nPixel: " .. px .. "\nRGB: " .. rgba .. "\nHSV: " .. hsv .. "\n" .. formatLastChange(lastChange) .. " - Elapsed Time Since Last Change\n" .. getElapsedTime(startTime) .. " - Elapsed Time Macro has been Running\n\n"
  logfile = io.open("raeli.txt","a+");
  logfile:write(Text .. "\n");
  logfile:close();
end


-- Custom version of sleepWithStatus so that srShowImageDebug image appears without flickering

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;
local waitFrame2 = 1;
local circleSize = {2, 3, 4, 5, 6, 7, 8, 9};


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
    local frame2 = math.floor(waitFrame2/10) % #circleSize + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    newWaitMessage = waitMessage;
    if delay_time >= 1000 then
      newWaitMessage = waitMessage .. time_left .. " ms ";
    end

    lsPrintWrapped(10, messageY, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);

    lsDrawCircle(220, imageY + 65, 1, circleSize[frame2], 0.1, px)
    lsDrawCircle(220, imageY + 65, 0, 10, 0.95, px)

    if oven then
      srShowImageDebug("last-raeli", 10, imageY, 1, 0.8);
    end
    statusScreen(message, color, allow_break, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
    waitFrame2 = waitFrame2 + 1;
  end
end
