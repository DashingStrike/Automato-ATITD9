-- common_ui.inc
--
-- Commmon utility functions for interacting with the user
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

focusMessage = singleLine([[
  Switch focus back to client window if necessary, then press shift
]]);

cleanupCallback = nil;

-------------------------------------------------------------------------------
-- setCleanupCallback()
--
-- Specify the callback function to call when a macro stops
-------------------------------------------------------------------------------

function setCleanupCallback(callback)
  cleanupCallback = callback;
end


-------------------------------------------------------------------------------
-- checkBreak()
--
-- Stop the macro if the user is pressing both shift and control.
-------------------------------------------------------------------------------

function checkBreak()
  if lsShiftHeld() and lsControlHeld() then
    if(cleanupCallback) then
      lsPrintln("calling cleanup call back");
      pcall(cleanupCallback);
      lsPrintln("cleanup call back returned");
    else
      lsPrintln("cleanupCallback == " .. type(cleanupCallback));
    end
    srKeyUp(-1);
    error(quit_message);
  end
  if allow_pause and lsAltHeld() and lsShiftHeld() then
    -- Pause
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false);
    end
    local done = false;
    while not done do
      local unpaused = lsButtonText(lsScreenX - 110, lsScreenY - 60,
                                    z, 100, 0xFFFFFFff, "Unpause");
      statusScreen("Hold Alt+Shift to resume", 0xFFFFFFff, false);
      done = (unpaused or (lsAltHeld() and lsShiftHeld()));
    end
    while lsAltHeld() or lsShiftHeld() do
      statusScreen("Please release Alt+Shift", 0x808080ff, false);
    end
  end
end

-------------------------------------------------------------------------------
-- askForWindow(message)
--
-- Tell the user to put the target window in focus and wait. Necessary
-- at the beginning of nearly every macro.
--
-- message (optional) -- Additional instructions to print for the user
--
-- Returns the position of the mouse when shift is pressed.
-------------------------------------------------------------------------------

function askForWindow(message)
  if not message then
    message = "";
  end
  local basicText = singleLine([[
      Mouse over the ATITD window and press Shift.  For best results,
      either put the ATITD window in focus first (click the ATITD
      window).
  ]]);

  -- Wait for release if it's already held
  while lsShiftHeld() do
    checkBreak();
  end

  -- Display message until shift is held
  while not lsShiftHeld() do
    lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff, basicText);
    lsPrintWrapped(0, 85, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff, message);
    lsDoFrame();
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
                    0xFFFFFFff, "Exit") then
      error(quit_message);
    end
    lsSleep(tick_delay);
    checkBreak();
  end
  lsSetCaptureWindow();
  local mouseX, mouseY = srMousePos();

  -- Wait for shift to be released
  while lsShiftHeld() do
    checkBreak();
  end
  return makePoint(mouseX, mouseY);
end

function askForFocus()
  if pauseForFocus then
    -- Wait for release if it's already held
    while lsShiftHeld() do
      checkBreak();
    end

    -- Display message until shift is held
    while not lsShiftHeld() do
      lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff, focusMessage);
      lsDoFrame();
      if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
                      0xFFFFFFff, "Exit") then
        error(quit_message);
      end
      lsSleep(tick_delay);
      checkBreak();
    end

    -- Wait for shift to be released
    while lsShiftHeld() do
      checkBreak();
    end
  end
end

-------------------------------------------------------------------------------
-- statusScreen(message, color, allow_break, scale)
--
-- Print status message and a cancel button.
--
-- message (optional) -- status to show user
-- color (optional) -- color of message (defaults to white)
-- allow_break (optional) -- allow the user to break/pause (defaults to true)
-- scale (optional) -- set text scaling
-------------------------------------------------------------------------------
function statusScreenPause(message, color, allow_break, scale)
  statusScreen(message, color, allow_break, scale);
end

function statusScreen(message, color, allow_break, scale)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if allow_break == nil then
    allow_break = true;
  end
  if not scale then
    scale = 0.8;
  end
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, scale, scale, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, scale, scale, 0xffd0d0ff,
                 error_status);
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
                  0xFFFFFFff, "End script") then
    error(quit_message);
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
            "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
              "Hold Alt+Shift to pause this script.");
    end
    checkBreak();
  end
  lsSleep(tick_delay);
  lsDoFrame();
end

-------------------------------------------------------------------------------
-- sleepWithStatus(delay_time, message, can_pause, scale)
--
-- Waits at least delay_time before returning. Show the message and
-- allow the user to cancel the macro while waiting.
--
-- delay_time -- minimum amount of time to wait
-- message (optional) -- status to show user
-- color (optional) -- color of status message
-- scale (optional) -- set text scaling
-- waitMessage (optional) -- set wait message. By default waitMessage = "Waiting "
-------------------------------------------------------------------------------

function sleepWithStatusPause(delay_time, message, color, scale, waitMessage)
  sleepWithStatus(delay_time, message, color, scale, waitMessage);
end

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
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);
    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end

-------------------------------------------------------------------------------
-- sleepWithBreak(delay_time)
--
-- Waits at least delay_time before returning.
-- Allow the user to cancel the macro while waiting.
--
-- delay_time -- minimum amount of time to wait
-------------------------------------------------------------------------------

function sleepWithBreak(delay_time)
  if not delay_time then
    error("Incorrect number of arguments for sleepWithBreak()");
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
        checkBreak();
    lsSleep(tick_delay);
  end
end

-------------------------------------------------------------------------------
-- promptNumber(prompt_string, default_value, scale, post_prompt_string)
--
-- Ask the user for a number and return the result.
--
-- prompt_string -- string telling the user what kind of number to enter
-- default_value (optional) -- initial value to put in field (default 0)
-- scale (optional) -- Scaling factor for display
-- post_prompt_string -- string to display below the text box and OK button
-- post_prompt_string_y -- y position for text to appear (default 80)
-------------------------------------------------------------------------------

function promptNumber(prompt_string, default_value, scale, post_prompt_string, post_prompt_string_y)
  if not prompt_string then
    error("Incorrect number of arguments for promptNumber()");
  end
  if not default_value then
    default_value = 0;
  end
  if not scale then
    scale = 0.8;
  end
  if not post_prompt_string_y then
    post_prompt_string_y = 80;
  end
  local z = 0;
  local is_done = nil;
  local value = nil;
  -- Edit box and text display
  while not is_done do
    checkBreak();

    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, prompt_string);

    -- lsEditBox needs a key to uniquely name this edit box
    --   let's just use the prompt!
    -- lsEditBox returns two different things (a state and a value)
    is_done, value = lsEditBox(prompt_string,
                               10, 40, z, 100, 30, scale, scale,
                               0x000000ff, default_value);

    if lsButtonText(120, 40, z, 100, 0xFFFFFFff, "OK") then
      is_done = 1;
    end

    if post_prompt_string then
      lsPrintWrapped(10, post_prompt_string_y, z, lsScreenX - 20, scale, scale, 0xFFFFFFff, post_prompt_string);
    end

    if is_done and not value then
      error(quit_message);
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
                    0xFFFFFFff, "End script") then
      error(quit_message);
    end

    if not tonumber(value) then
      is_done = nil;
      lsPrint(10, 80, z, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
    end

    lsDoFrame();
    lsSleep(tick_delay);
  end

  return tonumber(value);
end

-------------------------------------------------------------------------------
-- promptOkay(prompt_string, color, scale, yes_no, no_cancel, offsetY)
--
-- Give the user an ok/cancel dialog box.
--
-- prompt_string -- string giving the user a message
-- color (optional) -- color of message (defaults to white)
-- scale (optional) -- set text scaling
-- yes_no (optional) -- changes OK/Cancel text to Yes/No
-- no_cancel (optional) -- supresses Cancel button
-- offsetY (optional) -- move buttons up (negative num) or down (positive num)
-------------------------------------------------------------------------------

function promptOkay(prompt_string, color, scale, yes_no, no_cancel, offsetY)
  if not prompt_string then
    error("Incorrect number of arguments for promptOkay()");
  end
  if not color then
        color = 0xFFFFFFff;
  end
  if not scale then
    scale = 0.8;
  end
  if not offsetY then
    offsetY = 0;
  end
  local z = 0;
  local is_done = nil;
  local ret = nil;
  local ok = "OK"
  local cancel = "Cancel";
  if yes_no then
    ok = "Yes"
    cancel = "No"
  end
  -- Edit box and text display
  while not is_done do
    checkBreak();

    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
            "Hold Ctrl+Shift to end this script.");
    lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
            "Hold Alt+Shift to pause this script.");
    lsPrintWrapped(10, 60, 0, lsScreenX - 20, scale, scale, color, prompt_string);

    if lsButtonText(100, 200+offsetY, z, 100, 0xFFFFFFff, ok) or
      (lsAltHeld() and lsShiftHeld()) then
      is_done = 1;
      ret = 1;
    end

    if not no_cancel then
      if lsButtonText(100, 230+offsetY, z, 100, 0xFFFFFFff, cancel) then
        is_done = 1;
        ret = nil;
      end
    end

    lsDoFrame();
    lsSleep(tick_delay);
  end

  while lsAltHeld() or lsShiftHeld() do
    statusScreen("Please release Alt+Shift", 0x808080ff);
  end

  return ret;
end

-------------------------------------------------------------------------------
-- getElapsedTime(startTime)
--
-- Returns a formatted string containing the elapsed time
--
-- startTime -- The time the macro started as returned by lsGetTimer()
-------------------------------------------------------------------------------

function getElapsedTime(startTime)
        local duration = math.floor((lsGetTimer() - startTime) / 1000);
        local hours = math.floor(duration / 60 / 60);
        local minutes = math.floor((duration - hours * 60 * 60) / 60);
        local seconds = duration - hours * 60 * 60 - minutes * 60;
        return string.format("%02d:%02d:%02d",hours,minutes,seconds);
end

GENERALCAM = 5; -- f5 view
EXPLORERCAM = 6; -- f6 view
BUILDERCAM = 7; -- f7 view
DUELINGCAM = 8; -- f8 view
CARTOGRAPHERCAM = 100; -- f8f8 view
CARTOGRAPHER2CAM = 101; -- zoomed in f8f8 view
-------------------------------------------------------------------------------
-- setCameraView(viewName)
--
-- Sets the camera view
--
-- viewName - Constant representing the name of the view. Defaults to zoomed
-- in cartographer's view.
-------------------------------------------------------------------------------

-- This works by going to an alternate view than the ideal view using the F
-- keys, and then going to the ideal view.
function setCameraView(viewName)
   if viewName == nil then
      error("No camera view specified");
   end
   if viewName == GENERALCAM then
      srFunctionKeyEvent(6);
      srFunctionKeyEvent(5);
      return;
   end
   srFunctionKeyEvent(5);
   if viewName ~= CARTOGRAPHERCAM and viewName ~= CARTOGRAPHER2CAM then
      srFunctionKeyEvent(viewName);
   else
      srFunctionKeyEvent(8);
      srFunctionKeyEvent(8);
      if viewName == CARTOGRAPHER2CAM then
         srFunctionKeyEvent(8);
      end
   end
end

-------------------------------------------------------------------------------
-- ButtonText(x, y, z, w, color, text, xsc, ysc)
--
-- Allow scaling of lsButtonText()
--
-- x -- x coordinates to place button
-- y -- y coordinates to place button
-- z -- z affects if two or more objects are overlapping. The highest z will display instead of overlapping object with lower z.
-- w -- width of button
-- color (optional) -- color of message (defaults to white)
-- text -- string giving the user a message
-- xsc (optional) -- x scaling -- x and y should typically be same
-- ysc (optional) -- y scaling -- x and y should typically be same
-------------------------------------------------------------------------------

function ButtonText(x, y, z, w, color, text, xsc, ysc)
  if not text then
    error("Incorrect number of arguments for ButtonText()");
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if not z then
    z = 0;
  end
  if not xsc then
    xsc = 0.8;
  end
  if not ysc then
    ysc = 0.8;
  end
  lsSetCamera(0,0, lsScreenX/xsc, lsScreenY/ysc);
  if lsButtonText(x/xsc, y/ysc, z, w, color, text) then
    lsSetCamera(0,0, lsScreenX, lsScreenY);
    return true;
  else
    lsSetCamera(0,0, lsScreenX, lsScreenY);
  end
end

-------------------------------------------------------------------------------
-- CheckBox(x, y, z, color, text, value, xsc, ysc)
--
-- Allow scaling of lsCheckBox()
--
-- x -- x coordinates to place button
-- y -- y coordinates to place button
-- z -- z affects if two or more objects are overlapping. The highest z will display instead of overlapping object with lower z.
-- color (optional) -- color of message (defaults to white)
-- text -- string giving the user a message
-- value (optional) -- Current value of the check box (true/false)
-- xsc (optional) -- x scaling -- x and y should typically be same
-- ysc (optional) -- y scaling -- x and y should typically be same
-------------------------------------------------------------------------------

function CheckBox(x, y, z, color, text, value, xsc, ysc)
  if not text then
    error("Incorrect number of arguments for CheckBox()");
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if not z then
    z = 0;
  end
  if not xsc then
    xsc = 0.8;
  end
  if not ysc then
    ysc = 0.8;
  end
  lsSetCamera(0,0, lsScreenX/xsc, lsScreenY/ysc);
  if lsCheckBox(x/xsc, y/ysc, z, color, text, value) then
    lsSetCamera(0,0, lsScreenX, lsScreenY);
    return true;
  else
    lsSetCamera(0,0, lsScreenX, lsScreenY);
  end
end