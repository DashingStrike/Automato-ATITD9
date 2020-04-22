-- mining_ore.lua v2.4.1 -- by Cegaiel
-- Credits to Tallow for his Simon macro, which was used as a template to build on.
--
-- Brute force method, you manually click/set every stones' location and it will work every possible 3 node/stone combinations.
--
-- New in v2.2.0 - Now allows you to optionally try 4 stone combos after doing the regular 3 stone combos.
-- 4 stone combos don't produce ore very often, but when it does, its usually 100+
-- Choosing 4 stone combos will double the time per round, as the nodes worked quantity will double
-- ie Iron is 35 works for the normal 3 stone method.  But choosing 4 stone will cause it to be 70 (35 for 3 stone combos + 35 for 4 stone combos).
--
-- New in v2.2.3 Dual Monitor mode. This will use the srClickMouseNoMove method. Instead of moving mouse, hovering each node and sending a 'A' or 'S' key...
-- Instead it will right click each mouse (without moving mouse and click on the menus. This allows you to do something on 2nd monitor without having mouse move.
-- You will also be given a 3 second countdown (after selecting nodes) to get your mouse over to the 2nd monitor.
-- It will then move mouse once to upper left corner then start popping up menus.
-- BEWARE: You must uncheck Options, Interface Options: Right-Click opens a menu as pinned. Or else you will have tons of left-over pinned menus, that you need to close out!
--
-- v2.2.9 + New check box "Broken Stone Check" . When you tap shift over each node, it now records pixel color, in addition to the x,y position.
-- The tolerance is defined in rgbTol and hueTol. It might occassionaly give a false positive.  I've found if you zoom in a bit more, it usually fixes that.
-- The purpose of this is to skip all future nodes from attempting to be worked. Speeds up by not trying to work future stones that don't exist.
-- When this box is checked, the mouse position appears with the color you're highlighting.

-- For a more detailed Change Log and history, see https://github.com/DashingStrike/Automato-ATITD/commits/master/scripts/mining_ore.lua

-- v2.3.0 Adds new checkbox 'Manually Set Patterns'.  This incorporates the same method that mining_t5.lua uses.
-- When using this checkbox, you will be asked to set patterns you find. Practice using ATITD/mining_t5.lua to see how this works.
-- After setting your matching patterns manually, it will then click them.  This method (while takes longer to set up), does require less sets to process; Potentially more yield.

-- v2.4.0 Four Stone Combo no longer tries to brute force every possible 4 stone combo. Instead, it now keeps track of every 3 stone combo that produces ore.
-- It now will verify if a 4 stone combo is possible first, before performing it. This speeds up the process tremendously (Copper will no longer do an extra 70 combos, instead only do the 1-4 that's possible).
-- Strongly recommend you keep the "Work 4 stone combinations" check box checked. It increases chance for extra ore with hardly any extra time.
-- Improved Broken Node detection (when you get Gem/Coal, you broke one or more nodes). It will now try to detect the broken nodes, add to array and no longer work any combos, involving broken node(s).
-- New: Progress Bar
-- New Checkbox: Write Log Files. Creates very thorough Log files about what has occured - mining_ore_Logs.txt

dofile("common.inc");
dofile("settings.inc");

info = "Ore Mining v2.4.1 by Cegaiel --\nMacro brute force tries every possible 3 stone combination (and optionally 4 stone, too). Time consuming but it works!\n\nMAIN chat tab MUST be showing and wide enough so that each line doesn't wrap.\n\nChat MUST be minimized but Visible (Options, Chat-Related, \'Minimized chat channels are still visible\' - ON). Options/Interface Options: 'Use Flyaway message for some things' - OFF\n\nOptional: Pin the mine's Take... Ore... menu (\"All Ore\" will appear in pinned window) and it will refresh every round.\n\nWARNING: If you use the Dual Monitor option, uncheck in Interface Options: Right-Click opens a menu as pinned.";


-- Start don't alter these ...
oreGathered = 0;
oreGatheredTotal = 0;
oreGatheredLast = 0;
miningTime = 0;
timesworked = 0;
miningTimeTotal = 0;
dropdown_key_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_ore_values = {"Aluminum (9)", "Antimony (14)", "Cobalt (10)", "Copper (8)", "Gold (12)", "Iron (7)", "Lead (9)", "Magnesium (9)", "Nickel (13)", "Platinum (12)", "Silver (10)", "Tin (9)", "Zinc (10)"};
cancelButton = 0;
lastLineFound = "";
lastLineFound2 = "";
-- End Don't alter these ...


--Customizable
autoWorkMine = true; -- written to Settings.mining_ore.lua.txt
extraStones = true; -- written to Settings.mining_ore.lua.txt
noMouseMove = false; -- written to Settings.mining_ore.lua.txt
muteSoundEffects = false; -- written to Settings.mining_ore.lua.txt
minPopSleepDelay = 150;  -- The minimum delay time used during findClosePopUp() function
clickDelay = 125; -- written to Settings.mining_ore.lua.txt
 -- Useful for debugging. If true, will write log file to mining_ore.txt
writeLogFile = false;

--These tolerance values might need tweaked
rgbTol = 300; --50?  Was 150
hueTol = 300; --10?  Was 75

-- We normally look for an OK popup box to move on. We also compare last chat Line to current chat Line.
-- If we gathered the EXACT same amount of Ore from previous round, then this confuses macro and needs timeOut to move on.
-- Silver is a good example of repetive quantities, 1, 2 silver is common, back to back. Later in script, Silver will use 4000ms timeout instead of usual 6000ms timeout.

chatReadTimeOut = 6000; -- Maximum Time (ms) before moving on.
chatReadTimeOutSilver = 4000; -- Since silver frequently gets 1, 2 silver back to back, then lower time out to 4000 instead of 6000 so prevent longer hang times (when last chat line is same as previous line).

--End Customizable


function doit()
    askForWindow(info);
    promptDelays();
    getMineLoc();
    getPoints();
    if manualSets then
      getTraits();
      findSets();
    end
    clickSequence();
end


function doit2()
    promptDelays();
    getMineLoc();
    getPoints();
    if manualSets then
      getTraits();
      findSets();
    end
    clickSequence();
end


function getMineLoc()
    mineList = {};
    local was_shifted = lsShiftHeld();
    if (dropdown_cur_value_key == 1) then
        was_shifted = lsShiftHeld();
        key = "tap Shift";
    elseif (dropdown_cur_value_key == 2) then
        was_shifted = lsControlHeld();
        key = "tap Ctrl";
    elseif (dropdown_cur_value_key == 3) then
        was_shifted = lsAltHeld();
        key = "tap Alt";
    elseif (dropdown_cur_value_key == 4) then
        was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
        key = "click MWheel ";
    end
    local is_done = false;
    mx = 0;
    my = 0;
    z = 0;
    while not is_done do
        mx, my = srMousePos();
        local is_shifted = lsShiftHeld();
        if (dropdown_cur_value_key == 1) then
            is_shifted = lsShiftHeld();
        elseif (dropdown_cur_value_key == 2) then
            is_shifted = lsControlHeld();
        elseif (dropdown_cur_value_key == 3) then
            is_shifted = lsAltHeld();
        elseif (dropdown_cur_value_key == 4) then
            is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
        end

        if is_shifted and not was_shifted then
            mineList[#mineList + 1] = {mx, my};
        end
        was_shifted = is_shifted;
        checkBreak();
        lsPrint(10, 10, z, 1.0, 1.0, 0xc0c0ffff,
            "Set Mine Location");
        local y = 60;
        lsPrint(10, y, z, 0.7, 0.7, 0xf0f0f0ff, "Lock ATITD screen (Alt+L) - OPTIONAL!");
        y = y + 20;
        lsPrint(10, y, z, 0.7, 0.7, 0xf0f0f0ff, "Suggest F5 view, zoomed about 75% out.");
        y = y + 60;
        lsPrint(10, y, z, 0.7, 0.7, 0xc0c0ffff, "Hover and " .. key .. " over the MINE !");
        y = y + 70;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "TIP (Optional):");
        y = y + 20;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "For Maximum Performance (least lag) Uncheck:");
        y = y + 16;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Options, Interface, Other: 'Use Flyaway Messages'");
        local start = math.max(1, #mineList - 20);
        local index = 0;
        for i=start,#mineList do
            mineX = mineList[i][1];
            mineY = mineList[i][2];
        end
        if #mineList >= 1 then
            is_done = 1;
        end
        if ButtonText(205, lsScreenY - 30, z, 110, 0xFFFFFFff,
            "End script") then
            error "Clicked End Script button";
        end
        lsDoFrame();
        lsSleep(10);
    end
end


function fetchTotalCombos3()
    TotalCombos = 0;
    for i=1,#clickList do
        for j=i+1,#clickList do
            for k=j+1,#clickList do
                TotalCombos = TotalCombos + 1;
            end
        end
    end
end


function fetchTotalCombos4()
    local text4 = "";
    local counter = 0;
    oreNodes4 = {};
    TotalCombos = 0;
    for i=1, #clickList do
        for j=i+1,#clickList do
            for k=j+1,#clickList do
            	   for l=k+1,#clickList do
            	   counter = counter + 1;

            	       if isFourSetValid(i,j,k,l) then
            	         -- Check if i,j,k,l is already in the brokenStones{array}; if true, then don't add to oreNodes4{array}

            	         for z=1, #brokenStones do
            	           if brokenStones[z] == i or brokenStones[z] == j or brokenStones[z] == k or brokenStones[z] == l then
            	           -- Don't add to array, Do Nothing
            	             if writeLogFile then
            	               WriteLog("\n" .. i .. ", " .. j .. ", " .. k .. ", " .. l .. " ..  1+ Nodes are in Broken Node List, Excluded from oreNodes4{array} (4 Stone Combo Array)")
           	             end

            	           else
            	             text4 = text4 .. "\n" .. i .. ", " .. j .. ", " .. k .. ", " .. l;
            	             TotalCombos = TotalCombos + 1;
            	             oreNodes4[#oreNodes4 + 1] = {i, j, k, l};
            	           end -- if brokenStones[z] ...

            	         end -- for z

                      -- Below, was added above, commented out for now...
                      --text4 = text4 .. "\n" .. i .. ", " .. j .. ", " .. k .. ", " .. l;
                      --TotalCombos = TotalCombos + 1;
                      --oreNodes4[#oreNodes4 + 1] = {i, j, k, l};


            	       end -- if isFourSetValid(i,j,k,l)
            	   sleepWithStatus(5, "Verifying Four Stone Combos...\n\n(" .. counter .. ")  "  .. i .. ", " .. j .. ", " .. k .. ", " .. l .. "\n\n" .. TotalCombos .. " Found", nil, 0.7, "Parsing");
                end
            end
        end
    end
    if TotalCombos == 0 then
      text4 = text4 .. "<Skipping 4 Stone Combos>"
    else
      text4 = text4 .. "\n<Working 4 Stone Combos>\n"
    end
    if writeLogFile then
      WriteLog("\n**** " .. TotalCombos .. "/" .. #oreNodes .. " of the Combos that produced Ore have valid 4 Stone Combos\n" .. text4);
    end
    sleepWithStatus(1250, "Finished Verifying Four Stone Combos...\n\n" .. TotalCombos .. " Found -> " .. text4, nil, 0.7, "Parsing Complete");
end

function getPoints()
    clickList = {};
    clickListColor = {};
    mines = {};
    if (dropdown_ore_cur_value == 1) then
        ore = "Aluminum";
        stonecount = 9;
    elseif (dropdown_ore_cur_value == 2) then
        ore = "Antimony";
        stonecount = 14;
    elseif (dropdown_ore_cur_value == 3) then
        ore = "Cobalt";
        stonecount = 10;
    elseif (dropdown_ore_cur_value == 4) then
        ore = "Copper";
        stonecount = 8;
    elseif (dropdown_ore_cur_value == 5) then
        ore = "Gold";
        stonecount = 12;
    elseif (dropdown_ore_cur_value == 6) then
        ore = "Iron";
        stonecount = 7;
    elseif (dropdown_ore_cur_value == 7) then
        ore = "Lead";
        stonecount = 9;
    elseif (dropdown_ore_cur_value == 8) then
        ore = "Magnesium";
        stonecount = 9;
    elseif (dropdown_ore_cur_value == 9) then
        ore = "Nickel";
        stonecount = 13;
    elseif (dropdown_ore_cur_value == 10) then
        ore = "Platinum";
        stonecount = 12;
    elseif (dropdown_ore_cur_value == 11) then
        ore = "Silver";
        stonecount = 10;
    elseif (dropdown_ore_cur_value == 12) then
        ore = "Tin";
        stonecount = 9;
    elseif (dropdown_ore_cur_value == 13) then
        ore = "Zinc";
        stonecount = 10;
    end
    local nodeleft = stonecount;
    local was_shifted = lsShiftHeld();
    if (dropdown_cur_value_key == 1) then
        was_shifted = lsShiftHeld();
    elseif (dropdown_cur_value_key == 2) then
        was_shifted = lsControlHeld();
    elseif (dropdown_cur_value_key == 3) then
        was_shifted = lsAltHeld();
    elseif (dropdown_cur_value_key == 4) then
        was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    local is_done = false;
    local nx = 0;
    local ny = 0;
    local z = 0;
    while not is_done do
        nx, ny = srMousePos();
        pixels = srReadPixel(nx, ny);
        local is_shifted = lsShiftHeld();
        if (dropdown_cur_value_key == 1) then
            is_shifted = lsShiftHeld();
        elseif (dropdown_cur_value_key == 2) then
            is_shifted = lsControlHeld();
        elseif (dropdown_cur_value_key == 3) then
            is_shifted = lsAltHeld();
        elseif (dropdown_cur_value_key == 4) then
            is_shifted = lsMouseIsDown(2);
        end
        if is_shifted and not was_shifted then
            clickList[#clickList + 1] = {nx, ny};
            clickListColor[#clickListColor + 1] = {pixels};
            index = #clickList;
            mines[index] = {};
            mines[index].trait = {};
            nodeleft = nodeleft - 1;
        end
        was_shifted = is_shifted;
        checkBreak();
        lsPrint(10, 10, z, 1.0, 1.0, 0xc0c0ffff,
            "Set Node Locations (" .. #clickList .. "/" .. stonecount .. ")");
        local y = 60;
        lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);
        autoWorkMine = readSetting("autoWorkMine",autoWorkMine);
        autoWorkMine = lsCheckBox(15, y, z, 0xffffffff, " Auto 'Work Mine'", autoWorkMine);
        writeSetting("autoWorkMine",autoWorkMine);
        y = y + 25
        noMouseMove = readSetting("noMouseMove",noMouseMove);
        noMouseMove = lsCheckBox(15, y, z, 0xffffffff, " Dual Monitor (NoMouseMove) Mode", noMouseMove);
        writeSetting("noMouseMove",noMouseMove);
        y = y + 25
        writeLogFile = readSetting("writeLogFile",writeLogFile);
        writeLogFile = lsCheckBox(15, y, z, 0xffffffff, " Write Log File", writeLogFile);
        writeSetting("writeLogFile",writeLogFile);
        y = y + 25
        manualSets = readSetting("manualSets",manualSets);
        manualSets = lsCheckBox(15, y, z, 0xffffffff, " Manually Set Patterns", manualSets);
        writeSetting("manualSets",manualSets);
          y = y + 25
        if not manualSets then
          extraStones = readSetting("extraStones",extraStones);
          extraStones = lsCheckBox(15, y, z, 0xffffffff, " Work 4 stone combinations", extraStones);
          writeSetting("extraStones",extraStones);
        end
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
        y = y - 22
        lsPrint(10, y, z, 0.7, 0.7, 0xc0c0ffff, "Hover and " .. key .. " over each node.");
        y = y + 20;
        lsPrint(10, y, z, 0.7, 0.7, 0xff8080ff, "Make sure chat is MINIMIZED!");
        y = y + 25;
        lsPrint(10, y, z, 0.7, 0.7, 0xB0B0B0ff, "Mine Type: " .. ore .. " / Worked: " .. timesworked .. " times");
        y = y + 20;
        if miningTime ~= 0 then
          miningTimeGUI = DecimalsToMinutes(miningTime/1000);
        else
          miningTimeGUI = "N/A";
        end
        if miningTimeTotal ~= 0 then
          avgMiningTimeGUI = DecimalsToMinutes(miningTimeTotal/timesworked/1000);
        else
          avgMiningTimeGUI =  "N/A";
        end
        lsPrint(10, y, z, 0.7, 0.7, 0xf0f0f0ff, "Last: " .. miningTimeGUI .. "   /   Average: " .. avgMiningTimeGUI);
        y = y + 20;
        lsPrint(10, y, z, 0.7, 0.7, 0x80ff80ff, "Total Ore Found: " .. comma_value(math.floor(oreGatheredTotal)));
        lsPrint(175, y, z, 0.7, 0.7, 0x40ffffff, " Last: " .. comma_value(math.floor(oreGatheredLast)));
        y = y + 20;
        lsPrint(10, y, z, 0.65, 0.65, 0xB0B0B0ff, "Select " .. nodeleft .. " more nodes to automatically start!");
        y = y + 20;
        local start = math.max(1, #clickList - 20);
        local index = 0;
        for i=start,#clickList do
            local xOff = (index % 4) * 75;
            local yOff = (index - index%4)/2 * 7;
            local xOff2 = (#clickList % 4) * 75;
            local yOff2 = (#clickList - #clickList%4)/2 * 7;
            lsPrint(8 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff, i);
            lsPrint(8 + xOff, y + yOff, z, 0.5, 0.5, clickListColor[i][1], "     (" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
            index = index + 1;
            if #clickList < stonecount then
              lsPrint(8 + xOff2, y+yOff2, z, 0.5, 0.5, 0xffffffff, #clickList+1 .. ":");
              lsPrint(8 + xOff2, y+yOff2, z, 0.5, 0.5, pixels, "      " .. nx .. ", " .. ny);
            end
        end

        if #clickList == 0 then
          lsPrint(8, y, z, 0.5, 0.5, 0xffffffff, "1:");
          lsPrint(8, y, z, 0.5, 0.5, pixels, "      " .. nx .. ", " .. ny);
        end

        if #clickList >= stonecount then
            is_done = 1;
        end

        if #clickList == 0 then
            if ButtonText(10, lsScreenY - 30, z, 110, 0xffff80ff, "Work Mine") then
                workMine();
            end
        end

        if ButtonText(120, lsScreenY -30, z, 80, 0xffffffff, "Config") then
            cancelButton = 1;
            doit2();
        end

        if #clickList > 0 then
            if ButtonText(10, lsScreenY - 30, z, 100, 0xff8080ff, "Reset") then
                reset();
            end
        end

        if ButtonText(205, lsScreenY - 30, z, 110, 0xFFFFFFff,
            "End script") then
            error "Clicked End Script button";
        end

        lsDoFrame();
        lsSleep(10);
    end
end


function clickSequence()
    oreGatheredLast = 0;
    oreGathered = 0;
    worked = 0;
    logResult = "";
    brokenStones = {};
    oreNodes = {};
    brokenStoneInfo = "";
    startMiningTime = lsGetTimer();

    if manualSets then
      TotalCombos = #sets;
    end
    chatRead();
    if noMouseMove then
      sleepWithStatus(3000, "Starting...\n\nNow is your chance to move your mouse to second monitor!", nil, 0.7, "Attention");
    else
      sleepWithStatus(150, "Starting...\n\nDon\'t move mouse!", nil, 0.7, "Attention");
    end

    if manualSets then
      setsCombo();

    elseif extraStones then
      fetchTotalCombos3();
      threeStoneCombo();

      if #oreNodes >= 4 then -- Only try 4-stone combos if there were at least four 3-stone combos, otherwise there aren't any possible
        fetchTotalCombos4();
        worked = 0; -- Reset worked back to 0, before doing 4 stone combos
        fourStoneCombo();
      end

    else
      fetchTotalCombos3();
      threeStoneCombo();
    end

    miningTime = lsGetTimer() - startMiningTime;
    miningTimeTotal =  miningTimeTotal + miningTime;
    timesworked = timesworked + 1;

    lsSleep(1000); -- Delay not required, just gives a slight chance to see the last node worked on GUI, from updateGUI(), before it disappears off screen

    if not muteSoundEffects then
        lsPlaySound("beepping.wav");
    end

    if autoWorkMine then
        workMine();
    end
    TakeOreWindowRefresh();
    reset();
end


function workMine()
    if noMouseMove then
      srClickMouseNoMove(mineX, mineY);
      lsSleep(clickDelay);
      clickAllText("Work this Mine", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)
    else
      srSetMousePos(mineX, mineY);
      lsSleep(clickDelay);
      --Send 'W' key over Mine to Work it (Get new nodes)
      srKeyEvent('W');
    end
    if writeLogFile then
      WriteLog("\nWorking Mine...");
    end
    sleepWithStatus(1000, "Working mine (Fetching new nodes)", nil, 0.7, "Refreshing Nodes");
    findClosePopUpOld();
end


function checkCloseWindows()
    -- Rare situations a click can cause a window to appear for a node, blocking the view to other nodes.
    -- This is a safeguard to keep random windows that could appear, from remaining on screen and blocking the view of other nodes from being selected.
    srReadScreen();
    lsSleep(10);
    local closeWindows = findAllImages("thisis.png");

    if #closeWindows > 0 then
        for i=#closeWindows, 1, -1 do
            -- 2 right clicks in a row to close window (1st click pins it, 2nd unpins it
            srClickMouseNoMove(closeWindows[i][0]+5, closeWindows[i][1]+10, true);
            lsSleep(100);
            srClickMouseNoMove(closeWindows[i][0]+5, closeWindows[i][1]+10, true);
        end
        lsSleep(10);
    end
end


function reset()
    getPoints();
    if manualSets then
      getTraits();
      findSets();
    end
    clickSequence();
end


function checkAbort()
    if lsControlHeld() and lsAltHeld() then
        sleepWithStatus(750, "Aborting ...");
        reset();
    end
end


function findClosePopUp()
    chatRead();
    lastLineFound = lastLineParse;
    lastLineFound2 = lastLineParse2;
    startTime = lsGetTimer();

    while 1 do
        checkBreak();
        chatRead();
        OK = srFindImage("OK.png");

        if clickDelay < minPopSleepDelay then
            popSleepDelay = minPopSleepDelay;
        else
            popSleepDelay = clickDelay
        end

        if OK then
            srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
            lsSleep(popSleepDelay);
            logResult = "Found Popup (No Ore Gathered)"
            break;
        end

	  if ore == "Silver" then
	    chatReadTimeOut = chatReadTimeOutSilver; -- Since Silver gets 1,2 ore commonly back to back, then wait less time to timeout.
	  end

         --If we gathered new ore, add to tally, we're not going to get a popup.
	  if (lastLineFound2 ~= lastLineParse2) or (lastLineFound ~= lastLineParse) or ( (lsGetTimer() - startTime) > chatReadTimeOut )  then


	  if ( (lsGetTimer() - startTime) > chatReadTimeOut ) then
	    logResult = "Timed Out (Same ore gathered as previous time?) "
	  else
	    logResult = "Normal Break "
	  end


--Assuming server lag isn't going crazy, we didn't get a popup, so we're going to assume we got the same ore amount as last time (macro could not detect a change in last lines)
--Also check if oreGathered isn't nil. In a rare case, two or more stones might break causing multiple Found Coal/Gems back to back. oreGathered would not be found within last 2 lines on main chat

		if oreFound and oreGathered ~= nil then
              oreGatheredTotal = oreGatheredTotal + oreGathered;
              oreGatheredLast = oreGatheredLast + oreGathered;
              logResult = logResult .. "[Ore Gathered: " .. oreGathered .. "]  [oreGatheredLast: " .. math.floor(oreGatheredLast) .. "]  [oreGatheredTotal: " .. math.floor(oreGatheredTotal) .. "]";
		end
            lsSleep(popSleepDelay);
            break;
        end
    lsSleep(10);
    end
end


function findClosePopUpOld()
    while 1 do
        checkBreak();
        srReadScreen();
        lsSleep(10);
        OK = srFindImage("OK.png");
        if OK then
            srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
            lsSleep(clickDelay);
        else
            break;
        end
    end
end


function checkIfMain(chatText)
    for j = 1, #chatText do
        if string.find(chatText[j][2], "^%*%*", 0) then
            return true;
        end
    end
    return false;
end


function chatRead()
    srReadScreen();
    local chatText = getChatText();
    local onMain = checkIfMain(chatText);

    if not onMain then
        if not muteSoundEffects then
            lsPlaySound("timer.wav");
        end
    end

    -- Wait for Main chat screen and alert user if its not showing
    while not onMain do
        checkBreak();
        srReadScreen();
        chatText = getChatText();
        onMain = checkIfMain(chatText);
        sleepWithStatus(100, "Looking for Main chat screen ...\n\nIf main chat is showing, then try typing /afk twice in chat.", nil, 0.7);
    end

   -- Verify chat window is showing minimum 2 lines
   while #chatText < 2 do

   	checkBreak();
      srReadScreen();
      chatText = getChatText();
      sleepWithStatus(500, "Error: We must be able to read at least the last 2 lines of main chat!\n\nCurrently we only see " .. #chatText .. " lines ...\n\nYou can overcome this error by typing something in main chat.", nil, 0.7);
   end


   --Read last line of chat and strip the timer ie [01m]+space from it.
   lastLine = chatText[#chatText][2];
   lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));
   --Read next to last line of chat and strip the timer ie [01m]+space from it.
   lastLine2 = chatText[#chatText-1][2];
   lastLineParse2 = string.sub(lastLine2,string.find(lastLine2,"m]")+3,string.len(lastLine2));

	if string.sub(lastLineParse, 1, 17) == "You got some coal" or string.sub(lastLineParse2, 1, 17) == "You got some coal" then
	  oreFound = true;
	  oreGathered = string.match(lastLine2, "(%d+) " .. ore);
	  findBrokenStone() -- Do pixel checks and find which nodes have poofed.
	elseif string.sub(lastLineParse, 1, 13) == "Your workload" then
	  --TESTING : Comment below 2 lines if you want to test this macro on a Sand Mine (Select: Iron), to see nodes break more quickly and test if it detects nodes are breaking, easier (brokenStoneCheck).
	  oreFound = true;
	  oreGathered = string.match(lastLine, "(%d+) " .. ore);
	else
	  oreFound = nil;
	end
end


function promptDelays()
    local is_done = false;
    local count = 1;
    while not is_done do
        checkBreak();
        local y = 10;
        lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff,
            "Key or Mouse to Select Nodes:");
        y = y + 35;
        lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
        dropdown_cur_value_key = readSetting("dropdown_cur_value_key",dropdown_cur_value_key);
        dropdown_cur_value_key = lsDropdown("thisKey", 15, y, 0, 320, dropdown_cur_value_key, dropdown_key_values);
        writeSetting("dropdown_cur_value_key",dropdown_cur_value_key);
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
        y = y + 20;
        lsPrint(10, y, 0, 0.67, 0.67, 0xffffffff, "How many Nodes?");
        y = y + 50;
        lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
        dropdown_ore_cur_value = readSetting("dropdown_ore_cur_value",dropdown_ore_cur_value);
        dropdown_ore_cur_value = lsDropdown("thisOre", 15, y, 0, 320, dropdown_ore_cur_value, dropdown_ore_values);
        writeSetting("dropdown_ore_cur_value",dropdown_ore_cur_value);
        y = y + 35;
        lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Node Click Delay (ms):");
        y = y + 22;
        clickDelay = readSetting("clickDelay",clickDelay);
        is_done, clickDelay = lsEditBox("clickDelay", 15, y, 0, 50, 30, 1.0, 1.0, 0x000000ff, clickDelay);
        clickDelay = tonumber(clickDelay);
        if not clickDelay then
            is_done = false;
            lsPrint(75, y+6, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
            clickDelay = 100;
        end
        writeSetting("clickDelay",clickDelay);
        y = y + 40;
        lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Total Ore Found Starting Value:");
        y = y + 22;
        is_done, oreGatheredTotal = lsEditBox("oreGatheredTotal", 15, y, 0, 80, 30, 1.0, 1.0, 0x000000ff, 0);
        oreGatheredTotal = tonumber(oreGatheredTotal);
        if not oreGatheredTotal then
            is_done = false;
            lsPrint(105, y+6, 20, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
            oreGatheredTotal = 0;
        end
        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
        y = y - 15;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Node Delay: Pause between selecting each node.");
        y = y + 16;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Raise value to run slower (try increments of 25)");
        y = y + 20;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Total Ore Starting Value: Useful to keep track of");
        y = y + 16;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "ore already in the mine. Set to value of ore in mine");
        y = y + 22;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "Dual Monitor: Don\'t move mouse over nodes.");
        y = y + 16;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "instead rightClick nodes and click menus.");
        y = y + 16;
        lsPrint(10, y, 0, 0.6, 0.6, 0xffffffff, "This lets you move mouse on second monitor.");
        y = y + 22;
        if ButtonText(10, lsScreenY - 30, 0, 70, 0xFFFFFFff, "Next") then
            is_done = 1;
        end

        if cancelButton == 1 then
            if ButtonText(115, lsScreenY - 30, 0, 80, 0xFFFFFFff, "Cancel") then
                getPoints();
                cancelButton = 0;
            end
        end

        if ButtonText(205, lsScreenY - 30, 0, 110, 0xFFFFFFff,
            "End script") then
            error "Clicked End Script button";
        end
        lsDoFrame();
        lsSleep(10);
    end
    return count;
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function DecimalsToMinutes(dec)
  local ms = tonumber(dec)
  if ms >= 60 then
    return math.floor(ms / 60).."m ".. math.floor(ms % 60) .. "s";
  else
    return math.floor(ms) .. "s";
  end
end


function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function TakeOreWindowRefresh()
 findAllOre = findText("All Ore");
 findAllMetal = findText("All Metal"); -- Silver Mines give metal, not Ore. This check is for Silver Mines.

	if findAllOre then
		if not autoWorkMine then
	         sleepWithStatus(1000, "Refreshing pinned Ore menu ..."); -- Let pinned window catchup. If autowork mine, there is already a 1000 delay on workMine()
		end
	 safeClick(findAllOre[0],findAllOre[1]);
	end
	if findAllMetal then
		if not autoWorkMine then
	         sleepWithStatus(1000, "Refreshing pinned Metal menu ..."); -- Let pinned window catchup. If autowork mine, there is already a 1000 delay on workMine()
		end
	 safeClick(findAllMetal[0],findAllMetal[1]);
	end
end


function updateGUI(i,j,k,l)
                local y = 10;
                lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to End this script.");
                y = y +15
                lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to Pause this script.");
                y = y +35
                if l ~= nil then -- this is l (lower cased L), not 1 (number one), l is the 4th node from a 4 stone combo (i,j,k,l)
                  lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. ", " .. l);
                else -- We're doing a 3 stone combo (i,j,k)
                  lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "[" .. worked .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k);
                end
                y = y + 20;
                lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Node Click Delay: " .. clickDelay .. " ms");
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Last 'Nodes Worked' Time: " .. round((setTime/100)/10,2) .. "s");
                y = y + 16;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Mine Worked: " .. timesworked .. " times");
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Current Time Elapsed:   " .. DecimalsToMinutes(elapsedTime/1000));
                y = y + 16;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Previous Time Elapsed: " .. miningTimeGUI);
                y = y + 16;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffffffff, "Average Time Elapsed:  " .. avgMiningTimeGUI);
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0x40ffffff, "Current Ore Found: " .. comma_value(math.floor(oreGatheredLast)));
                y = y + 20;
                lsPrint(10, y, 0, 0.7, 0.7, 0x80ff80ff, "Total Ore Found:     " .. comma_value(math.floor(oreGatheredTotal)));
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xffff80ff, "Hold Ctrl+Alt to Abort and Return to Menu.");
                y = y + 32;
                lsPrint(10, y, 0, 0.7, 0.7, 0xff8080ff, "Don't touch mouse until finished!");
                y = y + 35;
                progressBar(y)

                if brokenStoneInfo ~= "" then
                  y = y + 20
                  lsPrintWrapped(10, y, 0, lsScreenX-20, 0.7, 0.7, 0xFFFFFFff, brokenStoneInfo);
                end

                lsDoFrame();
end


function threeStoneCombo()
  local skipWork = nil;
    for i=1,#clickList do
        for j=i+1,#clickList do
            for k=j+1,#clickList do
                --checkCloseWindows();
                findClosePopUpOld(); --Extra precaution to check for remaining popup before working the nodes


if #brokenStones > 0 then
	for z=1, #brokenStones do
	  if brokenStones[z] == i or brokenStones[z] == j or brokenStones[z] == k then
	    skipWork = 1
	    brokenStoneInfo = "Broken Nodes: " .. table.concat(brokenStones,", ") .. "\nSkipping " .. i .. ", " .. j .. ", " .. k;
	  else
	    skipWork = nil
	  end
	end
end


if not skipWork then

                startSetTime = lsGetTimer();

                if noMouseMove then -- Check for dual monitor option - don't move mouse cursor over each node and send keyEvents. Instead do rightClick popup menus

                -- 1st Node
                checkBreak();
                checkAbort();
                srClickMouseNoMove(clickList[i][1], clickList[i][2], 1);
                lsSleep(clickDelay);
                clickAllText("[A]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                -- 2nd Node
                checkBreak();
                checkAbort();
                srClickMouseNoMove(clickList[j][1], clickList[j][2], 1);
                lsSleep(clickDelay);
                clickAllText("[A]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                -- 3rd Node
                checkBreak();
                checkAbort();
                srClickMouseNoMove(clickList[k][1], clickList[k][2], 1);
                lsSleep(clickDelay);
                clickAllText("[S]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                else -- noMouseMove is false

                -- 1st Node
                checkBreak();
                checkAbort();
                srSetMousePos(clickList[i][1], clickList[i][2]);
                lsSleep(clickDelay);
                srKeyEvent('A');

                -- 2nd Node
                checkBreak();
                checkAbort();
                srSetMousePos(clickList[j][1], clickList[j][2]);

                lsSleep(clickDelay);
                srKeyEvent('A');

                -- 3rd Node
                checkBreak();
                checkAbort();
                srSetMousePos(clickList[k][1], clickList[k][2]);
                lsSleep(clickDelay);
                srKeyEvent('S');
                end -- end noMouseMove check


                findClosePopUp();
                elapsedTime = lsGetTimer() - startMiningTime;
                setTime = lsGetTimer() - startSetTime;


end

			if writeLogFile then
			  if skipWork then
			    lsPlaySound("start.wav");  -- Audible alert that we are skipping this workload
			    WriteLog("[" .. worked+1 .. "/" .. TotalCombos .. "] Skipping Broken Node Combo (Broken Node(s) = " .. table.concat(brokenStones,", ") .. "): " .. i .. ", " .. j .. ", " .. k);
			  elseif not OK then
			    logResult = logResult .. "\n\n---- Last 2 Lines BEFORE Nodes Worked ----\n** " .. lastLineFound2 .. "\n** " .. lastLineFound .. "\n\n---- Last 2 Lines AFTER Nodes Worked ----\n** " .. lastLineParse2 .. "\n** " .. lastLineParse .. "\n";
			    WriteLog("\n[" .. worked+1 .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. " - Result: " .. logResult);
			  else
			    WriteLog("[" .. worked+1 .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. " - Result: " .. logResult);
			  end
			  logResult = "";
			end

                worked = worked + 1
                updateGUI(i,j,k);
                if not OK then
                  oreNodes[#oreNodes + 1] = {i, j, k};
                end
            end
        end
    end
			  parseOreNodes()
end




function fourStoneCombo()
  local skipWork = nil;
    for a=1,#oreNodes4 do
                findClosePopUpOld(); --Extra precaution to check for remaining popup before working the nodes

                i = oreNodes4[a][1]
                j = oreNodes4[a][2]
                k = oreNodes4[a][3]
                l = oreNodes4[a][4]


if #brokenStones > 0 then
	for z=1, #brokenStones do
	  if brokenStones[z] == i or brokenStones[z] == j or brokenStones[z] == k or brokenStones[z] == l then
	    skipWork = 1
	    brokenStoneInfo = "Nodes: " .. table.concat(brokenStones,", ") .. " are broken\nSkipping " .. i .. ", " .. j .. ", " .. k .. ", " .. l;
	  else
	    skipWork = nil
	  end
	end
end


if not skipWork then

                startSetTime = lsGetTimer();

                if noMouseMove then -- Check for dual monitor option - don't move mouse cursor over each node and send keyEvents. Instead do rightClick popup menus

                -- 1st Node
                checkBreak();
                checkAbort();
                --srSetMousePos(0,180); -- Move mouse to near top right corner (below icons), once, to hopefully make node popup menus appear there.
                --lsSleep(100);
                srClickMouseNoMove(clickList[oreNodes4[a][1]][1], clickList[oreNodes4[a][1]][2]);
                lsSleep(clickDelay);
                clickAllText("[A]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                -- 2nd Node
                checkBreak();
                checkAbort();
                srClickMouseNoMove(clickList[oreNodes4[a][2]][1], clickList[oreNodes4[a][2]][2]);
                lsSleep(clickDelay);
                clickAllText("[A]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                -- 3rd Node
                checkBreak();
                checkAbort();
                srClickMouseNoMove(clickList[oreNodes4[a][3]][1], clickList[oreNodes4[a][3]][2]);
                lsSleep(clickDelay);
                clickAllText("[A]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                 -- 4th Node
                checkBreak();
                checkAbort();
                srClickMouseNoMove(clickList[oreNodes4[a][4]][1], clickList[oreNodes4[a][4]][2]);
                lsSleep(clickDelay);
                clickAllText("[S]", 20, 2, 1); -- offsetX, offsetY, rightClick (1 = true)

                else -- noMouseMove is false

                -- 1st Node
                checkBreak();
                checkAbort();
                srSetMousePos(clickList[oreNodes4[a][1]][1], clickList[oreNodes4[a][1]][2]);
                lsSleep(clickDelay);
                srKeyEvent('A');

                -- 2nd Node
                --checkBreak();
                checkAbort();
                srSetMousePos(clickList[oreNodes4[a][2]][1], clickList[oreNodes4[a][2]][2]);

                lsSleep(clickDelay);
                srKeyEvent('A');

                -- 3rd Node
                checkBreak();
                checkAbort();
                srSetMousePos(clickList[oreNodes4[a][3]][1], clickList[oreNodes4[a][3]][2]);
                lsSleep(clickDelay);
                srKeyEvent('A');

                 -- 4th Node
                checkBreak();
                checkAbort();
                srSetMousePos(clickList[oreNodes4[a][4]][1], clickList[oreNodes4[a][4]][2]);
                lsSleep(clickDelay);
                srKeyEvent('S');

                end -- end noMouseMove check

                findClosePopUp();
                elapsedTime = lsGetTimer() - startMiningTime;
                setTime = lsGetTimer() - startSetTime;


end


			if writeLogFile then
			  if skipWork then
			    lsPlaySound("start.wav");  -- Audible alert that we are skipping this workload
			    WriteLog("[" .. worked+1 .. "/" .. TotalCombos .. "] Skipping Broken Node Combo (Broken Node(s) = " .. table.concat(brokenStones,", ") .. "): " .. i .. ", " .. j .. ", " .. k .. ", " .. l);
			  elseif not OK then
			    logResult = logResult .. "\n\n---- Last 2 Lines BEFORE Nodes Worked ----\n** " .. lastLineFound2 .. "\n** " .. lastLineFound .. "\n\n---- Last 2 Lines AFTER Nodes Worked ----\n** " .. lastLineParse2 .. "\n** " .. lastLineParse .. "\n";
			    WriteLog("\n[" .. worked+1 .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. ", " .. l .. " - Result: " .. logResult);
			  else
			    WriteLog("[" .. worked+1 .. "/" .. TotalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k .. ", " .. l .." - Result: " .. logResult);
			  end
			  logResult = "";
			end

                worked = worked + 1
                updateGUI(i,j,k,l);
    end
end


function setsCombo()
	for i=1, #sets do
		for j=1, #sets[i] do
                findClosePopUpOld(); --Extra precaution to check for remaining popup before working the nodes
                startSetTime = lsGetTimer();

                if j == #sets[i] then
                  key = "S"
                else
                  key = "A"
                end

                node = sets[i][j];
                x = clickList[node][1]
                y = clickList[node][2]
                srSetMousePos(x,y)
                lsSleep(clickDelay);
                srKeyEvent(key);
                w = sets[i][1]
                x = sets[i][2]
                y = sets[i][3]
                z = sets[i][4]
		end -- for j

                findClosePopUp();
                elapsedTime = lsGetTimer() - startMiningTime;
                setTime = lsGetTimer() - startSetTime;
			if writeLogFile then
			  if #sets[i] == 4 then
			    WriteLog("[" .. worked+1 .. "/" .. TotalCombos .. "] Nodes Worked: " .. w .. ", " .. x .. ", " .. y .. ", " .. z);
			  else -- else it's 3 nodes
			    WriteLog("[" .. worked+1 .. "/" .. TotalCombos .. "] Nodes Worked: " .. w .. ", " .. x .. ", " .. y);
			  end
			end
                worked = worked + 1
                updateGUI(w,x,y,z);
	end -- for i
end


function compareColorEx(left, right, rgbTol, hueTol)
	local leftRgb = parseColor(left);
	local rightRgb = parseColor(right);
	local i;
	local d;
	local rgbTotal = 0;
	local hueTotal = 0;
	for i = 0, 2 do
		-- Compare raw RGB values
		d = leftRgb[i] - rightRgb[i];
		rgbTotal = rgbTotal + (d * d);
		if(rgbTotal > rgbTol) then
			return false;
		end
		-- Compare hue
		if(i < 2) then
			d = (leftRgb[i] - leftRgb[i+1]) - (rightRgb[i] - rightRgb[i+1]);
			hueTotal = hueTotal + (d * d);
		else
			d = (leftRgb[i] - leftRgb[0]) - (rightRgb[i] - rightRgb[0]);
			hueTotal = hueTotal + (d * d);
		end
		if(hueTotal > hueTol) then
			return false;
		end
	end
	return true;
end


function parseColor(color)
	local rgb = {};
	local c = color / 256;
	rgb[0] = math.floor(c / 65536);
	c1 = c - (rgb[0] * 65536);
	if(rgb[0] < 0) then
		rgb[0] = rgb[0] + 256;
	end
	rgb[1] = math.floor(c1 / 256);
	rgb[2] = math.floor(c1 - (rgb[1] * 256));
	return rgb;
end


function WriteLog(Text)
	logfile = io.open("mining_ore_Logs.txt","a+");
	logfile:write(Text .. "\n");
	logfile:close();
end


function getTraits()
  minesB = {}
  trait=1;
  traits_done = nil;
  trait_value = 1;

  while not traits_done do
    checkBreak()
    local z = 0;
    local y = 2;
    y = 40;

      for i=1,#clickList do

        for j=1,#minesB do
	    if minesB[j][1] == i then
	      lsPrint(150, y, 0, 0.7, 0.7, 0xFFFFFFff, minesB[j][2] .. ":" .. minesB[j][3]);
	    end
        end --end j

	  lsPrint(50, y, 0, 0.7, 0.7, 0xFFFFFFff, "Node " .. i);

	  if ButtonText(110, y, z, 50, 0xFFFFFFff, "Set", 0.7, 0.7) then
	      isSet = nil
	      for j=1,#minesB do
	          if minesB[j][1] == i and minesB[j][1] ~= nil then
	            isSet = 1
	          end
	      end
	      if not isSet then
	        minesB[#minesB + 1] = {i, trait, trait_value}
	        index = i
	        mines[index].trait[trait] = trait_value;
	      end
	  end


	  if ButtonText(10, y, z, 40, 0xFFFFFFff, "PM", 0.7, 0.7) then
	    while lsMouseIsDown() do
	      lsPrintWrapped(10, 10, z, lsScreenX - 20, 0.7, 0.7, 0xf2f2f2ff, "Point Mouse to Node " .. i .. "\n\nRelease Mouse Button to continue ...");
	      lsDoFrame()
	      lsSleep(16)
	    end
	    srSetMousePos(clickList[i][1], clickList[i][2])
	  end
          y = y + 20;


	end --end i


			if ButtonText(5, lsScreenY - 100, 1, 120, 0xFFFFFFff, "Next Value", 0.7, 0.7) then
			  trait_value = trait_value + 1;
			end

			if ButtonText(5, lsScreenY - 75, 1, 120, 0xFFFFFFff, "Next Trait", 0.7, 0.7) then
				if not allMinesHaveTrait(trait) then
					lsMessageBox("Trait not done", "You have not finished assigning values to all ore stones for this trait.");
				else
					trait = trait + 1;
					trait_value = 1;
				end
			end

			if trait > 1 then
			  if ButtonText(5, lsScreenY - 50, 1, 120, 0xFFFFFFff, "Prev Trait", 0.7, 0.7) then
				trait = trait - 1;
				trait_value = 1;
			  end
			end

			if ButtonText(5, lsScreenY - 25, 1, 220, 0xFFFFFFff, "Done assigning traits", 0.7, 0.7) then
				traits_done = true;
			end



    lsPrintWrapped(10, 2, z, lsScreenX - 20, 0.7, 0.7, 0xf2f2f2ff, "Trait #" .. trait .. ", value #" .. trait_value .. "\nClick all matching ore stones");
    lsDoFrame()
    lsSleep(10);
  end -- while not traits_done
end


function findSets()
	local set_min_size = 3; -- Number of ore stones needed to make a set?
	-- find all sets
	statusScreen("Searching for sets (this may take a while)", 0xFFFFFFff, "no break");
	num_traits = trait;
	sets = {};
	count = 0;
	for set_size = set_min_size, #mines do
		local found_one_at_this_size = false;
		set = {};
		for i=1, set_size do
			set[i] = i;
		end

		while set do

			count = count + 1;

			if count == 1000 then
				count = 0;
				lsPrintln(set_to_string(set) .. " found " .. #sets .. " so far.");
			end

			if is_valid_set(set) then
				if is_matching_set(set) then
					sets[#sets + 1] = set;
					found_one_at_this_size = true;
				end
			end

			set = increment_set(set);
		end
		if not found_one_at_this_size then
			break;
		end
	end

	-- display results

	while true do
		if #sets == 0 then
			statusScreen("NO matching sets", 0xFFFFFFff, "no break");
		else
			statusScreen("Matching sets", 0xFFFFFFff, "no break");
		end
		lsScrollAreaBegin("ResultsScroll", 0, 100, 0, lsScreenX - 50, lsScreenX - 110)
		for i=1, #sets do
			lsPrint(0, (i-1)*20, 3, 1, 1, 0xFFFFFFff, set_to_string(sets[i]));
		end
		lsScrollAreaEnd(#sets*20);
		--lsScrollAreaEnd(lsScreenY-50);

        if ButtonText(10, lsScreenY - 30, z, 110, 0xFFFFFFff, "GO") then
          break;
        end
	lsSleep(10);
	end
end


function is_valid_set(set)
	local used = {};
	local last = 0;
	for i=1, #set do
		if set[i] <= last then
			return false;
		end
		last = set[i];
	end
	return true;
end


function is_matching_set(set)
	for i=1, num_traits do
		local match=false;
		local unmatch=false;
		for j=2, #set do
			for k=1, j-1 do
				if mines[set[j]].trait[i] == mines[set[k]].trait[i] then
					match = true;
				else
					unmatch = true;
				end
			end
		end
		if match and unmatch then
			return false;
		end
	end
	return true;
end


function increment_set(set)
	local newset = {};
	for i=1, #set do
		newset[i] = set[i];
	end
	set = newset;
	local index = #set;
	while true do
		if set[index] == #mines then
			if index == 1 then
				return nil;
			end
			set[index] = 1;
			index = index - 1;

		else
			set[index] = set[index] + 1;
			return set;
		end
	end
end


function set_to_string(set)
	local ret = "";
	for i=1, #set do
		ret = ret .. "  " .. set[i];
	end
	return ret;
end


function allMinesHaveTrait(trait_num)
	for i=1, #mines do
		if not mines[i].trait[trait_num] then
			return false;
		end
	end
	return true;
end


function progressBar(y)
  local barWidth = 220;
  local barTextX = (barWidth - 22) / 2
  local barX = 10;
  local percent = round(worked / TotalCombos * 100,2) 
  local progress = ( (barWidth-4) / TotalCombos) * worked
  if progress < barX+6 then
    progress = barX+6
  end
  if math.floor(percent) <= 25 then
    progressBarColor = 0x669c35FF
  elseif math.floor(percent) <= 50 then
    progressBarColor = 0x77bb41FF
  elseif math.floor(percent) <= 65 then
    progressBarColor = 0x96d35fFF
  elseif math.floor(percent) <= 72 then
    progressBarColor = 0xdced41FF
  elseif math.floor(percent) <= 79 then
    progressBarColor = 0xe9ea18FF
  elseif math.floor(percent) <= 83 then
    progressBarColor = 0xf8be0cFF
  elseif math.floor(percent) <= 92 then
    progressBarColor = 0xff7567FF
  elseif math.floor(percent) <= 99 then
    progressBarColor = 0xff301bFF
  else
    progressBarColor = 0xe3c6faFF
  end
  lsPrint(barTextX, y+3.5, 15, 0.60, 0.60, 0x000000ff, percent .. " %");
  lsDrawRect(barX, y, barWidth, y+20, 5,  0x3a88feFF); -- blue shadow
  lsDrawRect(barX+2, y+2, barWidth-2, y+18, 10,  0xf6f6f6FF); -- white bar background
  lsDrawRect(barX+4, y+4, progress, y+16, 15,  progressBarColor); -- colored progress bar
end


function findBrokenStone()
  --sleepWithStatus(100, "Searching for Broken Nodes", nil, 0.7);
  findClosePopUpOld(); -- Double check for any leftover popups that might be covering a node and prevent proper detection
  brokenStones = {} -- Flush array
  for i=1, #clickList do
    thisColor = srReadPixel(clickList[i][1], clickList[i][2])
      if(not compareColorEx(thisColor, clickListColor[i][1], rgbTol, hueTol)) then
      table.insert(brokenStones, i);
      end -- if(not compare...
  end -- for i

    if writeLogFile and #brokenStones > 1 then
      -- Plural
      WriteLog("\n**** Found Coal/Gem message (within past 2 lines - Recheck pixel check on ALL nodes)!\nNodes: " .. table.concat(brokenStones,", ") .. " are no longer present.\n")
      -- Singular
    elseif writeLogFile and #brokenStones == 1 then
      WriteLog("\n**** Found Coal/Gem message! Node: " .. table.concat(brokenStones,", ") .. " is no longer present.\n")
    end
end


function parseOreNodes()
  if writeLogFile then WriteLog("\n**** " .. #oreNodes .. "/" .. TotalCombos .. " Combos produced Ore:") end;
    for a=1, #oreNodes do
      if writeLogFile then WriteLog("{" .. oreNodes[a][1] .. ", " .. oreNodes[a][2] .. ", " .. oreNodes[a][3] .. "},") end;
    end
end


function parseOreNodesFour()
  if writeLogFile then WriteLog("\n**** " .. #oreNodesFour " 4 Stone Combos produced Ore:") end;
    for a=1, #oreNodesFour do
      if writeLogFile then WriteLog(oreNodesFour[a][1] .. ", " .. oreNodesFour[a][2] .. ", " .. oreNodesFour[a][3] .. ", " .. oreNodesFour[a][4]) end;
    end
end


--------------------- Credits: Ashen for below Functions

function equalset(a, b)
    if not #a == #b then
        return false;
    end
    for i=1,#a do
        local found = false;
        for j=1,#b do
            if (b[j] == a[i]) then
                found = true;
                break;
            end
        end
        if not found then
            return false;
        end
    end
    return true;
end


function wasThreeSetValid(a, b, c)
    local s = {a, b, c};
    for i=1, #oreNodes do
        if equalset(s, oreNodes[i]) then
            return true;
        end
    end
    return false
end


function isFourSetValid(a, b, c, d)
    if not wasThreeSetValid(a, b, c) then
       return false;
    end
    if not wasThreeSetValid(a, b, d) then
       return false;
    end
    if not wasThreeSetValid(b, c, d) then
       return false;
    end
    if not wasThreeSetValid(a, c, d) then

       return false;
    end
    return true;
end

--------------------- 
