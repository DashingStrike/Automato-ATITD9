-- Revamped by Cegaiel
-- v1.0.3
-- Credits for the original T8 version/portion, of this macro, goes to it's respective author (I'm not sure who that is). The T8 portion has actually been around a few tales, I believe (at least 2015).


lsRequireVersion(2,50) -- v2.50 adds srSaveImageDebug used in this script. Give error if user tries to use lower version.

dofile("common.inc");
dofile("settings.inc");

allow_break = false; -- Change to true if you want to allow Ctrl+Shift or Alt+Shift (false will Help prevent accidentally exiting macro)
tol = 4500; -- T9: Watch Color Bar and Text Mode

function doit()

  askForWindow("Raeli Color Monitor v1.0.3 by Cegaiel\n\nPin a Raeli Oven window.\n\nMacro will monitor the window for change based on the color / text (inside color bar) on window and take a screenshot when it occurs.\n\nScreenshots appear in C:\\Games\\Automato folder.\n\nWrites a log to raeli.txt (except T8 version), in ATITD9 folder, showing other useful information.");

  settings();
  setFilename();
  if dropdown_cur_value_raeli == 3 then
    T8()
  end
  -- Everything below is ignored/skipped if using T8 Mode
  srReadScreen();
  oven = findText("This is [a-z]+ Raeli Oven", nil, REGEX)
  if not oven then
    error('Could not find a Raeli Oven pinned')
  end
  raeliRegion()
  makeImage()
  lastImage = srFindImageInRange("last-raeli", topLeftX, topLeftY, width, height, tol)
  getPixel()
  lastPixel = px
  startTime = lsGetTimer();
  lastReset = lsGetTimer()
  lsPlaySound("beepping.wav")
  word = "Initial"
  screenshot()
  DeleteLog()

  while 1 do
    if changes > 0 then word = "Last" end
    t = (lsGetTimer() - startTime) / 1000 / 60;
    t = math.floor(t*10 + 0.5)/10;
    findOven()
    showStatusScreen()

    if (lastPixel ~= px and oven and dropdown_cur_value_raeli == 2) or (not lastImage and oven and dropdown_cur_value_raeli == 1) then -- Change has occured
      makeImage()
      getPixel()
      lastPixel = px
      changes = changes + 1
      lsPlaySound("beepping.wav")
      resetTimer()
	screenshot()
    end

  end
end


function showStatusScreen()
    sleepWithStatus(500, extraSpace .. "Pixel: " .. px .. "\nRGBA: " .. rgba .. "\n" .. "HSL: " .. hsl2 .. "\nHSV/B: " .. hsv2 .. "\n\nChanges Occurred: " .. changes .. "\n\nLast Change Elapsed: " .. formatLastChange(lastChange) .. "\nTotal Elapsed Time: " .. getElapsedTime(startTime) .. "  (" .. t .. ")\n\n" .. word .. " Image Saved: " .. screenshot_filename_prefix .. changes .. "_" .. last_t .. screenshot_filename_suffix .. ".png\n\nNote: Moving your raeli window or quickly Alt+Tabbing will NOT break the macro !", nil, 0.7, status)
end


function findOven()
  srReadScreen();
  oven = findText("This is [a-z]+ Raeli Oven", nil, REGEX)
  if oven then
    status = "Monitoring for change"
    raeliRegion()
    lastImage = srFindImageInRange("last-raeli", topLeftX, topLeftY, width, height, tol)
    getPixel()
  else
    status = "Can\'t find Raeli Oven"
  end
end


function makeImage()
  srMakeImage("last-raeli", topLeftX, topLeftY, width, height);  -- The color part of oven window
  srMakeImage("raeli-oven", window.x, window.y, window.width, window.height); -- The entire oven window
end


function screenshot()
  last_t = t;
  srReadScreen(); -- Re-Read screen so that the screenshot doesn't show a white (stripped window) from earlier findText()
  if screenshot_full then
    srSaveLastReadScreen(screenshot_filename_prefix .. changes .. "_" .. last_t .. screenshot_filename_suffix .. ".png");
  else
    srSaveImageDebug("raeli-oven", screenshot_filename_prefix .. changes .. "_" .. last_t .. screenshot_filename_suffix .. ".png");
  end
  WriteLog()
end


function getPixel()
  px = srReadPixel(topLeftX+10, topLeftY);
  rgba = (math.floor(px/256/256/256) % 256) .. ", " .. (math.floor(px/256/256) % 256) .. ", " .. (math.floor(px/256) % 256) .. ", " .. (px % 256);
  hsv = lsRGBAtoHSV(px)
  hsv2hsl(hsv[0], hsv[1], hsv[2])
  hsv2 = round(hsv[0]) .. ", " .. round(hsv[1]*100) .. "%, " .. round(hsv[2]*100) .. "%"
  hsv = roundP(hsv[0]) .. ", " .. roundP(hsv[1]*100) .. ", " .. roundP(hsv[2]*100)
end


function hsv2hsl(h, s, v)
  local l = (2 - s) * v / 2;
  if l ~= 0 then
	if l == 1 then
	  s = 0
	elseif l < 0.5 then
	  s = s * v / (l * 2)
	else
	  s = s * v / (2 - l * 2)
	end
  end
  hsl = roundP(h) .. ", " .. roundP(s*100) .. ", " .. roundP(l*100)
  hsl2 = round(h) .. ", " .. round(s*100) .. "%, " .. round(l*100) .. "%"
  return h, s, l
end


function resetTimer()
  lastChange = lsGetTimer() - lastReset
  lastReset = lsGetTimer()
end


function raeliRegion()
  srReadScreen(); -- Re-Read screen so that the screenshot doesn't show a white (stripped window) from earlier findText()
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

function roundP(num, numDecimalPlaces)
    if numDecimalPlaces == nil then
      numDecimalPlaces = 2
    end
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
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
  logfile:write("0: " ..dateTime .. " @ " .. location .. "\nFile: " .. screenshot_filename_prefix .. changes .. "_" .. last_t .. screenshot_filename_suffix .. ".png\nPixel: " .. px .. "\nRGB: " .. rgba .. "\nHSL: " .. hsl .. "  (" .. hsl2 .. ")\nHSV/B: " .. hsv .. "  (" .. hsv2 .. ")\n\n\n");
  logfile:close();
end


function WriteLog()
  fetchGameClock()
  local Text = changes .. ": " ..dateTime .. " @ " .. location .. "\nFile: " .. screenshot_filename_prefix .. changes .. "_" .. last_t .. screenshot_filename_suffix .. ".png\nPixel: " .. px .. "\nRGB: " .. rgba .. "\nHSL: " .. hsl .. "  (" .. hsl2 .. ")\nHSV/B: " .. hsv .. "  (" .. hsv2 .. ")\n" .. formatLastChange(lastChange) .. " - Elapsed Time Since Last Change\n" .. getElapsedTime(startTime) .. " - Elapsed Time Macro has been Running\n\n"
  logfile = io.open("raeli.txt","a+");
  logfile:write(Text .. "\n");
  logfile:close();
end


function settings()
  changes = 0;
  lastChange = 0
  t = 0
  t = math.floor(t*10 + 0.5)/10;
  last_t = t;
  screenshot_full = true;
  screenshot_window = false;
  local screenshot_full_color = 0xffffffff
  local screenshot_window_color = 0xffffffff
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
  local dropdown_values_raeli = {"T9: Watch Color Bar and Text", "T9: Watch Pixel Changes", "T8: Watch Pixel Changes"};

  while 1 do
    local y = 10;
    local z = 0;
    local scale = 0.7;
    local notes;
    local selection;
    checkBreak()
    lsPrint(12, y, 0, 0.7, 0.7, 0xffffffff, "Monitoring Method:");
    y = y + 35;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_cur_value_raeli = readSetting("dropdown_cur_value_raeli",dropdown_cur_value_raeli);
    dropdown_cur_value_raeli = lsDropdown("thisraeli", 15, y, 0, 320, dropdown_cur_value_raeli, dropdown_values_raeli);
    writeSetting("dropdown_cur_value_raeli",dropdown_cur_value_raeli);
    selection =  "Your Selection / Notes:\n\n"
    if dropdown_cur_value_raeli == 1 then
      notes = selection .. "This option is LESS precise. Idea if you only care about capturing screenshots when the TEXT on the colored background changes (on raeli oven window) and not so much minor RGB changes that occurs between each TEXT change."
    elseif dropdown_cur_value_raeli == 2 then
      notes = selection .. "This option is PRECISE. This monitors pixel RGB changes on the color bar on raeli oven window. The RGB can change very slightly before the TEXT changes on window. This option will detect that !"
    elseif dropdown_cur_value_raeli == 3 then
      notes = selection .. "This option is PRECISE. This monitors pixel RGB changes on the color bar on raeli oven window. The RGB can change very slightly before the TEXT changes on window. This option will detect that !\n\nThis option does NOT save log file and you can\'t save window (Full OK) screenshot."
    else
      notes = "?"
    end
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    y = y + 20;
    lsPrint(12, y, 0, 0.7, 0.7, 0xffffffff, "Screenshot Method:");
    y = y + 25;
    screenshot_full = readSetting("screenshot_full",screenshot_full);
    screenshot_window = readSetting("screenshot_window",screenshot_window);
    screenshot_full = CheckBox(15, y, z, screenshot_full_color, " Full (Entire Screen)", screenshot_full, 0.7, 0.7);
    y = y + 20;
    if screenshot_full or dropdown_cur_value_raeli == 3 then
      screenshot_full_color = 0xffb43fFF
      screenshot_window = false;
    else
      screenshot_full_color = 0xffffffff
    end
    if dropdown_cur_value_raeli ~= 3 then
      screenshot_window = CheckBox(15, y, z, screenshot_window_color, " Window (Raeli Oven Only) - N/A T8", screenshot_window, 0.7, 0.7);
    end
    if screenshot_window then
      screenshot_full = false;
      screenshot_window_color = 0xffb43fFF
    else
      screenshot_full = true;
      screenshot_window_color = 0xffffffff
    end
    writeSetting("screenshot_full",screenshot_full);
    writeSetting("screenshot_window",screenshot_window);
    y = y + 35;
    lsPrintWrapped(12, y, z, lsScreenX - 20, 0.7, 0.7, 0xFFFFFFff,  notes);
    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
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


function setFilename()
  while 1 do
    local y = 10;
    local scale = 0.7;
    local extraNote;
    checkBreak()
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Extra Text on Filename?  (Optional)");
    y = y + 25;
    is_done, screenshot_filename_suffix = lsEditBox("screenshot_filename_suffix", 10, y, z, 260, 25, scale, scale, 0x000000ff);
    y = y + 35;
    if screenshot_filename_suffix ~= "" then
      screenshot_filename_suffix = "_" .. screenshot_filename_suffix
    end
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Filename:");
    lsPrint(80, y-1, z, 0.8, 0.8, 0xffb43fff, screenshot_filename_prefix .. "#_#.#" .. screenshot_filename_suffix .. ".png");
    y = y + 35;
    if dropdown_cur_value_raeli ~= 3 then
      extraNote = "\n\nAlso note logs are saved in raeli.txt which records useful information (Egypt Date/Time, coordinates, Time elapsed since last change, total time running, RGB, HSV/HSL."
    else
      extraNote = ""
    end
    lsPrintWrapped(10, y, z, lsScreenX - 20, scale, scale, 0xFFFFFFff, "Screenshots are saved when a color/text change has occured, using above format.\n\nOptionally, you can add text above to alter the filename in case you are testing different ovens." .. extraNote);
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


-- Custom version of sleepWithStatus so that srShowImageDebug image appears without flickering

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;
local waitFrame2 = 1;
local circleSize = {1, 2, 3, 4, 5, 6, 7, 8};


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

    lsDrawCircle(185, 18, 1, circleSize[frame2], 0.1, px)
    lsDrawCircle(185, 18, 0, 8, 0.95, px)

    if oven then
      srShowImageDebug("last-raeli", 10, imageY, 1, 0.8);
    end
    statusScreen(message, color, allow_break, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
    waitFrame2 = waitFrame2 + 1;
  end
end


--------------- Original T8 raeli_color_mon

function T8()
	askForWindowAndPixel();
	
	local t0 = lsGetTimer();
	local px = 0;
	local index=0;
	while 1 do
		lsSleep(100);
		srReadScreen();
		new_px = srReadPixel(mouse_x, mouse_y);
		local t = (lsGetTimer() - t0) / 1000 / 60;
		t = math.floor(t*10 + 0.5)/10;
		local t_string = t;
		if not (new_px == px) then
			index = index+1;
			srSaveLastReadScreen("raeli_" .. index .. "_" .. t_string .. screenshot_filename_suffix .. ".png");
			px = new_px;
			lsPlaySound("Clank.wav");
		end
		
		lsPrintWrapped(10, 10, 1, lsScreenX, 0.8, 0.8, 0xFFFFFFff,
			"Pixel: " .. new_px .. "\nScreen: " .. index .. "\nTimer: " .. t_string);
		lsPrintWrapped(10, 80, 1, lsScreenX, 0.7, 0.7, px,
			"(" .. (math.floor(px/256/256/256) % 256) .. "," .. (math.floor(px/256/256) % 256) .. "," .. (math.floor(px/256) % 256) .. "," .. (px % 256) .. ")" );
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Canceled";
		end	
		lsDoFrame();
	end
end


function askForWindowAndPixel(message)
	-- Wait for release if it's already held
	while lsShiftHeld() do end;
	-- Display message until shift is held
	while not lsShiftHeld() do
		lsPrintWrapped(5, 10, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff,
			"Mouse over the relevant pixel and press Shift.");
		if message then
			lsPrintWrapped(5, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
				message);
		end
		lsSetCaptureWindow();
		mouse_x, mouse_y = srMousePos();
		px = srReadPixel(mouse_x, mouse_y);
		lsPrintWrapped(10, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
			mouse_x .. ", " .. mouse_y);
		lsPrintWrapped(10, 65, 1, lsScreenX, 0.7, 0.7, px,
			"(" .. (math.floor(px/256/256/256) % 256) .. "," .. (math.floor(px/256/256) % 256) .. "," .. (math.floor(px/256) % 256) .. "," .. (px % 256) .. ")" );
		-- Testing other methods of grabbing the pixel, making sure RGBA values match
		-- srReadScreen();
		-- px2 = srReadPixelFromBuffer(mouse_x, mouse_y);
		-- lsPrintWrapped(0, 80, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
		-- 	mouse_x .. ", " .. mouse_y .. " = " .. (math.floor(px2/256/256/256) % 256) .. "," .. (math.floor(px2/256/256) % 256) .. "," .. (math.floor(px2/256) % 256) .. "," .. (px2 % 256) );
		-- lsButtonText(lsScreenX - 110, lsScreenY - 90, 0, 100, px, "test1");
		-- lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, px2, "test2");
		lsDoFrame();
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Canceled";
		end
	end
	lsSetCaptureWindow();
	-- Wait for shift to be released
	while lsShiftHeld() do end;
	xyWindowSize = srGetWindowSize();
end
