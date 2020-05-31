--                 cj   ca  cl   dt   ts   el   rs   le   si   ir   co   su  po li sp
paint_colourR = { 128, 224, 128, 112, 48,  128, 144, 80,  16,  96,  64  };
paint_colourG = { 64,  112, 96,  64,  96,  240, 16,  80,  16,  48, 192  };
paint_colourB = { 144, 32,  32,  64,  48,  224, 24,  96,  32,  32, 192  };
catalyst1 = 12;

button_names = {
"Cabbage Juice","Carrot","Clay","Dead Tongue","Toad Skin","Falcon Bait","Red Sand",
"Lead","Silver","Iron","Copper","Sulfur","Potash","Lime","Saltpeter"};

mushrooms = {"Dead Tongue", "Toad Skin", "Falcon Bait"};
catalysts = {"Lime", "Potash", "Sulfur", "Saltpeter"};

per_paint_delay_time = 1000;
per_read_delay_time = 600;
per_click_delay = 10;

-- bar_width: This should be 307. If we get Red/Green Cloth added to menu, around Xmas time (like on T8), this will likely need to be set to 328.
-- When they added Red/Green Cloth, this caused the window to be wider, hence increasing width of bars.
bar_width = 307;

function find_button_index(ingred_name)
    for i, v in pairs(button_names) do
        if v == ingred_name then
            return i
        end
    end
end


function click_ingredient(ingredient_name)
    srReadScreen();
      while lsMouseIsDown() do
        sleepWithStatus(16, "Release Mouse to continue ...", nil, 0.7, "Preparing to Click");
      end
    paint_count = 0;
    paint_values = {0, 0, 0};

    srReadScreen();
    local pigmentLab = findAllText("Pigment Laboratory");

    for i=1,#pigmentLab do

        local x = pigmentLab[i][0];
        local y = pigmentLab[i][1];
        local width = 320;
        local height = 540;

        srReadScreen();  
        local paint_buttons = findAllImagesInRange("plus.png", x, y, width, height);

            if (#paint_buttons == 0) then
                error "No buttons found";
            end
    
        button_index = find_button_index(ingredient_name)
        srClickMouse(paint_buttons[button_index][0]+2,paint_buttons[button_index][1]+2, right_click);
        lsSleep(per_click_delay);
        if(button_index < catalyst1) then
            paint_values[1] = paint_colourR[button_index];
            paint_values[2] = paint_colourG[button_index];
            paint_values[3] = paint_colourB[button_index];
            paint_count = paint_count + 1.0;
        end
    end
    return paint_values, paint_count
end

function get_colour_diffs(bar_colour, paint_count, paint_sum)
    local expected_colour = {0,0,0};
    local diff_colour = {0,0,0};

    -- calculate the expected colour and the difference between what was expected and what was on the bar
    for i=1, 3 do
        expected_colour[i] = paint_sum[i] / paint_count;
        diff_colour[i] = math.floor(0.5+bar_colour[i]) - math.floor(0.5+expected_colour[i]);
    end
    return expected_colour, diff_colour
end

function get_bar_colour()
    local bar_colour = {0,0,0};
    bar_colour[1] = #findAllImages("paint_watch/paint-redbarC.png");
    lsSleep(per_read_delay_time/3);
    bar_colour[2] = #findAllImages("paint_watch/paint-greenbarC.png");
    lsSleep(per_read_delay_time/3);
    bar_colour[3] = #findAllImages("paint_watch/paint-bluebarC.png");

    -- tweak/hack because we miss the first pixel
    for i=1, 3 do
        if(bar_colour[i]>0)then
            bar_colour[i]=bar_colour[i]+1;
            bar_colour[i]=bar_colour[i]*256.0/bar_width;
        end
    end

    lsSleep(per_read_delay_time/3);
    return bar_colour
end

function findBigColorBar()
    local colour_panel = findAllImages("paint_watch/paint-black.png");
    if (#colour_panel == 0) then
        m_x, m_y = srMousePos();
    else
        foundBigColorBar = 1;
    end
end

function reset(already_added)
      while lsMouseIsDown() do
        sleepWithStatus(16, "Release Mouse to continue ...", nil, 0.7, "Preparing to Click");
      end
    print("Finishing paint with Red Sand");
    for i= 1, 10 - already_added + 1 do
        -- finish the paint recipe with red sand
        click_ingredient("Red Sand");
    end
    srReadScreen();
    lsSleep(100);
    clickAllText("Take the Paint");
    lsSleep(100);
end

-- the map causes problems with paint scripts because the zoom buttons are the same as the paint add buttons
-- this causes off-by-one errors if the map is open when making paint, so we close it before any paint scripts start

-- May 31st 2020: Fixed this issue by adding a boundary for where to scan, this function is now redundant - Rhaom
function close_map()
    srReadScreen();
    map_close = findAllImages("map_close.png");

    if map_close then
        for i=1, #map_close do
            -- click near each 'x' in turn to see if that brings the map into focus
            srClickMouseNoMove(map_close[i][0]-10,map_close[i][1]);
            lsSleep(200);
            srReadScreen();
            map_text = findText("Map of Egypt");
            if map_text then
                print("Map found, closing");
                srClickMouseNoMove(map_close[i][0]+5,map_close[i][1]+5);
                break;
            end
        end
    end
end
