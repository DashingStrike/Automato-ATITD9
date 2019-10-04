dofile("common.inc");

xOffset = 0;
yOffset = 0;
pointingSpeed = 2000; --ms

function doit()
  lsRequireVersion(2,40);

  while true do
    local scale = 1;
    local done;
    local text;
    local y = 10;
    done, text = lsEditBox("ocr_data", 10, y, 10, lsScreenX - 20, 0, scale, scale, 0x000000ff);
    y = y + 30;
    
    local toks = csplit(text, ",");
    -- 5,8,64,768,64,8,48,440,128,432,48,v
    local w = tonumber(toks[1]);
    if w and w > 0 then
      -- lsPrint(x, y, 10, scale, scale, 0xFF0000ff, "w=" .. w .. " len=" .. #toks);
      local x = 10;
      local pix = 10;
      for i=1,w do
        local hard = tonumber(toks[1 + i]);
        local soft = tonumber(toks[1 + i + w]);
        if not soft or not hard then
          break;
        end
        local j = 0;
        while hard + soft > 0 and j < 30 do 
          if hard & 1 > 0 then
            lsDrawRect(x + (i - 1) * pix, y + j * pix, x + i * pix, y + (j + 1) * pix, 1, 0xFFFFFFff);
          elseif soft & 1 > 0 then
            lsDrawRect(x + (i - 1) * pix, y + j * pix, x + i * pix, y + (j + 1) * pix, 1, 0x888888ff);
          else
            lsDrawRect(x + (i - 1) * pix, y + j * pix, x + i * pix, y + (j + 1) * pix, 1, 0xFF0000ff);
          end
          j = j + 1;
          hard = hard >> 1;
          soft = soft >> 1;
        end
      end
    else
      lsPrint(x, y, 10, scale, scale, 0xFF0000ff, "Error parsing line");
    end
  
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 20, 100, 0xFFFFFFff, "End Script") then
      error(quitMessage);
    end
  
    checkBreak();
    lsDoFrame();
    lsSleep(16);
  end
end
