-- Acrobat Master v2.1 by Cegaiel
--
-- Immediately upon Starting:
-- Searches your acro menu for all of your acro buttons. It will not include acro move names on the list, that is not inside of a button.
-- Displays your available moves in a list with a checkbox beside each one. If checked, it will click the move while acroing. Unchecked, it will be skipped.
-- Set how many times you want to do each checked acro move.
--
-- While acroing:
-- Click Next button while acroing to skip the current move and go to next one. Idea if your partner is following this move or enough facets have been taught.
-- Click Menu button to stop acroing and go back to your list.
-- Go back to Menu, click Refresh when you have a new partner, to refresh the buttons
--
-- While in Menu:
-- Point mouse over your partner and Tap Shift to quickly Ask to Acro (Tests, The Human Body, Test of the Acrobat, Ask to Acro menus)


dofile("common.inc");

askText = "Acrobat Master v2.1 by Cegaiel\n \nWait until you have Acrobat window open, from a partner, (won\'t work with Self Click, Acrobat, Show Moves) before you start macro! It will memorize your moves for future partners (even if you close acro window). You can move acro window while its running. You do not need to quit/restart macro between each partner. Click \"Menu\" button, when you are done acroing the current player. Optionally, click \"Refresh\" button when your next partner\'s acro window is open. Make sure you resize the acro window so all the buttons you know are showing (above divider bar). Press Shift over ATITD window to continue.";


moveImages = {
"Asianinfluence.png",
"Broadjump.png",
"Cartwheels.png",
"Catstretch.png",
"Clappingpushups.png",
"Crunches.png",
"Fronttuck.png",
"Handplant.png",
"Handstand.png",
"Invertedpushups.png",
"Jumpsplit.png",
"Jumpingjacks.png",
"Kickup.png",
"Legstretch.png",
"Lunge.png",
"Pinwheel.png",
"Pushups.png",
"Rearsquat.png",
"Roundoff.png",
"Runinplace.png",
"Sidebends.png",
"Somersault.png",
"Spinflip.png",
"Squats.png",
"Squatthrust.png",
"Toetouches.png",
"Widesquat.png",
"Windmill.png",
};


moveNames = {
"Asian Influence",
"Broad Jump",
"Cartwheels",
"Cat Stretch",
"Clapping Push-Ups",
"Crunches",
"Front Tuck",
"Handplant",
"Handstand",
"Inverted Pushups",
"Jump Split",
"Jumping Jacks",
"Kick-Up",
"Leg Stretch",
"Lunge",
"Pinwheel",
"Push-Ups",
"Rear Squat",
"Roundoff",
"Run in Place",
"Side Bends",
"Somersault",
"Spin Flip",
"Squats",
"Squat Thrust",
"Toe Touches",
"Wide Squat",
"Windmill",
};

moveShortNames = {
"AI",
"BJ",
"CW",
"CS",
"CPU",
"CR",
"FT",
"HP",
"HS",
"IPU",
"JS",
"JJ",
"KU",
"LS",
"LU",
"PW",
"PU",
"RS",
"RO",
"RIP",
"SB",
"SS",
"SF",
"SQ",
"ST",
"TT",
"WS",
"WM",
};

startTime = 0;
perMoves = 6; 
perMovesAuto = 5; --Default Minutes to alot to each partner
moveDelay = 7500; -- How many ms to wait to perform between each move to your partner.
debugClickMoves = nil; -- Change to true to make mouse point to where it's clicking. Change to nil to disable.


function doit()
  askForWindow(askText);
  totalSession = lsGetTimer();
  findMoves();
  checkAllBoxes();
  displayMoves();
end


function findMoves()
  lsDoFrame();
  statusScreen("Scanning Acro Buttons ...", nil, 0.7);
  foundMovesName = {};
  foundMovesImage = {};
  foundMovesShortName = {};
  local message = "";


  --See if the acro bar (middle border on Acro window) is found.  If not, then just set Y to screenHeight
  --Moves above the acro bar are moves that your partner does not know yet. Moves below are moves your partner already knows.  Attempt to exclude those.
  srReadScreen();
  barFound = srFindImage("acro/acro_bar.png");

  if barFound then
    acroY = barFound[1];   -- set Y position of the middle border
    message = message .. "\n\nDIVIDER BAR FOUND!\n\nIgnoring moves below the border...";
  else
    atitdY = srGetWindowSize();
    acroY = atitdY[1];   -- No middle border found, so just use ATITD screen height
  end

  for i=1,#moveNames do
    checkBreak();
    srReadScreen();
    local found = srFindImage("acro/" .. moveImages[i]);
    if found then
      moveY = found[1];
    end
    if found and (moveY > acroY) then  --Button found, but below middle border, skip it (this means your partner already knows the move, too.
      statusScreen("Scanning acro buttons...\n\nSkipping: " .. moveNames[i] .. message, nil, 0.7);
    end

    if found and (moveY < acroY) then
      foundMovesName[#foundMovesName + 1] = moveNames[i];
      foundMovesImage[#foundMovesImage + 1] = moveImages[i];
      foundMovesShortName[#foundMovesShortName + 1] = moveShortNames[i];
      statusScreen("Scanning acro buttons...\n\nFound: " .. moveNames[i] .. message, nil, 0.7);
      lsSleep(10);
    end
  end

  --if #foundMovesName == 0 then
    --error 'No acro moves found, aborted.';
  --end
end


function doMoves()
  local skip = false;
  local now = 0;
  local lastClick = 0;
  local GUI = "";
  local skipNotification = nil;
  startTime = lsGetTimer();

  for i=1,checkedBoxes do
    checkBreak();

    for j=1,perMoves do
      checkBreak();
      skipNotification = nil;

      if skip then
        if j ~= 1 then
          break;
        else
          skip = false;
        end
      end

      local acroTimer = true;
      while acroTimer do
        checkBreak();
        now = lsGetTimer();

        if lsButtonText(10, lsScreenY - 30, z, 75, 0xffff80ff, "Menu") then
          sleepWithStatus(1500, "Returning to Menu !", nil, 0.7)
          displayMoves();
        end

        if lsButtonText(100, lsScreenY - 30, z, 75, 0xff8080ff, "Skip") then

          if j == 1 then
            skipNotification = true;
          else
            skip = true;
          end

          if j == 1 then
            nextMove = checkedMovesName[i];
          elseif i < tonumber(checkedBoxes) then
            nextMove = checkedMovesName[i+1];
          else
            nextMove = "Last Move (N/A)";
          end

        end -- if Skip button


        if ( (now - lastClick) < tonumber(moveDelay) ) then

          if skip or skipNotification then
            statusScreen("Move Delay: " .. math.floor(moveDelay - (now - lastClick)) .. "\n\nSkip Queued: " ..  string.upper(nextMove) .. GUI, nil, 0.7);
          else
            statusScreen("Move Delay: " .. math.floor(moveDelay - (now - lastClick)) .. "\n\nWaiting on Timer" .. GUI, nil, 0.7);
          end

        else

          if skip then
            break;
          end

          acroTimer = false;
          srReadScreen();
          clickMove = srFindImage("acro/" .. checkedMovesImage[i]);


          if clickMove and barFound and (clickMove[1] > acroY) then 
              -- Check if the button is below a found divider Bar.
              -- This suggests your partner has learned a new move while acroing and the button has moved below the bar. Skip and uncheck the box.
            status = "SKIPPING: " .. checkedMovesName[i] .. "\n\nBUTTON HAS MOVED BELOW BAR!\n\nUnchecking from Move List.\n\nPartner likely learned this move.";
            foundMovesShortName[i] = false
            sleepWithStatus(2000, status, nil, 0.7);
            skip = true;
          elseif clickMove then
            status = string.upper(checkedMovesName[i]);
            lastClick = lsGetTimer();
            if debugClickMoves then
              srSetMousePos(clickMove[0]+3, clickMove[1]+2);
            end
            srClickMouseNoMove(clickMove[0]+3, clickMove[1]+2);
          else
              -- This suggests your partner has learned a new move while acroing and the button has moved below the bar (but out of sight, furthur down in menu).
            status = "SKIPPING: " .. checkedMovesName[i] .. "\n\nBUTTON NOT FOUND!\n\nUnchecking from Move List.\n\nPartner likely learned this move";
            foundMovesShortName[i] = false
            sleepWithStatus(2000, status, nil, 0.7);
            skip = true;
          end -- if clickMove


          GUI = "\n\n" .. status .. "\n \n[" .. i .. "/" .. checkedBoxes .. "] Moves\n[" .. j .. "/" .. perMoves .. "] Clicked\n \nNote: Avatar animation might not keep up with macro. This is OK, each move clicked will still be recognized by your partner.\n\nClick Skip to advance to next move on list (ie partner follows the move).";

        end --if ( (now - lastClick) < tonumber(moveDelay) )
      end --while acroTimer
    end --for j
  end --for i

  if skip or skipNotification then
    -- We skipped on final move; Simply announce we're returning to menu, with short delay
    sleepWithStatus(1500, "\nALL DONE, RETURNING TO MENU ...\n" .. GUI , nil, 0.7)
  else
    -- Allow the full animation timer to finish before returning to menu.
    sleepWithStatus(tonumber(moveDelay), "ALL DONE, RETURNING TO MENU ...\n\nWaiting on Timer/Move Delay to finish" .. GUI , nil, 0.7)
  end

  displayMoves();
end


function processCheckedBoxes()
  checkedMovesName = {};
  checkedMovesImage = {};
  checkedMovesShortName = {};
  checkedBoxes = 0;
  lsDoFrame(); --Make screen blank to prevent a text fade from doMoves function
  for i=1,#foundMovesName do
    if foundMovesShortName[i] then
      checkedMovesName[#checkedMovesName + 1] = foundMovesName[i];
      checkedMovesImage[#checkedMovesImage + 1] = foundMovesImage[i];
      checkedMovesShortName[#checkedMovesShortName + 1] = foundMovesShortName[i];
      checkedBoxes = checkedBoxes + 1;
    end
  end

  if checkedBoxes == 0 then
    sleepWithStatus(2500, "No moves selected!\n\nAborting ...", nil, 0.7);
  else
    doMoves();
  end
end


function checkAllBoxes()
  for i=1,#foundMovesName do
    foundMovesShortName[i] = true;
  end
end


function uncheckAllBoxes()
  for i=1,#foundMovesName do
    foundMovesShortName[i] = false;
  end
end


function displayMoves()
  lsDoFrame();
  local foo;
  local is_done = nil;
  local finishTime = lsGetTimer();
  local seconds = 0;
  local minutes = 0;
  local totalCheckedMoves = 0


  if startTime ~= 0 then
    sessionTime = math.floor((finishTime - startTime)/1000);
    sessionTime = sessionTime - 1; -- subtract 1 second for the 1000ms sleepWithStatus delay that occurs before returning to menu.
  if sessionTime >= 60 then
    minutes = math.floor(sessionTime/60);
    seconds = math.floor(sessionTime - (minutes*60));
  else
    minutes = 0;
    seconds = sessionTime;
  end
  end

  if minutes == 0 and seconds == 0 then
    lastSession = "N/A"
  elseif minutes == 0 and seconds ~= 0 then
    lastSession = seconds .. " sec";
  else
    lastSession = minutes .. " min " .. seconds .. " sec";
  end


  while 1 do
    checkBreak()
    local y = 10;
    local tpmColor = 0xffffffff;
    local tpmColor2 = 0x99c2ffff;
    local perMovesColor = 0x99c2ffff;

    if timesPerMove then
      tpmColor = 0xff9933ff;
      tpmColor2 = 0xffbf80ff;
      perMovesColor = 0xffffffff;
      perMoves = math.floor(pms2)
    else
      perMoves = math.floor(perMoves)
    end

    lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);

    foo, moveDelay = lsEditBox("ms Delay per Move", 15, y, z, 70, 30, 0.7, 0.7,
                               0x000000ff, moveDelay);

    if not tonumber(moveDelay) then
      moveDelay = 0;
      is_done = nil;
      lsPrint(100, y, 0, 0.9, 0.9, 0xFF2020ff, "MUST BE A NUMBER!");
    else
      is_done = true;
      lsPrint(100, y+2, z, 0.9, 0.9, 0xf0f0f0ff, "ms (" .. round(moveDelay/1000,2) .. "s) between each Move Click");
    end

    y=y+30;

    foo, perMoves = lsEditBox("Time per Move", 15, y, z, 70, 30, 0.7, 0.7,
                              0x000000ff, perMoves);
    if not tonumber(perMoves) then
      perMoves = 0;
      is_done = nil;
      lsPrint(100, y, 0, 0.9, 0.9, 0xFF2020ff, "MUST BE A NUMBER!");
    else
      is_done = true;
      lsPrint(100, y+2, z, 0.9, 0.9, perMovesColor, "# Times to Repeat each Move");
    end

    y=y+30;

    foo, perMovesAuto = lsEditBox("perMovesAuto", 15, y, z, 70, 30, 0.7, 0.7,
                              0x000000ff, perMovesAuto);
    if not tonumber(perMovesAuto) then
      perMovesAuto = 0;
      is_done = nil;
      lsPrint(100, y, 0, 0.9, 0.9, 0xFF2020ff, "MUST BE A NUMBER!");
    else
      is_done = true;
      lsPrint(100, y+2, z, 0.9, 0.9, tpmColor, "OR Minutes alloted to Partner");
    end

    y = y + 30;

    pms2 = perMoves;
    if tonumber(perMovesAuto) and tonumber(moveDelay) and tonumber(perMoves) then
      pms =  60000 * perMovesAuto
      pms2 = pms/(totalCheckedMoves * moveDelay)
      autoMoveMessage = totalCheckedMoves .. " Moves (" .. round(moveDelay/1000,2) .. "s each) = "  .. round(pms2,2) .. " (" .. math.floor(pms2) .. ") x each, in " .. perMovesAuto .. "m";
      lsPrintWrapped(15, y, z, lsScreenX*1.5 - 20, 0.9, 0.9, 0xf2f2f2ff, autoMoveMessage);
    end

    y = y + 40;

    local timesPerMoveColor = 0xB0B0B0ff;
    if timesPerMove then
      timesPerMoveColor = 0xf0f0f0ff;
    end

    timesPerMove = lsCheckBox(15, y, z, timesPerMoveColor, "   Set '# Times to Repeat' based on Minutes", timesPerMove);

    if timesPerMove then
      perMoves = math.floor(pms2)
    else
      perMoves = math.floor(perMoves)
    end

    y = y + 25;

    lsPrint(37, y, z, 0.9, 0.9, tpmColor2, "   # Times to Repeat each Move = " .. perMoves );
    lsPrint(120, y+35, z, 0.8, 0.8, 0xf0f0f0ff, "Total Acro Session: " .. getElapsedTime(totalSession));
    y = y + 20;
    lsPrint(120, y+35, z, 0.8, 0.8, 0xf0f0f0ff, " Last Acro Session: " .. lastSession);
    y = y + 80;
    lsPrint(15, y, 0, 0.9, 0.9, 0xffff00ff, "Hover Mouse over Partner and Tap Ctrl to Ask Acro!");

    y = y + 35;

    if #foundMovesName > 0 then
      lsPrint(15, y, 0, 0.9, 0.9, 0x40ff40ff, "Check moves you want to perform:");
    else
      lsPrint(15, y, 0, 0.9, 0.9, 0xff8080ff, "No moves found! Refresh when Acro window is open");
    end

    y = y + 30;

    totalCheckedMoves = 0;
    for i=1,#foundMovesName do
      local color = 0xB0B0B0ff;
      if foundMovesShortName[i] then
        color = 0xffffffff;
        totalCheckedMoves = totalCheckedMoves + 1;
      end
      foundMovesShortName[i] = lsCheckBox(20, y, z, color, " " .. foundMovesName[i], foundMovesShortName[i]);
      y = y + 20;
    end

    if lsControlHeld() then
      askAcro();
    end

    lsSetCamera(0,0,lsScreenX*1.2,lsScreenY*1.2);

    if lsButtonText(lsScreenX - 50, lsScreenY - 50, z, 100, 0xFFFFFFff,
                    "Refresh") and is_done then
      findMoves();
      checkAllBoxes();
    end

  if #foundMovesName > 0 then
    if lsButtonText(lsScreenX - 50, lsScreenY - 80, z, 100, 0xFFFFFFff,
                    "Start") and is_done then
      processCheckedBoxes();
    end

    if lsButtonText(lsScreenX - 50, lsScreenY - 20, z, 100, 0xFFFFFFff,
                    "Check") and is_done then
      checkAllBoxes();
    end

    if lsButtonText(lsScreenX - 50, lsScreenY + 10, z, 100, 0xFFFFFFff,
                    "Uncheck") and is_done then
      uncheckAllBoxes();
    end
  end

    if lsButtonText(lsScreenX - 50, lsScreenY + 40, z, 100, 0xFFFFFFff,
                    "End Script") then
      error "Clicked End script button";
    end

    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    lsDoFrame();
    lsSleep(10);
  end
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function askAcro()
  lsDoFrame();
  statusScreen("Asking to Acro...", nil, 0.7);
  local pos = getMousePos();
  srClickMouseNoMove(pos[0], pos[1], 1); -- Right click where mouse is hovering (partner). Use right click in case we misclick and don't start running.
  clickText(waitForText("Tests", 500));
  lsSleep(100); -- Needed so that next menu doesn't fall behind Tests menu.
  clickText(waitForText("The Human Body", 500));
  clickText(waitForText("Test of the Acrobat", 500));
  clickText(waitForText("Ask to Acro", 500));
  lsSleep(100);
  srClickMouseNoMove(pos[0]+20, pos[1], 1); -- Right click to close out possible pinned menu.
end
