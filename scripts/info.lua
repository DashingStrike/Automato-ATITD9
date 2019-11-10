dofile("common.inc");

function doit()
  askForWindow("Shows currently hovered mouse position and RGB color values. Press shift over ATITD window to continue.");
  while true do
    srReadScreen();
    local pos = getMousePos();
    local pixelsRaw = srReadPixel(pos[0], pos[1]);
    local pixels = pixelDiffs(pos[0], pos[1], 0);
    local status = "Pos: " .. pos[0] .. ", " .. pos[1] .. "\n";

    status = status .. "RGB: " .. table.concat(pixels, ", ") .. "\nHEX: 0x" .. decToHex(pixels[1]) .. decToHex(pixels[2]) .. decToHex(pixels[3]) .. "FF\nPixelRaw: " .. pixelsRaw .. "\n\n";
    extraInfo = "Tap Ctrl to Save Values to ATITD9/info_logs.txt"
    lsDrawRect(10, 260, 80, 200, 0,  pixelsRaw);
    statusScreen(status .. extraInfo, nil, nil, 0.7);

    if lsControlHeld() then
      WriteLog(status);
    end
    while lsControlHeld() do
	extraInfo = "Saved to Log File\nRelease Ctrl Key";
      statusScreen(status .. extraInfo, nil, nil, 0.7);
      lsSleep(10);
    end
  end
  lsSleep(10);
end


function WriteLog(Text)
	FileGlass = io.open("info_logs.txt","a+");
	FileGlass:write(Text);
	FileGlass:close();
end


function decToHex(IN)
	local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
	while IN>0 do
    	I=I+1
    	IN,D=math.floor(IN/B),math.fmod(IN,B)+1
    	OUT=string.sub(K,D,D)..OUT
	end
	return OUT
end
