-- Console will output last character in each line (when training). 
-- Also check https://www.atitd.org/wiki/tale6/User:Skyfeather/VT_OCR for more info on OCR

dofile("common.inc");
dofile("settings.inc");

offsetX = 102;
offsetY = 72;

function doit()
  askForWindow("Choose window.\n\nUse the results of this on a large blank background " ..
    "region in order to inform srSetWindowBackgroundColorRange() or srSetWindowInvertColorRange()");
  
  while not lsControlHeld() do
    sleepWithStatus(16, "Move mouse to upper-left corner of background area, then press Ctrl.");
  end
  while lsControlHeld() do
    sleepWithStatus(16, "Release Ctrl.");
  end
  local left, top = srMousePos();
  while not lsControlHeld() do
    sleepWithStatus(16, "Upper-left = " .. left .. "," .. top .. "\n" ..
      "Move mouse to lower-right corner of background area, then press Ctrl.");
  end
  while lsControlHeld() do
    sleepWithStatus(16, "Release Ctrl.");
  end
  local right, bottom = srMousePos();
  sleepWithStatus(16, "Upper-left = " .. left .. "," .. top .. "\n" ..
      "Lower-right = " .. right .. "," .. bottom .. "\n" ..
      "Processing...");

  srReadScreen();
  local colors = {};
  for x=left,right do
    for y=top,bottom do
      local c = (srReadPixelFromBuffer(x, y) & 0xFFFFFF00) >> 8;
      if c == 0 then
        error("Region contained black, likely some text present, try a different region")
      end
      colors[c] = (colors[c] or 0) + 1;
    end
  end

  while true do
    checkBreak();
    
    local y0 = 60;
    local x = 10;
    local y = y0;
    local scale = 0.5;
    local maxr = 0;
    local minr = 255;
    local maxg = 0;
    local ming = 255;
    local maxb = 0;
    local minb = 255;
    
    for c, count in pairs(colors) do
      local r = (c & 0xFF0000) >> 16;
      local g = (c & 0xFF00) >> 8;
      local b = (c & 0xFF);
      maxr = math.max(maxr, r);
      maxg = math.max(maxg, g);
      maxb = math.max(maxb, b);
      minr = math.min(minr, r);
      ming = math.min(ming, g);
      minb = math.min(minb, b);
      
      lsPrint(x, y, 10, scale, scale, 0xFFFFFFff, string.format("%06X", c) .. " (" .. count .. ")")
      lsDrawRect(x - 20 * scale, y, x, y + 18 * scale, 0, c << 8 | 0xFF);
      y = y + 20 * scale;
      if y > lsScreenY - 30 then
        y = y0;
        x = x + 100;
      end
    end
    
    lsPrint(10, 10, 1, 1, 1, 0xFFFFFFff, "MinColor = " .. string.format("%06X", minr << 16 | ming << 8 | minb));
    lsPrint(10, 30, 1, 1, 1, 0xFFFFFFff, "MaxColor = " .. string.format("%06X", maxr << 16 | maxg << 8 | maxb));

    lsDoFrame();
    lsSleep(50);
  end
  
end

