dofile("common.inc");
dofile("settings.inc");

COLOR_NAMES = {};

INGREDIENT_NAMES = {
"Cabbage","Carrot","Clay","DeadTongue","ToadSkin","FalconBait","RedSand",
"Lead","Silver","Iron","Copper","Sulfur","Potash","Lime","Saltpeter"};

BUTTON_INDEX = {
["Cabbage"]=1,["Carrot"]=2,["Clay"]=3,["DeadTongue"]=4,["ToadSkin"]=5,["FalconBait"]=6,["RedSand"]=7,
["Lead"]=8,["Silver"]=9,["Iron"]=10,["Copper"]=11,["Sulfur"]=12,["Potash"]=13,["Lime"]=14,["Saltpeter"]=15};

RED = 0xFF2020ff;
BLACK = 0x000000ff;
WHITE = 0xFFFFFFff;

recipes = {};
filename = "paint_recipes.txt"
exampleRecipes = "Barn Red : Clay 3 RedSand 9 Silver 4 - #example\nBeet : Cabbage 8 Clay 2 - #example\nBoysenberry : Cabbage 4 Clay 6 - #example\nBrown : Carrot 2 RedSand 8 - #example\nBurgundy Red : RedSand 8 Silver 2 - #example\nBurnt Umber : Clay 3 RedSand 7 - #example"

function doit()
    recipes = loadRecipes(filename);
    askForWindow("Open the paint window. Take any paint away so to start with 'Black'.");
    srReadScreen();
        lastIngredient = srFindImage("paint/noIngredient.png")
            if (not lastIngredient) then
                error "A pigment laboratory was either not found or already has ingredients being processed, please either pin or reset the lab and start again";
            end
    while 1 do
        checkBreak();
        local config = getUserParams();
        checkBreak();     
        mixPaint(config);
    end
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function clickBatchText(text)
    batch_text = findText(text);
    if batch_text then
        srClickMouseNoMove(batch_text[0]+20, batch_text[1]+5);
        lsSleep(200);
        srReadScreen();
    else
        print("Batch text not found: " .. text);
    end
end

function setBatchSize(size)
    srReadScreen();
    clickBatchText("Batch Size...");
    if size == "Large" then
        clickBatchText("Make large batches (x100)");
    else
        if size == "Medium" then
            clickBatchText("Make medium batches (x10)");
        else
            clickBatchText("Make small batches (x1)");
        end
    end
    lsSleep(200);
end

function makePaintBatch(config, num_batches, size)
    srReadScreen();
    local paint_buttons = findAllImages("plus.png");
    if (#paint_buttons == 0) then
        error "No buttons found";
    end

    for i=1, num_batches do
        checkBreak();
        for iidx=1, #recipes[config.color_index].ingredient do
            for aidx=1, recipes[config.color_index].amount[iidx] do
                checkBreak();
                local buttonNo = BUTTON_INDEX[recipes[config.color_index].ingredient[iidx]];
                srClickMouseNoMove(paint_buttons[buttonNo][0]+2,paint_buttons[buttonNo][1]+2, right_click);
                sleepWithStatus(click_delay, "Making paint batch " .. i .. " of " .. math.floor(num_batches));
            end
        end
        srReadScreen();
        lsSleep(100);
        if take_paint then
            clickAllText("Take the Paint");
        end
        lsSleep(100);
    end
end

function makePaint(config, paint_amount)
    if paint_amount >= 100 then
        setBatchSize("Large");
        remainder = paint_amount % 100;
        hundreds = paint_amount - remainder;
        hundred_batches = hundreds / 100;
        makePaintBatch(config, math.floor(hundred_batches));
        makePaint(config, remainder);
    else
        if paint_amount >= 10 then
            setBatchSize("Medium");
            remainder = paint_amount % 10;
            tens = paint_amount - remainder;
            ten_batches = tens / 10;
            makePaintBatch(config, math.floor(ten_batches));
            makePaint(config, remainder)
        else
            if take_paint then
                setBatchSize("Small");
                makePaintBatch(config, math.floor(paint_amount))
            else
                makePaintBatch(config, math.floor(paint_amount))
            end
        end
    end
end

function close_map()
    srReadScreen();
    map_close = findAllImages("map_close.png");

    if map_close then
        for i=1, #map_close do
            -- click near each 'x' in turn to see if that brings the map into focus
            srClickMouse(map_close[i][0]-10,map_close[i][1]);
            lsSleep(200);
            srReadScreen();
            map_text = findText("Map of Egypt");
            if map_text then
                print("Map found, closing");
                srClickMouse(map_close[i][0]+5,map_close[i][1]+5);
                break;
            end
        end
    end
end

function mixPaint(config)
    close_map();
    srReadScreen();

    batch_picker = findText("Batch Size...");
    if batch_picker then
        makePaint(config, config.paint_amount);
    else
        -- if there is no batch mixer, just make the paint with size one
        makePaintBatch(config, config.paint_amount);
    end
end

-- Used to place gui elements sucessively.
current_y = 0
-- How far off the left hand side to place gui elements.
X_PADDING = 5

function getUserParams()
    local is_done = false;
    local config = {paint_amount=10};
    config.color_name = "";
    config.color_index = 1;
    while not is_done do
        current_y = 10;

        lsPrintWrapped(8, current_y, 10, lsScreenX - 20, 0.65, 0.65, 0xD0D0D0ff,
      "Automatic batch size detection based on the volume of paint.\n-----------------------------------------------------------");

            lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);
                config.color_index = readSetting("color_name",config.color_index);
                lsPrint(13, current_y+73, z, 0.95, 0.95, 0xffff40ff, "Paint Recipe:");
                config.color_index = lsDropdown("color_name", 13, current_y+103, X_PADDING, 350, config.color_index, COLOR_NAMES);
                writeSetting("color_name",config.color_index);
                config.color_name = COLOR_NAMES[config.color_index];
                current_y = 160;
                lsPrint(13, current_y, z, 0.95, 0.95, 0xffff40ff, "Volume of paint to mix:");
            lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
                config.paint_amount = drawNumberEditBox("paint_amount", " ",100);
                take_paint = readSetting("take_paint",take_paint);
                take_paint = CheckBox(90, current_y-81, 0, 0xffffffff, " Take Paint after batch", take_paint, 0.67, 0.67);
                writeSetting("take_paint",take_paint);
                if (not take_paint) then
                    lsPrintWrapped(90, current_y-62, 10, lsScreenX - 20, 0.65, 0.65, 0xFF0000ff,
                    "'Take Paint' is false, you must \nmake an exact paint quantity!");
                end
                current_y = current_y - 5;
            if config.paint_amount then
                drawWrappedText("Mix " .. config.paint_amount .. " debens of " ..
                         config.color_name .. " paint.", 0x00ffffff, X_PADDING, current_y-20);
                drawWrappedText("Total Cost:", 0x00ffffff, X_PADDING, current_y);
                current_y = current_y + 20;
                for i=1, #recipes[config.color_index].ingredient do
                    drawWrappedText(math.ceil(recipes[config.color_index].amount[i] * config.paint_amount / 10) .. " " ..
                             recipes[config.color_index].ingredient[i], 0xD0D0D0ff, X_PADDING, current_y);
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

function drawNumberEditBox(key, text, default)
    return drawEditBox(key, text, default, true);
end

function drawEditBox(key, text, default, validateNumber)
    drawTextUsingCurrent(text, WHITE);
    local width = validateNumber and 50 or 200;
    local height = 22;
    local done, result = lsEditBox(key, X_PADDING+5, current_y-46, 0, 65, height, 1.0, 1.0, BLACK, default);
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
    lsPrintWrapped(10, y, X_PADDING, lsScreenX-X_PADDING, 0.6, 0.6, colour, text);
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
    COLOR_NAMES[lineNo] = sections[1]:match( "^%s*(.-)%s*$" );
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
