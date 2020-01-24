-- Revamped by Cegaiel

dofile("common.inc");

allow_break = false; -- Change to true if you want to allow Ctrl+Shift or Alt+Shift (false will Help prevent accidentally exiting macro)


function doit()

  askForWindow("Pin a Raeli Oven window.\nMacro will monitor the window for change based on the color/ color text on window and take a screenshot when it occurs.\n\nScreenshots appear as raeli_#_.png in C:\\Games\\Automato folder.\n\nWrites a log to raeli.txt, in ATITD9 folder, showing how long since last change occured and filename of screenshot what was created.");

  srReadScreen();
  oven = findText("This is [a-z]+ Raeli Oven", nil, REGEX)

  if not oven then
    error('Could not find a Raeli Oven pinned')
  end

  raeliRegion()
  srMakeImage("last-raeli", topLeftX, topLeftY, width, height);
  lastImage = srFindImageInRange("last-raeli", topLeftX, topLeftY, width, height)

  startTime = lsGetTimer();
  lastReset = lsGetTimer()
  changes = 0;
  lastChange = 0
  lsPlaySound("beepping.wav")
  screenshot()
  DeleteLog()

  while 1 do
    if changes == 0 then
      word = "Inital"
    else
      word = "Last"
    end
    if allow_break then
      messageY = 50
      imageY = 80
      extraSpace = "\n\n\n"
    else
      messageY = 10
      imageY = 40
      extraSpace = "";
    end

    findOven()

    if not lastImage and oven then
      srMakeImage("last-raeli", topLeftX, topLeftY, width, height);
      changes = changes + 1
      lsPlaySound("beepping.wav")
      resetTimer()
	screenshot()
    end

    sleepWithStatus(500, extraSpace .. "Changes Occurred: " .. changes .. "\n\nLast Change Elapsed: " .. formatLastChange(lastChange) .. "\n\nTotal Elapsed Time: " .. getElapsedTime(startTime) .. "\n\n" .. word .. " Image Saved: " .. "raeli_" .. changes .. "_" .. ".png\n\nNote: Moving your raeli window or quickly Alt+Tabbing will NOT break the macro!", nil, 0.7, status)

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


function screenshot()
  srReadScreen(); -- Re-Read screen so that the screenshot doesn't show a white (stripped window) from earlier findText()
  srSaveLastReadScreen("raeli_" .. changes .. "_" .. ".png");
  WriteLog()
end


function resetTimer()
  lastChange = lsGetTimer() - lastReset
  lastReset = lsGetTimer()
end


function raeliRegion()
    window = getWindowBorders(oven[0], oven[1]);
    bottomRightX = window.width + window.x - 15
    bottomRightY = window.height + window.y - 55
    topLeftX = window.x+15
    topLeftY = bottomRightY-35
    width = bottomRightX - topLeftX
    height = bottomRightY - topLeftY
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
	logfile:write(dateTime .. ": Macro started, Saving raeli_0_.png\n");
	logfile:close();
end


function WriteLog()
      fetchGameClock()
      local Text = dateTime .. ": Detected a change. It has been " .. formatLastChange(lastChange) .. " since last change occurred. Saved raeli_" .. changes .. "_.png"
	logfile = io.open("raeli.txt","a+");
	logfile:write(Text .. "\n");
	logfile:close();
end


function fetchGameClock()
  srReadScreen();
  if getTime() then
    dateTime = getTime(1)
  else
    dateTime = "Unknown Date/Time"
  end
end


-- Custom version of sleepWithStatus so that srShowImageDebug image appears without flickering

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

    lsPrintWrapped(10, messageY, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);
    if oven then
      srShowImageDebug("last-raeli", 10, imageY, 1, 0.8);
    end
    statusScreen(message, color, allow_break, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end
