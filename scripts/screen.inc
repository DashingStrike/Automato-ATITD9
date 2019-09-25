function iterateBoxPixels(box, xy_func, y_func)
    srReadScreen()
    for y = 0, box.height, 1 do
        if y_func then y_func(y) end
        for x = 0, box.width do
            local pixel = srReadPixelFromBuffer(box.left + x, box.top + y)
            if xy_func(x, y, pixel) then
                return
            end
        end
        checkBreak()
    end
end

function getBoxPixels(box)
    local pixels = {}
    iterateBoxPixels(box,
        function(x, y, pixel)
            pixels[y][x] = pixel
        end,
        function(y)
            pixels[y] = {}
        end)
    return pixels
end


function getScreenMiddle() local xyWindowSize = srGetWindowSize()
    return Vector:new { math.floor(xyWindowSize[0] / 2), math.floor(xyWindowSize[1] / 2) }
end
