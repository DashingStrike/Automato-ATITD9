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

-- the script will cover both sides of a reaction, no need to explicitly put both backwards and forwards
cabbage_reactions = {"Falcon Bait", "Red Sand", "Copper" }
carrot_reations = {"Dead Tongue", "Toad Skin", "Falcon Bait", "Silver", "Copper", "Lime", "Saltpeter"}
clay_reactions = {"Toad Skin","Lead","Silver","Iron","Sulfur","Lime"}
dt_reactions = {"Toad Skin", "Falcon Bait", "Red Sand","Silver","Iron","Copper","Sulfur"}
ts_reactions = {"Falcon Bait", "Red Sand","Silver","Iron","Copper", "Potash", "Saltpeter"}
fb_reactions = {"Red Sand","Sulfur"}
redsand_reactions = {"Lead","Silver", "Sulfur"}
lead_reactions = {"Silver", "Iron", "Saltpeter"}
silver_reactions = {"Copper", "Sulfur", "Lime", "Saltpeter"}
iron_reactions = {"Copper","Sulfur","Potash","Lime"}
copper_reactions = {"Sulfur","Lime","Saltpeter"}
sulfur_reactions = {"Potash", "Saltpeter"}
lime_reactions = {"Saltpeter"}

use_shrooms = false;
use_silver = false;

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function check_all_catalysts(ingred1, ingred2)
    if has_value(catalysts, ingred1) and has_value(catalysts, ingred2) then
        return true
    else
        return false
    end
end

function WriteLog(Text)
    logfile = io.open("reactions.txt","a+");
    logfile:write(Text .. "\n");
    logfile:close();
end

function get_reaction_value(colour_differences)
    r = tonumber(colour_differences[1]);
    g = tonumber(colour_differences[2]);
    b = tonumber(colour_differences[3]);

    if r == g and g == b then
        reaction_type = "W";
        return reaction_type, r
    else
        if r ~= 0 then
            reaction_type = "R";
            return reaction_type, r
        else
            if g ~= 0 then
                reaction_type = "G";
                return reaction_type, g
            else
                reaction_type = "B";
                return reaction_type, b
            end
        end
    end

end

function get_reactions(ingred1, ingred2)
    paint_sum = {0,0,0};
    paint_count = 0;

    all_catalysts = check_all_catalysts(ingred1, ingred2);

    if all_catalysts == true then
        -- currently Cabbage Juice has no reactions with any catalysts
        lsPrintln("Adding Cabbage Juice before running all catalyst test");
        paint_sum, paint_count = click_ingredient("Cabbage Juice");
    end

    lsPrintln("Testing " .. ingred1 .. " and " .. ingred2);
    paint_sum, paint_count = click_ingredient(ingred1);

    paint_sum, paint_count = click_ingredient(ingred2);

    -- count up all the pixels.
    lsSleep(per_paint_delay_time);
    srReadScreen();

    bar_colour = get_bar_colour()

    if foundBigColorBar then
        pixelRGBA = math.floor(bar_colour[1]+0.5) .. ", " .. math.floor(bar_colour[2]+0.5) .. ", " .. math.floor(bar_colour[3]+0.5);
    else
        pixelRGBA = "Will Display on Next Reset ...";
    end

    expected_colour, diff_colour = get_colour_diffs(bar_colour, paint_count, paint_sum)

    -- Display all the goodies
    if math.floor(bar_colour[1]+0.5) == 0 or math.floor(bar_colour[2]+0.5) == 0 or math.floor(bar_colour[3]+0.5) == 0 then
        -- to-do: find an ingredient with high values for the min colour and add it if there are no reactions
        lsPrintln(" ******  WARNING: Reaction reached zero  *****");
    end

    if math.floor(bar_colour[1]+0.5) > 254 or math.floor(bar_colour[2]+0.5) > 254 or math.floor(bar_colour[3]+0.5) > 254 then
        lsPrintln(" ******  WARNING: Reaction reached max  *****");
    end

    lsPrintln(" Pixel RGBA: " .. pixelRGBA);
    lsPrintln(" Bar Read RGB: " .. math.floor(bar_colour[1]+0.5) .. ", " .. math.floor(bar_colour[2]+0.5) .. ", " .. math.floor(bar_colour[3]+0.5));
    lsPrintln(" Expected RGB: " .. math.floor(expected_colour[1]+0.5) .. ", " .. math.floor(expected_colour[2]+0.5) .. ", " .. math.floor(expected_colour[3]+0.5) );
    lsPrintln(" Reactions RGB: " .. math.floor(diff_colour[1]+0.5) .. ", " .. math.floor(diff_colour[2]+0.5) .. ", " .. math.floor(diff_colour[3]+0.5) );
    reaction_type, reaction1 = get_reaction_value(diff_colour);
    reset(paint_count);

    paint_sum = {0,0,0};
    paint_count = 0;

    all_catalysts = check_all_catalysts(ingred1, ingred2);

    if all_catalysts == true then
        -- currently Cabbage Juice has no reactions with any catalysts
        lsPrintln("Adding Cabbage Juice before running all catalyst test");
        paint_sum, paint_count = click_ingredient("Cabbage Juice");
    end

    lsPrintln("Testing " .. ingred2 .. " and " .. ingred1);
    paint_sum, paint_count = click_ingredient(ingred2);

    paint_sum, paint_count = click_ingredient(ingred1);

    -- count up all the pixels.
    lsSleep(per_paint_delay_time);
    srReadScreen();

    bar_colour = get_bar_colour()

    if foundBigColorBar then
        pixelRGBA = math.floor(bar_colour[1]+0.5) .. ", " .. math.floor(bar_colour[2]+0.5) .. ", " .. math.floor(bar_colour[3]+0.5);
    else
        pixelRGBA = "Will Display on Next Reset ...";
    end

    expected_colour, diff_colour = get_colour_diffs(bar_colour, paint_count, paint_sum)

    -- Display all the goodies
    if math.floor(bar_colour[1]+0.5) == 0 or math.floor(bar_colour[2]+0.5) == 0 or math.floor(bar_colour[3]+0.5) == 0 then
        lsPrintln(" ******  WARNING: Reaction reached zero  *****");
    end

    lsPrintln(" Pixel RGBA: " .. pixelRGBA);
    lsPrintln(" Bar Read RGB: " .. math.floor(bar_colour[1]+0.5) .. ", " .. math.floor(bar_colour[2]+0.5) .. ", " .. math.floor(bar_colour[3]+0.5));
    lsPrintln(" Expected RGB: " .. math.floor(expected_colour[1]+0.5) .. ", " .. math.floor(expected_colour[2]+0.5) .. ", " .. math.floor(expected_colour[3]+0.5) );
    lsPrintln(" Reactions RGB: " .. math.floor(diff_colour[1]+0.5) .. ", " .. math.floor(diff_colour[2]+0.5) .. ", " .. math.floor(diff_colour[3]+0.5) );
    reaction_type, reaction2 = get_reaction_value(diff_colour);

    reset(paint_count);

    reaction_text = ingred1 .. " | " .. ingred2 .. " | " .. reaction_type .. " | " .. reaction1 .. " | " .. reaction2;
    WriteLog(reaction_text);
end

function run_reactions(ingredient_name, ingredient_reactions)
    for i=1, #ingredient_reactions do
        OK = srFindImage("ok.png");

        if OK then
            return 0
        else
            if use_shrooms == false then
                if has_value(mushrooms, ingredient_name) == false and has_value(mushrooms, ingredient_reactions[i]) == false then
                    if use_silver == false then
                        if ingredient_name ~= "Silver" and ingredient_reactions[i] ~= "Silver" then
                            -- the ingredient isn't a shroom or silver, run it
                            get_reactions(ingredient_name, ingredient_reactions[i]);
                        else
                            lsPrintln("Skipping Silver Powder");
                        end
                    else
                        -- the ingredient isn't a shroom and we're ok using silver, so run it
                        get_reactions(ingredient_name, ingredient_reactions[i]);
                    end
                else
                    lsPrintln("Skipping shroom: " .. ingredient_reactions[i]);
                end
            else
                if use_silver == false then
                    if ingredient_name ~= "Silver" and ingredient_reactions[i] ~= "Silver" then
                        -- the ingredient isn't silver and we're ok using shrooms, run it
                        get_reactions(ingredient_name, ingredient_reactions[i]);
                    else
                        lsPrintln("Skipping Silver Powder");
                    end
                else
                    -- we're ok using silver and shrooms, run it
                    get_reactions(ingredient_name, ingredient_reactions[i]);
                end
            end
        end
    end
end

function doit()
    -- note to self, close the map before starting
    -- search for 'Map of Egypt' and press F3 if visible
    lsSetCaptureWindow();
    askForWindow("Open the paint window. Take any paint away so to start with 'Black'.\n\nNote you want to keep a supply of Red Sand (if you\'re testing reactions).\n\nClicking the 'Reset' button will convert your Pigment Lab 'back to Black' color, again, but it requires Red Sand to do so. It\'s Magic!");
    srReadScreen();
    xyWindowSize = srGetWindowSize();
    findBigColorBar();

    --cabbage
    run_reactions("Cabbage Juice", cabbage_reactions);

    -- carrot
    run_reactions("Carrot", carrot_reations);

    -- clay
    run_reactions("Clay", clay_reactions);

    -- dead tongue
    run_reactions("Dead Tongue", dt_reactions);

    -- toadskin
    run_reactions("Toad Skin", ts_reactions);

    -- falcon's bait
    run_reactions("Falcon Bait", fb_reactions);

    --red sand
    run_reactions("Red Sand", redsand_reactions);

    -- lead
    run_reactions("Lead", lead_reactions);

    -- silver
    run_reactions("Silver", silver_reactions);

    -- iron
    run_reactions("Iron", iron_reactions);

    -- copper
    run_reactions("Copper", copper_reactions);

    -- sulfur
    run_reactions("Sulfur", sulfur_reactions);

    -- lime
    run_reactions("Lime", lime_reactions);

end
