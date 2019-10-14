dofile("common.inc");

function doit()
  askForWindow("Shows currently hovered mouse position and RGB color values. Press shift over ATITD window to continue.");
  while true do
    srReadScreen();
    local pos = getMousePos();
    local pixelsRaw = srReadPixel(pos[0], pos[1]);
    local pixels = pixelDiffs(pos[0], pos[1], 0);
    local status = "Pos: " .. pos[0] .. ", " .. pos[1] .. "\n";

    status = status .. "Color: " .. table.concat(pixels, ", ") .. "\nPixelRaw: " .. pixelsRaw .. "\nDecimal: " .. decimal(pixels[1], pixels[2], pixels[3]);
    lsDrawRect(10, 200, 40, 170, 0,  pixelsRaw);
    statusScreen(status, nil, 0.7);
    lsSleep(10);
  end
end


function decimal(r, g, b)
  dec = b + (g * 256) + (r * 65536)
  return dec;
end
