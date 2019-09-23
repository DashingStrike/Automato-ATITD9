-- common_wait.inc
--
-- Common functions used for waiting on events in the target window.
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

-------------------------------------------------------------------------------
-- getWaitSpot(x, y)
--
-- Initialize position and pixel value for waitForChange() or waitForStasis()
-- x -- Position in pixels on x-axis
-- y -- Position in pixels on y-axis
--
-- returns a 3-tuple of x, y, and the current color at that spot.
-------------------------------------------------------------------------------

function getWaitSpot(x, y)
  if not x or not y then
    error("Incorrect number of arguments for getWaitSpot()");
  end
  return {x, y, srReadPixel(x, y)};
end

-------------------------------------------------------------------------------
-- waitForChange(spot, timeout)
--
-- Wait for pixel at spot to change subject to a timeout.
--
-- spot -- 3-tuple of x, y, and the original color at that location
-- timeout (optional) -- Time in milliseconds to wait before giving up
--
-- returns true on change and false on timeout.
-------------------------------------------------------------------------------

function waitForChange(spot, timeout)
  if not spot then
    error("Incorrect number of arguments for waitForChange()");
  end
  if #spot ~= 3 then
    error 'waitForChange called without a valid spot\n';
  end

  local success = true;
  local timestart = lsGetTimer();
  local pixel = srReadPixel(spot[1], spot[2])
  while pixel == spot[3] do
    lsSleep(tick_delay);
    checkBreak();
    if timeout and (lsGetTimer() > timestart + timeout) then
      success = false;
      break;
    end
    pixel = srReadPixel(spot[1], spot[2]);
  end
  return success;
end

-------------------------------------------------------------------------------
-- waitForStasis(spot, timeout)
--
-- Wait for pixel at spot to stop changing color.
--
-- spot -- 3-tuple of x, y, and the original color at that location
-- timeout -- Time in milliseconds to wait before giving up
--
-- returns true on change and false on timeout.
-------------------------------------------------------------------------------

function waitForStasis(spot, timeout)
  if not spot or not timeout then
    error("Incorrect number of arguments for waitForStasis()");
  end

  if (#spot ~= 3) then
    error 'waitForStasis called without a valid spot\n';
  end

  local lastPixels = {0, 1, 2, 3, 4, 5, 6};
  local index = 1;
  local success = true;
  local timestart = lsGetTimer();
  while not isHomogenous(lastPixels) do
    checkBreak();
    if timeout and (lsGetTimer() > timestart + timeout) then
      success = false;
      break;
    end
    lsSleep(tick_delay);
    pixel = srReadPixel(spot[1], spot[2]);
    lastPixels[index] = pixel;
    index = index + 1;
    if (index > #lastPixels) then
      index = 1;
    end
  end
  return success;
end

function isHomogenous(list)
  local result = true;
  for i=1,#list do
    if list[i] ~= list[1] then
      result = false;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- waitForPixel(anchor, offset, color, tolerance, timeout)
--
-- Waits for a given pixel to change to a particular color.
--
-- anchor -- Base location to check
-- offset -- Offset from base location
-- color -- Color to wait for
-- tolerance -- 0 means exact match, >= 255 means any color (default 0)
-- message -- Message to print while waiting (default none)
-- timeout -- Max time to wait in ms (default forever)
--
-- Returns true if the colors match within tolerance.
-------------------------------------------------------------------------------

function waitForPixel(anchor, offset, color, tolerance, message, timeout)
  if not anchor or not offset or not color then
    error("Incorrect number of arguments for waitForPixel()");
  end
  return waitForPixelList(anchor, offset, {color}, tolerance, timeout);
end

-------------------------------------------------------------------------------
-- waitForPixelList(anchor, offset, colors, tolerance, timeout)
--
-- Waits for a given pixel to change to one from a list of colors.
--
-- anchor -- Base location to check
-- offset -- Offset from base location
-- colors -- Colors to wait for
-- tolerance -- 0 means exact match, >= 255 means any color (default 0)
-- message -- Message to print while waiting (default none)
-- timeout -- Max time to wait in ms (default forever)
--
-- Returns true if the colors match within tolerance.
-------------------------------------------------------------------------------

function waitForPixelList(anchor, offset, colors, tolerance, message, timeout)
  if not anchor or not offset or not colors then
    error("Incorrect number of arguments for waitForPixelList()");
  end
  local success = false;
  local done = false;
  local timestart = lsGetTimer();
  while not done do
    if message then
      statusScreen(message);
    else
      checkBreak();
    end
    lsSleep(tick_time);
    if pixelMatchList(anchor, offset, colors, tolerance) then
      done = true;
      success = true;
      break;
    end
    if timeout and lsGetTimer() > timestart + timeout then
      done = true;
    end
  end
  return success;
end

function iterateImage(args)
  local file = args[1];
  local range = args[2];
  local tol = args[3];
  if not tol then
    tol = 5000;
  end
  srReadScreen();
  return srFindImageInRange(file, range.x, range.y,
          range.width, range.height, tol);
end

function iterateText(args)
  local text = args[1];
  local range = args[2];
  local flags = args[3];
  local sizemod = args[4];
  srReadScreen();
  return findText(text, range, flags, sizemod);
end

------------------------------------------------------------------------------
-- waitForFunction(f, args, timeout, message, invert)
--
-- Given a function handler, waits for that function to complete
--
-- f - function handler to wait for completion of
-- args - array of arguments to the function f
-- timeout - timeout for the function to complete
-- message - message to be displayed on the status screen while waiting
-- inverted - when true, returns true once the text is NOT found, and nil if timeout is exceeded and text is still present
-------------------------------------------------------------------------------

function waitForFunction(f, args, timeout, message, inverted)
  if not f then
    error("Incorrect number of arguments for waitForFunction()");
  end
  local result = nil;
  local done = false;
  local timestart = lsGetTimer();
  while not done do
    if message then
      statusScreen(message);
    else
      checkBreak();
    end
    lsSleep(tick_time);
    result = f(args);
    if (result ~= nil and not inverted) or (result == nil and inverted) or (timeout and lsGetTimer() > timestart + timeout) then
      done = true;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- waitForImage(file, timeout, message, range, tol)
--
-- Wait for a particular image to appear subject to a timeout in ms.
--
-- file -- filename of image to search for
-- timeout (optional) -- maximum time to wait in ms (defaults to forever)
-- message (optional) -- Status message to show while waiting
-- range (optional) -- box to restrict search
-- tol (optional) -- tolerance for comparison
--
-- returns image on success or nil on timeout
-------------------------------------------------------------------------------

function waitForImage(file, timeout, message, range, tol)
  if not file then
    error("Incorrect number of arguments for waitForImage()");
  end
  if not range then
    local size = srGetWindowSize();
    range = makeBox(0, 0, size[0], size[1]);
  end
  return waitForFunction(iterateImage, {file, range, tol}, timeout, message);
end

-------------------------------------------------------------------------------
-- waitForNoImage(file, timeout, message, range, tol)
--
-- Wait for a particular image to disappear subject to a timeout in ms.
--
-- file -- filename of image to search for
-- timeout (optional) -- maximum time to wait in ms (defaults to forever)
-- message (optional) -- Status message to show while waiting
-- range (optional) -- box to restrict search
-- tol (optional) -- tolerance for comparison
--
-- returns nil on success or image on timeout
-------------------------------------------------------------------------------

function waitForNoImage(file, timeout, message, range, tol)
  if not file then
    error("Incorrect number of arguments for waitForNoImage()");
  end
  if not range then
    local size = srGetWindowSize();
    range = makeBox(0, 0, size[0], size[1]);
  end
  return waitForFunction(iterateImage, {file, range, tol}, timeout, message, true);
end

-------------------------------------------------------------------------------
-- waitForText(text, timeout, message, range, flags, sizemod)
--
-- Wait for a particular image to appear subject to a timeout in ms.
--
-- text -- text string to search for
-- timeout (optional) -- maximum time to wait in ms (defaults to forever)
-- message (optional) -- Status message to show while waiting
-- range (optional) -- box to restrict search
-- flags (optional) -- same flags as findText()
-- sizemod (optional) -- same constants as findText()
--
-- returns parse object on success or nil on failure
-------------------------------------------------------------------------------

function waitForText(text, timeout, message, range, flags, sizemod)
  if not text then
    error("Incorrect number of arguments for waitForText()");
  end
  return waitForFunction(iterateText, {text, range, flags, sizemod}, timeout, message);
end

-------------------------------------------------------------------------------
-- waitForNoText(text, timeout, message, range, flags, sizemod)
--
-- Wait for a particular text to disappear subject to a timeout in ms.
--
-- text -- text string to search for
-- timeout (optional) -- maximum time to wait in ms (defaults to forever)
-- message (optional) -- Status message to show while waiting
-- range (optional) -- box to restrict search
-- flags (optional) -- same flags as findText()
-- sizemod (optional) -- same constants as findText()
--
-- returns nil on success or parse object on failure
-------------------------------------------------------------------------------

function waitForNoText(text, timeout, message, range, flags, sizemod)
  if not text then
    error("Incorrect number of arguments for waitForText()");
  end
  return waitForFunction(iterateText, {text, range, flags, sizemod}, timeout, message, true);
end

-------------------------------------------------------------------------------
-- waitForImageInRange(file, x, y, width, height, timeout, message, tol)
--
-- Wait for an image to appear within a box subject to a timeout in ms.
--
-- file -- image file to check against
-- x, y -- upper-left corner of range to search
-- width, height -- size of range to search
-- timeout -- how long to wait for image (ms)
-- message (optional) -- message to print while waiting
-- tol (optional) -- tolerance for comparison
-------------------------------------------------------------------------------

function waitForImageInRange(file, x, y, width, height, timeout, message, tol)
  if not file or not x or not y or not width or not height or not timeout then
    error("Incorrect number of arguments for waitForImageInRange()");
  end
  if not tol then
    tol = 5000;
  end
  local done = false;
  local image = nil;
  local timestart = lsGetTimer();
  while not done do
    if message then
      statusScreen(message);
    else
      checkBreak();
    end
    lsSleep(tick_time);
    srReadScreen();
    image = srFindImageInRange(file, x, y, width, height, tol);
    done = (image ~= nil) ;
    if lsGetTimer() > timestart + timeout then
      done = true;
    end
  end
  return image;
end

-------------------------------------------------------------------------------
-- waitForImageInWindow(file, x, y, timeout, bounds)
--
-- Wait for an image to appear within the given atitd window.
--
-- file -- image file to check against
-- x, y -- coordinates inside the window
-- timeout (optional) -- how long to wait for image to appear, default: forever
-- bounds (optional) -- preset bounds to use instead of recalculating
-------------------------------------------------------------------------------

function waitForImageInWindow(file, x, y, timeout, bounds)
  if not file or not x or not y then
    error("Incorrect number of arguments for waitForImageInWindow");
  end
  if not bounds then
    bounds = srGetWindowBorders(x, y);
  end
  return waitForImageInRange(file, bounds[0], bounds[1],
           bounds[2] - bounds[0], bounds[3] - bounds[1],
           timeout);
end

-------------------------------------------------------------------------------
-- waitForImageWhileUpdating(file, x, y, delay)
--
-- Wait for an image to appear while periodically clicking to update
-- window. Waits forever if necessary.
--
-- file -- image file to check against
-- x, y -- position to click periodically while waiting
-- delay -- time to wait between clicks
-------------------------------------------------------------------------------

function waitForImageWhileUpdating(file, x, y, delay)
  if not file or not x or not y or not delay then
    error("Incorrect number of arguments for waitForImageWhileUpdating()");
  end
  local pos = nil;
  while pos == nil do
    safeClick(x, y);
    pos = waitForImage(file, delay);
  end
  return pos;
end

-------------------------------------------------------------------------------
-- waitForTextInRegion(region, text, delay, timeout, isExact)
--
-- continually scrapes the screen and parses until it sees the desired text in
-- the specified region
-- region we're searching within
-- text - text we're looking for
-- delay (optional) - how long the loop sleeps between each screen scrapes.
-- timeout (optional) - how long we'll search for the text before we quit anyway
-- isExact (optional) - true if we want to return true only if the line contains
-- the exact text specified
--
-- returns the parse object if the text is located, returns nil when the timeout
-- is exceeded and the text still isn't found.
-------------------------------------------------------------------------------

function waitForTextInRegion(region, text, delay, timeout, isExact)
  local r;
  if delay == nil then
    delay = 20;
  end
  if timeout ~= nil then
    t0 = lsGetTimer();
    while r == nil and lsGetTimer() - t0 < timeout do
      srReadScreen();
      r = findTextInRegion(region, text, isExact);
      lsSleep(delay);
      checkBreak();
    end
  else
    while r == nil do
      srReadScreen();
      r = findTextInRegion(region, text, isExact);
      lsSleep(delay);
      checkBreak();
    end
  end
  return r;
end

-------------------------------------------------------------------------------
-- waitForKeypress(ctrl, alt, shift, timeout)
--
-- Waits until timeout or until the specified key(s) are down
-- ctrl - if true will wait until the ctrl key is down
-- alt - if true will wait until the alt key is down
-- shift - if true will wait until the shift key is down
-- timeout (optional) - how long we'll wait in ms before we quit anyway
--
-- returns true if the specified keys are down, returns false if the
-- timeout is exceeded.
-------------------------------------------------------------------------------

function waitForKeypress(ctrl, alt, shift, timeout)
  if((not ctrl) and (not alt) and (not shift)) then
    return false;
  end
  if(timeout == nil) then
    timeout = 0;
  end
  local start = lsGetTimer();
  local done = false;
  while(not done) do
    checkBreak();
    if(timeout > 0 and lsGetTimer() - timeout >= start) then
      return nil;
    end
    done = true;
    if(ctrl and not lsControlHeld()) then
      done = false;
    end
    if(alt and not lsAltHeld()) then
      done = false;
    end
    if(shift and not lsShiftHeld()) then
      done = false;
    end
  end
  return true;
end

-------------------------------------------------------------------------------
-- waitForKeyrelease(timeout)
--
-- Waits until timeout or until the shift, ctrl, and alt keys are up
-- timeout (optional) - how long we'll wait in ms before we quit anyway
--
-- returns true if the specified keys are up, returns false if the
-- timeout is exceeded.
-------------------------------------------------------------------------------

function waitForKeyrelease(timeout)
  if(timeout == nil) then
    timeout = 0;
  end
  local start = lsGetTimer();
  while(lsControlHeld() or lsAltHeld() or lsShiftHeld()) do
    checkBreak();
    if(timeout > 0 and lsGetTimer() - timeout >= start) then
      return nil;
    end
  end
  return true;
end
