dofile("common.inc");

windowIndex = 1;

function doit()
  lsRequireVersion(2, 39);
  askForWindow("Test to display regions such as Clock Window, Friends window and building windows. Press Shift over ATITD window.");
  while true do
    checkBreak();
    findStuff();

    checkBreak();
    lsDoFrame();
    lsSleep(25);
  end
end

function findAllTextRegions()
  local regions = {};
  local pos = srFindFirstTextRegion();
  if not pos then
    return nil;
  end
  while 1 do
    regions[#regions+1] = pos;
    pos = srFindNextTextRegion(pos[0] + 1, pos[1]);
    if not pos then
      break;
    end
  end
  return regions;
end

function showDebugInRange(name, screenx, screeny, imgw, imgh, x, y, z, w, h)
  srMakeImage(name, screenx, screeny, imgw, imgh);
  local scale = 1;
  local border = 1;
  for stest=2,10 do
    if imgw * stest <= w and imgh * stest <= h then
      scale = stest;
      border = scale;
    end
  end
  srShowImageDebug(name, x, y, z, scale);
  lsDrawRect(x - border, y - border, x + imgw * scale + border, y + imgh * scale + border, 1, 0xFF0000ff);
end

function findStuff()
  srReadScreen();
  
  -- Test srFindFirstTextRegion/srFindNextTextRegion
  --srSetWindowBorderColorRange(0x6a4529, 0x6d472a); ---- Now defined globally at top of common_find.inc
  local regions = findAllTextRegions();
  if not (regions and #regions > 0) then
    srSetWindowBorderColorRange(0, 0); -- ATITD T8 colors
    regions = findAllTextRegions();
  end
  if regions and windowIndex > #regions then
    windowIndex = 1;
  end
  if regions and #regions > 0 then
    local current = regions[windowIndex];
    srStripRegion(current[0], current[1], current[2], current[3]);
    showDebugInRange("current-region",
      current[0], current[1], current[2], current[3],
      5, 5, 2, lsScreenX - 10, lsScreenY / 2 - 10);
    if lsButtonText(lsScreenX - 110, 0, 10, 100,
        0xFFFFFFff, "Region " .. windowIndex .. "/" .. #regions ) then
      windowIndex = windowIndex + 1;
    end
  else 
    lsPrint(0, 0, 10, 1, 1, 0xFF8080ff, "No text regions found")
  end
  
  local scale = 0.75;
  local pos = getMousePos();
  local y = lsScreenY / 2;
  lsPrint(10, y, 10, scale, scale, 0xFFFFFFff, "Current Mouse Position: " .. pos[0] .. ", " .. pos[1]);
  y = y + 20;

  -- Test findChatRegion()
  local creg = findChatRegionReplacement(); -- srFindChatRegion();
  if creg then
  lsPrint(10, y, 10, scale, scale, 0xFFFFFFff, "ChatRegion = " .. creg[0] .. "," .. creg[1] ..
    " - " .. creg[2] .. "," .. creg[3]);
  else
  lsPrint(10, y, 10, scale, scale, 0xFFFFFFff, "ChatRegion = NOT FOUND");
  end
  y = y + 20;

  -- Test srFindInvRegion()
  local invreg = srFindInvRegion();
  lsPrint(10, y, 10, scale, scale, 0xFFFFFFff, "srFindInvRegion = " .. invreg[0] .. "," .. invreg[1] ..
    " - " .. invreg[2] .. "," .. invreg[3]);
  y = y + 20;
  
  -- Test srGetWindowBorders
  local borders = srGetWindowBorders(pos[0], pos[1], 3);
  local xyWindowSize = srGetWindowSize();
  local color = 0xFFFFFFff;
  local found = true;
  if borders[0] == 0 or borders[1] == 0 or borders[2] == xyWindowSize[0] - 1 or borders[3] == xyWindowSize[1] - 1 then
    color = 0xFF8080ff;
    found = false;
  end

  lsPrint(10, y, 10, scale, scale, color, "srGetWindowBorders = " .. borders[0] .. "," .. borders[1] ..
    " - " .. borders[2] .. "," .. borders[3]);
  y = y + 12;
  
  if not found then
    y = y + lsPrintWrapped(20, y, 10, lsScreenX - 20, 0.75, 0.75, color, "No valid window border found under cursor");
  else
    showDebugInRange("current-window",
      borders[0], borders[1], borders[2] - borders[0] + 1, borders[3] - borders[1] + 1,
      5, y, 2, lsScreenX - 10, lsScreenY - (y + 20) - 2);
    y = y + 20;
  end
  
  
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, 20, 100,
      0xFFFFFFff, "End Script") then
    error(quitMessage);
  end


--test = findText("Take");

--if test then
--lsPrintln("found");
--else
--lsPrintln("NOT found");
--end


end