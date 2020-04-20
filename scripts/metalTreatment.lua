dofile("common.inc");
dofile("settings.inc");

METAL_RECIPE = {};

metalList = {"Aluminum","Antimony","Brass","Bronze","Cobalt","Copper","Gold","Iron","Lead","Magnesium","Metal Blue","Moon Steel","Nickel","Octec's Alloy","Pewter","Platinum","Silver","Steel","Sun Steel","Thoth's Metal","Tin","Zinc","Water Metal"};

TREAT_INDEX = {
["Arsenic"]=1,["Cabbage"]=2,["Cactus"]=3,["Coal"]=4,["Gravel"]=5,
["Lime"]=6,["Potash"]=7,["Salt"]=8,["Saltpeter"]=9,["Sulfur"]=10};

SALT_INDEX = {
["AluminumSalts"]=1,["AntimonySalts"]=2,["CobaltSalts"]=3,["CopperSalts"]=4,["GoldSalts"]=5,
["IronSalts"]=6,["LeadSalts"]=7,["MagnesiumSalts"]=8,["NickelSalts"]=9,["PlatinumSalts"]=10,
["SilverSalts"]=11,["TinSalts"]=12,["ZincSalts"]=13};

RED = 0xFF2020ff;
BLACK = 0x000000ff;
WHITE = 0xFFFFFFff;

recipes = {};
filename = "treat_metal.txt"
exampleRecipes = "(Sun Steel) Hard, Stainless, Insulative, 5 : Saltpeter 40 Cabbage 30 Coal 40 Gravel 10 - #example"

function doit()
    recipes = loadRecipes(filename);
    askForWindow("Open the chemical bath. Take any metal away so we start with an empty tank.");
    while 1 do
        checkBreak();
        srReadScreen();
        window_pos = findText("This is [a-z]+ Chemical Bath", nil, REGEX);
            if (not window_pos) then
                error "Did not find a pinned Chemical Bath window";
            end
        local config = getUserParams();
        checkBreak();
        sleepWithStatus(1200, "Preparing to Start ...\n\nHands off the mouse!"); 
        treatMetal(config);
    end
end

function treatMetal(config)
    srReadScreen();
    makeMetal(config, config.metal_amount);
end

function makeMetal(config, metal_amount)
    if metal_amount >= 100 then
        remainder = metal_amount % 100;
        hundreds = metal_amount - remainder;
        hundred_batches = hundreds / 100;
        makeMetalBatch(config, hundred_batches);
            if remainder > 0 then
                makeMetalBatch(config, 1, remainder);
            end
    else
        makeMetalBatch(config, metal_amount)
    end
end

function makeMetalBatch(config, num_batches, remainder)
    srReadScreen();
    for i=1, num_batches do
        checkBreak();    
        srReadScreen();
        refreshWindows();
        
        srReadScreen();
        Load = findText("Load...");  
        if Load then
            clickText(Load);
            lsSleep(500);        
        else
            error("Could not find a 'Load...' option")
        end
        
        if config.metal_type == 1 then
            metalType = "Aluminum"
        elseif config.metal_type == 20 then
            metalType = "Thoth"
        end

        if config.metal_type == 1 then
            metalType = "Aluminum"
        elseif config.metal_type == 2 then
            metalType = "Antimony"
        elseif config.metal_type == 3 then
            metalType = "Brass"
        elseif config.metal_type == 4 then
            metalType = "Bronze"
        elseif config.metal_type == 5 then
            metalType = "Cobalt"
        elseif config.metal_type == 6 then
            metalType = "Copper"
        elseif config.metal_type == 7 then
            metalType = "Gold"
        elseif config.metal_type == 8 then
            metalType = "Iron"
        elseif config.metal_type == 9 then
            metalType = "Lead"
        elseif config.metal_type == 10 then
            metalType = "Magnesium"
        elseif config.metal_type == 11 then
            metalType = "Metal Blue"
        elseif config.metal_type == 12 then
            metalType = "Moon Steel"
        elseif config.metal_type == 13 then
            metalType = "Nickel"
        elseif config.metal_type == 14 then
            metalType = "Octec"
        elseif config.metal_type == 15 then
            metalType = "Pewter"
        elseif config.metal_type == 16 then
            metalType = "Platinum"
        elseif config.metal_type == 17 then
            metalType = "Silver"
        elseif config.metal_type == 18 then
            metalType = "Steel"
        elseif config.metal_type == 19 then
            metalType = "Sun Steel"
        elseif config.metal_type == 20 then
            metalType = "Thoth"
        elseif config.metal_type == 21 then
            metalType = "Tin"
        elseif config.metal_type == 21 then
            metalType = "Zinc"
        elseif config.metal_type == 21 then
            metalType = "Water Metal"
        end

        srReadScreen();
        metalToTreat = findText(metalType);
        if metalToTreat then 
            lsSleep(500);
            clickText(waitForText(metalType));
        else
            if metalType == "Thoth" then
                error("Could not find metal type: " .. metalType .. "'s Metal")
            elseif metalType == "Octec" then
                error("Could not find metal type: " .. metalType .. "'s Alloy")
            else
                error("Could not find metal type: " .. metalType)
            end
        end

        waitForText("Load how much");
        srReadScreen();
        local max = srFindImage("max.png");
            if remainder ~= nil then
                srKeyEvent(remainder); -- Add the treatment value
                srKeyEvent(string.char(13));  -- Send Enter Key to close the window
            else
                safeClick(max[0]+5,max[1]+5,1);
            end
        waitForNoText("Load how much");

            for iidx=1, #recipes[config.metal_index].ingredient do
                checkBreak();
                srReadScreen();
                
                sleepWithStatus(2500, "Allowing the server to settle down, to avoid 'Chemical Bath is Busy' popup.", nil, 0.7); 
                clickText(waitForText("Dissolve..."));
                waitForText("in the Acid")

                if string.find(recipes[config.metal_index].ingredient[iidx], "Salts", 0) then
                    srReadScreen();
                    clickText(waitForText("Salts..."));
                    waitForText("Salts Of")

                    srReadScreen();
                    local treat_buttons = findAllImages("metalTreatment/dissolveSalts.png");
                        if (#treat_buttons == 0) then
                            error "No 'Salts Of' option found";
                        end

                    checkBreak();
                    local buttonNo = SALT_INDEX[recipes[config.metal_index].ingredient[iidx]];
                    srClickMouseNoMove(treat_buttons[buttonNo][0]+2,treat_buttons[buttonNo][1]+2, right_click);
                    waitForText("How many");
                    srKeyEvent(recipes[config.metal_index].amount[iidx]) -- Add the treatment value
                    srKeyEvent(string.char(13));  -- Send Enter Key to close the window
                    waitForNoText("How many");
                    checkProcessing(recipes[config.metal_index].ingredient[iidx]);
                else
                    srReadScreen();
                    local treat_buttons = findAllImages("metalTreatment/inAcid.png");
                        if (#treat_buttons == 0) then
                            error "No 'Dissolve' option found";
                        end

                    checkBreak();
                    local buttonNo = TREAT_INDEX[recipes[config.metal_index].ingredient[iidx]];
                    srClickMouseNoMove(treat_buttons[buttonNo][0]+2,treat_buttons[buttonNo][1]+2, right_click);
                    waitForText("How many");
                    srKeyEvent(recipes[config.metal_index].amount[iidx]) -- Add the treatment value
                    srKeyEvent(string.char(13));  -- Send Enter Key to close the window
                    waitForNoText("How many");
                    checkProcessing(recipes[config.metal_index].ingredient[iidx]);
                end
            end
            srReadScreen();
            lsSleep(250);
            clickAllText("Take Everything");
            sleepWithStatus(2500, "Short pause to allow the Chemical Bath values to reset before loading the next set of metal.", nil, 0.7); 
    end
end

function refreshWindows()
    srReadScreen();
    this = findAllText("This");
    for i = 1, #this do
        clickText(this[i]);
    end
    lsSleep(100);
end

function checkProcessing(ingredient)
    while 1 do
        refreshWindows();
        srReadScreen();
        process = findAllImages("processComplete.png")
            if #process == 0 then
                sleepWithStatus(999, "Waiting for metal to finish being treated.", nil, 0.7, "Monitoring Pinned Window(s)");
            else
                break; --We break this while statement because Processing Complete is not detect, hence we're done with this round
            end
        
    end
end

-- Used to place gui elements sucessively.
current_y = 0
-- How far off the left hand side to place gui elements.
X_PADDING = 5

function getUserParams()
    local is_done = false;
    local got_user_params = false;
    local config = {metal_amount=500};
    config.metal_name = "";
    config.metal_index = 1;
    while not is_done do
        current_y = 10;

        lsPrintWrapped(8, current_y, 10, lsScreenX - 20, 0.65, 0.65, 0xD0D0D0ff,
        "Automatically process treated metal from a given recipe.\n-----------------------------------------------------------");

            lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);
                config.metal_index = readSetting("metal_name",config.metal_index);
                lsPrint(10, current_y+70, z, 0.95, 0.95, 0xffff40ff, "Treatment Recipe:");
                config.metal_index = lsDropdown("metal_name", 10, current_y+98, X_PADDING, 375, config.metal_index, METAL_RECIPE);
                writeSetting("metal_name",config.metal_index);
                config.metal_name = METAL_RECIPE[config.metal_index];
                lsPrint(233, current_y+135, z, 0.95, 0.95, 0xffff40ff, "Metal to treat:");
                config.metal_type = lsDropdown("metal_type", 233, current_y+163, X_PADDING, 150, config.metal_type, metalList);
                lsPrint(10, current_y+135, z, 0.95, 0.95, 0xffff40ff, "Volume of metal:");
                current_y = 105;
            lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
            current_y = current_y - 25;
            config.metal_amount = drawNumberEditBox("metal_amount", "                      Treat how much metal?", 100, true, 65);
            current_y = current_y - 5;
            got_user_params = true;

            if config.metal_amount then
                drawWrappedText("Metal Treatment Recipe : (Per 100 Metal)", 0x00FF00FF, X_PADDING, current_y+30);
                current_y = current_y + 55;
                for i=1, #recipes[config.metal_index].ingredient do
                    if recipes[config.metal_index].ingredient[i] == "AluminumSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Aluminum", 0xD0D0D0ff, X_PADDING, current_y);
                    elseif recipes[config.metal_index].ingredient[i] == "AntimonySalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Antimony", 0xD0D0D0ff, X_PADDING, current_y);
                    elseif recipes[config.metal_index].ingredient[i] == "CopperSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Copper", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "CobaltSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Cobalt", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "GoldSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Gold", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "IronSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Iron", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "LeadSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Lead", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "MagnesiumSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Magnesium", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "NickelSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Nickel", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "PlatinumSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Platinum", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "SilverSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Silver", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "TinSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Tin", 0xD0D0D0ff, X_PADDING, current_y); 
                    elseif recipes[config.metal_index].ingredient[i] == "ZincSalts" then
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. "Salts Of Zinc", 0xD0D0D0ff, X_PADDING, current_y);                         
                    else
                        drawWrappedText(math.ceil(recipes[config.metal_index].amount[i] / 10) .. " " .. recipes[config.metal_index].ingredient[i], 0xD0D0D0ff, X_PADDING, current_y);
                    end
                    drawWrappedText(" : ", 0xFF0000ff, X_PADDING + 85, current_y);
                    drawWrappedText(math.ceil(recipes[config.metal_index].amount[i]) .. " Seconds " .. "", 0xFFFF40FF, X_PADDING + 105, current_y);
                    current_y = current_y + 15;
                end
        end

        if lsButtonText(8, lsScreenY - 30, z, 100, 0x00ff00ff, "Process") then
			is_done = 1;
		end
 
        if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff,
                    "End script") then
        error "Script exited by user";
        end

        lsDoFrame();
        lsSleep(10);
    end

    click_delay = 10;
    return config;
end

function drawNumberEditBox(key, text, default, validation, size)
    return drawEditBox(key, text, default, validation, size);
end

function drawEditBox(key, text, default, validateNumber, size)
    drawTextUsingCurrent(text, WHITE);
    local width = validateNumber and 50 or 200;
    local height = 22;
    local done, result = lsEditBox(key, X_PADDING+3, current_y+22, 0, size, height, 1.0, 1.0, BLACK, default);
    if validateNumber then
        result = tonumber(result);
    elseif result == "" then
        result = false;
    end
    if not result then
        local error = validateNumber and "Please enter a valid number!" or "Enter text!";
        drawText(error, RED, X_PADDING + width + 5, current_y + 5);
        result = false;
    end
    current_y = current_y + 35;
    return result;
end

function drawTextUsingCurrent(text, colour)
    drawText(text, colour, X_PADDING, current_y);
    current_y = current_y + 20;
end
function drawText(text, colour, x, y)
    lsPrint(x, y, X_PADDING, 0.7, 0.7, colour, text);
end

function drawWrappedText(text, colour, x, y)
    lsPrintWrapped(x, y, X_PADDING, lsScreenX-X_PADDING, 0.6, 0.6, colour, text);
end

function drawBottomButton(xOffset, text)
    checkBreak();
    return lsButtonText(lsScreenX - xOffset, lsScreenY - 30, z, 100, WHITE, text);
end

-- Added in an explode function (delimiter, string) to deal with broken csplit.
function explode(d,p)
   local t, ll
   t={}
   ll=0
   if(#p == 1) then
      return {p}
   end
   while true do
      l = string.find(p, d, ll, true) -- find the next d in the string
      if l ~= nil then -- if "not not" found then..
         table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
         ll = l + 1 -- save just after where we found it for searching next time.
      else
         table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
         break -- Break at end, as it should be, according to the lua manual.
      end
   end
   return t
end

function setLine(tree, line, lineNo)
    --local sections = csplit(line, ":");
	local sections = explode(":",line);
	--error(sections[2])
    if #sections ~= 2 then
        error("Cannot parse line: " .. line .. " Sections equal " .. #sections);
    end
    METAL_RECIPE[lineNo] = sections[1]:match( "^%s*(.-)%s*$" );
    --sections = csplit(sections[2], "-");
	sections = explode("-",sections[2])
    if #sections ~= 2 then
        error("Cannot parse line: " .. line);
    end
    --local tags = csplit(sections[1]:match( "^%s*(.-)%s*$" ), " ");
    local tags = explode(" ",sections[1]:match( "^%s*(.-)%s*$" ));
	local index = 1;
    tree[lineNo] = {ingredient={},amount={}};
    for i=1, #tags do
        if i % 2 == 1 then
            tree[lineNo].ingredient[index] = tags[i];
        else
            tree[lineNo].amount[index] = tonumber(tags[i]);
        end
        index = index + ((i + 1) % 2);
    end
end

function loadRecipes(filename)
    checkRecipesFound(filename);
    local result = {};
    local file = io.open(filename, "a+");
    io.close(file);
    local lineNo = 1;
    for line in io.lines(filename) do
        setLine(result, line, lineNo);
        lineNo = lineNo + 1;
    end
    return result;
end

function checkRecipesFound(filename)
  local file = io.open(filename, "a+");
  local lineCounter = 0;
  for line in io.lines(filename) do
    lineCounter = lineCounter + 1;
  end
  if lineCounter == 0 then
    file:write(exampleRecipes);
  end
  io.close(file);
end
