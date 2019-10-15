--                 cj   ca  cl   dt   ts   el   rs   le   si   ir   co   su  po li sp
paint_colourR = { 128, 224, 128, 112, 48,  128, 144, 80,  16,  96,  64  };
paint_colourG = { 64,  112, 96,  64,  96,  240, 16,  80,  16,  48, 192  };
paint_colourB = { 144, 32,  32,  64,  48,  224, 24,  96,  32,  32, 192  };
catalyst1 = 12;

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("common.inc");

button_names = {
"CabbageJ","Carrot","Clay","DeadTongue","ToadSkin","FalconBait","RedSand",
"Lead","SilverP","Iron","Copper","C:Sulfur","C:Potash","C:Lime","C:Saltpeter"}; 

cabbage_reactions = {"Carrot", "RedSand", "Lead", "Iron", "Sulfur", "Potash", "Lime"}
carrot_reations = {"ToadSkin", "Iron", "Copper", "Potash"}
clay_reactions = {"ToadSkin", "FalconBait", "RedSand", "Copper", "Lime", "Saltpeter"}
dt_reactions = {"FalconBait", "RedSand", "Iron", "Sulfur", "Lime"}
ts_reactions = {"FalconBait", "RedSand", "Lead", "Lime", "Saltpeter"}
fb_reactions = {"RedSand", "Lead", "SilverP", "Copper", "Saltpeter"}
redsand_reactions = {"Lead", "Copper", "Sulfur", "Potash", "Lime", "Saltpeter"}
lead_reactions = {"SilverP", "Iron", "Copper", "Sulfur", "Potash"}
silver_reactions = {"Iron", "Copper", "Sulfur", "Saltpeter"}
iron_reactions = {"Lime"}
copper_reactions = {"Sulfur"}
sulfur_reactions = {"Potash"}
lime_reactions = {"Saltpeter"}

per_paint_delay_time = 1000;
per_read_delay_time = 600;
per_click_delay = 10;

-- bar_width: This is how many pixels wide the Red, Green, Blue bars are in Pigment lab.
-- This used to be 307 until around Dec 2018.
-- We think the addition of Red/Green cloth to menus or Falcon Bait caused the window to be wider and causing the pixels to stretch

bar_width = 304; 

function find_button_index(ingred_name)
    for i, v in button_names do
        if v == ingred_name then
            return i
        end
    end
end

function get_reactions(ingred1, ingred2)
    local paint_buttons = findAllImages("plus.png");
    if (#paint_buttons == 0) then
        error "No buttons found";
    end
    
    local colour_panel = findAllImages("paint_watch/paint-black.png");
    if (#colour_panel == 0) then
        -- reset the paint here
    else
        m_x = colour_panel[1][0];
        m_y = colour_panel[1][1]+5;    
    end
    
    lsPrintln("Testing " .. ingred1 .. " and " .. ingred2);
    button_index = find_button_index(ingred1);
	  lsPrintln(button_index);
    srClickMouse(paint_buttons[button_index][0]+2,paint_buttons[button_index][1]+2, right_click);
    lsSleep(per_click_delay);
    -- read the bar pixels
    new_px = srReadPixel(m_x, m_y+5);
    px_R = (math.floor(new_px/256/256/256) % 256);
    px_G = (math.floor(new_px/256/256) % 256);
    px_B = (math.floor(new_px/256) % 256);
    px_A = (new_px % 256);
    button_index2 = find_button_index(ingred2);
	  lsPrintln(button_index2);
    srClickMouse(paint_buttons[button_index][0]+2,paint_buttons[button_index][1]+2, right_click);
    lsSleep(per_click_delay);
    
    lsPrintln("Testing " .. ingred2 .. " and " .. ingred1);
end

function doit()
    lsSetCaptureWindow();
    askForWindow("Open the paint window. Take any paint away so to start with 'Black'.\n\nNote you want to keep a supply of Red Sand (if you\'re testing reactions).\n\nClicking the 'Reset' button will convert your Pigment Lab 'back to Black' color, again, but it requires Red Sand to do so. It\'s Magic!");
    srReadScreen();
    
    --cabbage
    for i=1, #cabbage_reactions do
        get_reactions("CabbageJ", cabbage_reactions[i]);
    end
    
    for i=1, #carrot_reactions do
        get_reactions("Carrot", carrot_reactions[i];
    end
end
