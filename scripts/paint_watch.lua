--
-- 
--
--Cabbage        | 128, 64, 144   | 8      | Y | bulk    | 10
--Carrot         | 224, 112, 32   | 10     | Y | bulk    | 10
--Clay           | 128, 96, 32    | 4      | Y | bulk    | 20
--DeadTongue     | 112, 64, 64    | 500    | N | normal  | 4
--ToadSkin       | 48, 96, 48     | 500    | N | normal  | 4
--FalconBait     | 128, 240, 224  | 10000  | N | normal  | 4
--RedSand        | 144, 16, 24    | 10     | Y | bulk    | 20
--Lead           | 80, 80, 96     | 50     | Y | normal  | 6
--Silver         | 16, 16, 32     | 50     | N | normal  | 6
--Iron           | 96, 48, 32     | 30     | Y | normal  | 8
--Copper         | 64, 192, 192   | 30     | Y | normal  | 8

--Sulfur         | catalyst       | 10     | Y | normal  | 1
--Potash         | catalyst       | 50     | Y | normal  | 1
--Lime           | catalyst       | 20     | Y | normal  | 1
--Saltpeter      | catalyst       | 10     | Y | normal  | 1

dofile("paint_common.inc");
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("common.inc");

added = {};

function doit()

    local paint_sum = {0,0,0};
    local paint_count = 0;
    local bar_colour = {0,0,0};
    local expected_colour = {0,0,0};
    local diff_colour = {0,0,0};
    local new_px = 0xffffffFF;
    local px_R = nil;
    local px_G = nil;
    local px_B = nil;
    local px_A = nil;
    m_x = 0; -- Do not set as local
    m_y = 0; -- Do not set as local
    local update_now = 1;
    local y = 0;
    local button_push = 0;

    askForWindow("Pin your Pigment Laboratory window, anywhere (but don\'t move it once you start macro).\n\nNote: You will want to keep a supply of Red Sand for the Reset button (100 to test all reactions should be fine).\n\nClicking the 'Reset' button will set your Pigment Lab 'back to Black' color, again, but it requires Red Sand to do so. It\'s Magic!\n\nIf you have an Upgraded Pigment Laboratory, be sure to set Batch = 1x so you use LEAST amount of resources while testing reactions!");

    srReadScreen();
    findBigColorBar();

    local paint_buttons = findAllImages("plus.png");
    if (#paint_buttons == 0) then
        error "No buttons found";
    end


    while 1 do
        lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);
        -- Where to start putting buttons/text on the screen.
        y = 10;
        
        if lsButtonText(lsScreenX - 10, 50, 0, 100, 0xff6251ff, "Reset") then
            reset(paint_count);
            paint_sum = {0,0,0};
            paint_count = 0;
            bar_colour = {0,0,0};
            expected_colour = {0,0,0};
            diff_colour = {0,0,0};
            new_px = 0xffffffFF;
            px_R = nil;
            px_G = nil;
            px_B = nil;
            px_A = nil;
            update_now = 0;
            added = {}; -- Erase the array
        end

        -- Create each button and set the button push.
        for i=1, #button_names do
            if lsButtonText(10, y, 0, 250, 0xFFFFFFff, button_names[i]) then
                image_name = button_names[i];
                update_now = 1;
                button_push = i;
            end
            y = y + 30;
        end

        srReadScreen();

        if not foundBigColorBar then
            findBigColorBar();
        end

        -- read the bar pixels
        new_px = srReadPixel(m_x, m_y);
        px_R = (math.floor(new_px/256/256/256) % 256);
        px_G = (math.floor(new_px/256/256) % 256);
        px_B = (math.floor(new_px/256) % 256);
        px_A = (new_px % 256);

        if not(update_now==0) then
        --{
            if not (button_push==0) then
            --{
                -- click the appropriate button to add paint.
                paint_value, paint_count = click_ingredient(button_names[button_push]);
            
                if(button_push < catalyst1) then
                    -- add the paint estimate 
                    paint_sum[1] =     paint_sum[1] + paint_value[1];
                    paint_sum[2] =     paint_sum[2] + paint_value[2];
                    paint_sum[3] =     paint_sum[3] + paint_value[3];
                    paint_count = paint_count + 1.0;
                end

                table.insert(added, button_names[button_push]);

            --}
            end

            -- count up all the pixels.
            lsSleep(per_paint_delay_time);
            srReadScreen();
            bar_colour = get_bar_colour();

            update_now = 0;

            -- New colour has been added, mix in the pot, and see if there's a difference from the expected value.
            if paint_count > 0 and button_push > 0 then
            --{                
                expected_colour, diff_colour = get_colour_diffs(bar_colour, paint_count, paint_sum)

                button_push = 0;
            --}
            end
        --}
        end


        if foundBigColorBar then
          barReadRGB = px_R .. ", " .. px_G .. ", " .. px_B .. ", " .. px_A
          pixelRGBA = math.floor(bar_colour[1]+0.5) .. ", " .. math.floor(bar_colour[2]+0.5) .. ", " .. math.floor(bar_colour[3]+0.5)
        else
          pixelRGBA = "Will Display on Next Reset ..."
        end

        -- Display all the goodies
        y = y + 5;
        lsPrintWrapped(0, y, 1, lsScreenX * 1.5 - 20, 1, 1, 0xFFFFFFff,
            " Pixel RGBA: " .. pixelRGBA);
        y = y + 26;
        lsPrintWrapped(0, y, 1, lsScreenX * 1.5 - 20, 1, 1, 0xFFFFFFff,
            " Bar Read RGB: " .. math.floor(bar_colour[1]+0.5) .. ", " .. math.floor(bar_colour[2]+0.5) .. ", " .. math.floor(bar_colour[3]+0.5));
        y = y + 26;
        lsPrintWrapped(0, y, 1, lsScreenX * 1.5 - 20, 1, 1, 0xFFFFFFff,
            " Expected RGB: " .. math.floor(expected_colour[1]+0.5) .. ", " .. math.floor(expected_colour[2]+0.5) .. ", " .. math.floor(expected_colour[3]+0.5) );
        y = y + 26;
        lsPrintWrapped(0, y, 1, lsScreenX * 1.5 - 20, 1, 1, 0xFFFFFFff,
            " Reactions RGB: " .. math.floor(diff_colour[1]+0.5) .. ", " .. math.floor(diff_colour[2]+0.5) .. ", " .. math.floor(diff_colour[3]+0.5) );
        y = y + 26;


        if not foundBigColorBar then
          addedDisplay = "Leftover Ingredients? Reset, please!"
        elseif #added == 0 then
          addedDisplay = "Nothing"
        else
          addedDisplay = ""
        end


        for i = 1, #added, 1 do
          addedDisplay =  addedDisplay .. added[i]
            if i < #added then
              addedDisplay = addedDisplay .. "  +  "
            end
        end

        lsPrintWrapped(0, y, 1, lsScreenX * 1.5 - 20, 1, 1, 0xFFFFFFff, " Added: " .. addedDisplay);

        if lsButtonText(lsScreenX - 10, 120, 0, 100, 0xFFFFFFff, "Exit") then
            error "I quit!";
        end

        lsDoFrame();
        lsSleep(10);
    end
end
