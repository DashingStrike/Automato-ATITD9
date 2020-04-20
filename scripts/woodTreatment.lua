dofile("common.inc");
dofile("settings.inc");

BOARD_RECIPE = {};

INGREDIENT_NAMES = {
"Ash","Potash","Oil","Beeswax","Sulfur","Lead","Lime",
"Water","Saltpeter","Petroleum","Charcoal","Bonemeal"};

TREAT_INDEX = {
["Ash"]=1,["Potash"]=2,["Oil"]=3,["Beeswax"]=4,["Sulfur"]=5,["Lead"]=6,["Lime"]=7,
["Water"]=8,["Saltpeter"]=9,["Petroleum"]=10,["Charcoal"]=11,["Bonemeal"]=12};

RED = 0xFF2020ff;
BLACK = 0x000000ff;
WHITE = 0xFFFFFFff;

recipes = {};
filename = "treat_boards.txt"
exampleRecipes = "Rigid, Rotproof, Blonde : Lime 160 Beeswax 50 - #example\nPliable, Rotproof, Nontoxic, White : Bonemeal 160 Beeswax 40 Bonemeal 10 Beeswax 40 - #example"

function doit()
    recipes = loadRecipes(filename);
    askForWindow("Open the wood treatment tank. Take any boards away so we start with an empty tank.");
    while 1 do
        checkBreak();
        srReadScreen();
        local window_pos = findText("This is [a-z]+ Wood Treatment Tank", nil, REGEX);
            if (not window_pos) then
                error "Did not find a pinned Wood Treatment Tank window";
            end
        local config = getUserParams();    
        checkBreak();
        sleepWithStatus(1200, "Preparing to Start ...\n\nHands off the mouse!"); 
        treatBoards(config);
    end
end

function treatBoards(config)
    srReadScreen();
    makeBoards(config, config.boards_amount);
end

function makeBoards(config, boards_amount)
    if boards_amount >= 500 then
        remainder = boards_amount % 500;
        fiveHundreds = boards_amount - remainder;
        fiveHundred_batches = fiveHundreds / 500;
        makeBoardsBatch(config, fiveHundred_batches);
            if remainder > 0 then
                makeBoardsBatch(config, 1, remainder);
            end
    else
        makeBoardsBatch(config, boards_amount)
    end
end

function makeBoardsBatch(config, num_batches, remainder)
    srReadScreen();
    for i=1, num_batches do
        checkBreak();
        srReadScreen();
        Load = findText("Load Boards");
        if Load then
            clickText(Load);
        else
            error("Could not find a 'Load Boards' option")
        end

        waitForText("Load compartment");
        srReadScreen();
        local max = srFindImage("max.png");
            if remainder ~= nil then
                srKeyEvent(remainder); -- Add the treatment value
                srKeyEvent(string.char(13));  -- Send Enter Key to close the window
            else
                safeClick(max[0]+5,max[1]+5,1);
            end
        waitForNoText("Load compartment");

            for iidx=1, #recipes[config.board_index].ingredient do
                checkBreak();
                srReadScreen();
                
                sleepWithStatus(2500, "Allowing the server to settle down, to avoid 'Wood Treatment Tank is Busy' popup.", nil, 0.7); 
                clickText(waitForText("Treat..."));
                waitForText("Treat with")

                srReadScreen();
                local treat_buttons = findAllImages("woodTreatment/treatWith.png");
                    if (#treat_buttons == 0) then
                        error "No 'Treat with...' option found";
                    end

                checkBreak();
                local buttonNo = TREAT_INDEX[recipes[config.board_index].ingredient[iidx]];
                srClickMouseNoMove(treat_buttons[buttonNo][0]+2,treat_buttons[buttonNo][1]+2, right_click);
                waitForText("How many");
                srKeyEvent(recipes[config.board_index].amount[iidx]) -- Add the treatment value
                srKeyEvent(string.char(13));  -- Send Enter Key to close the window
                waitForNoText("How many");
                checkProcessing(recipes[config.board_index].ingredient[iidx]);   
            end
            srReadScreen();
            lsSleep(250);
            clickAllText("Take Everything");          
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
                sleepWithStatus(999, "Waiting for boards to finish being treated.", nil, 0.7, "Monitoring Pinned Window(s)");
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
    local is_done = nil;
    local got_user_params = false;
    local config = {boards_amount=500};
    config.board_name = "";
    config.board_index = 1;
    while not is_done do
        current_y = 10;

        lsPrintWrapped(8, current_y, 10, lsScreenX - 20, 0.65, 0.65, 0xD0D0D0ff,
        "Automatically process treated boards from a given recipe.\n-----------------------------------------------------------");

        lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);
            config.board_index = readSetting("board_name",config.board_index);
            lsPrint(10, current_y+70, z, 0.95, 0.95, 0xffff40ff, "Treatment Recipe:");
            config.board_index = lsDropdown("board_name", 10, current_y+100, X_PADDING, 375, config.board_index, BOARD_RECIPE);
            writeSetting("board_name",config.board_index);
            config.board_name = BOARD_RECIPE[config.board_index];
            current_y = 105;
            lsPrint(10, current_y+40, z, 0.95, 0.95, 0xffff40ff, "Volume of boards to treat:");
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
        config.boards_amount = drawNumberEditBox("boards_amount", " ", 500);
        current_y = current_y - 5;
        got_user_params = true;
        for k,v in pairs(config) do
            got_user_params = got_user_params and v;
        end
        if config.boards_amount then
            drawWrappedText("Wood Treatment Recipe : (Per 500 Boards)", 0x00FF00FF, X_PADDING, current_y+5);
            current_y = current_y + 15;
            for i=1, #recipes[config.board_index].ingredient do
                drawWrappedText(math.ceil(recipes[config.board_index].amount[i] / 10) .. " " .. recipes[config.board_index].ingredient[i], 0xD0D0D0ff, X_PADDING, current_y+10);
                drawWrappedText(" : ", 0xFF0000ff, X_PADDING + 85, current_y+10);
                drawWrappedText(math.ceil(recipes[config.board_index].amount[i]) .. " Seconds " .. "", 0xFFFF40FF, X_PADDING + 105, current_y+10);
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
    local done, result = lsEditBox(key, X_PADDING+3, current_y, 0, 65, height, 1.0, 1.0, BLACK, default);
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
    BOARD_RECIPE[lineNo] = sections[1]:match( "^%s*(.-)%s*$" );
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
