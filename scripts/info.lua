dofile("common.inc");

function doit()
  askForWindow("Shows currently hovered mouse position and RGB color values. Press shift over ATITD window to continue.");
  while true do
    srReadScreen();
    local pos = getMousePos();
    local pixelsRaw = srReadPixel(pos[0], pos[1]);
    local pixels = pixelDiffs(pos[0], pos[1], 0);
    local status = "Pos: " .. pos[0] .. ", " .. pos[1] .. "\n";

    status = status .. "RGB: " .. table.concat(pixels, ", ") .. "\nPixelRaw: " .. pixelsRaw .. "\n\n";
    extraInfo = "Tap Ctrl to Save Values to ATITD9/info_logs.txt"
    lsDrawRect(10, 260, 80, 200, 0,  pixelsRaw);
    statusScreen(status .. extraInfo, nil, nil, 0.7);

    if lsControlHeld() then
      WriteLog("Pos: " .. pos[0] .. ", " .. pos[1] .. "\nRGB: " .. table.concat(pixels, ", ") .. "\nPixelRaw: " .. pixelsRaw .. "\n\n");
    end
    while lsControlHeld() do
	extraInfo = "Saved to Log File\nRelease Ctrl Key";

      statusScreen(status .. extraInfo, nil, nil, 0.7);
      lsSleep(10);
    end
  end
  lsSleep(10);
end


--This returns the unsigned decimal, shouldn't be used. Use pixelRaw value instead
function decimal(r, g, b)
  dec = b + (g * 256) + (r * 65536)
  return dec;
end


function WriteLog(Text)
	FileGlass = io.open("info_logs.txt","a+");
	FileGlass:write(Text);
	FileGlass:close();
end

