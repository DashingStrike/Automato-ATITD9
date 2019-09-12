-- masonsBench.lua
-- by wzydhek - v1.0 added September 12, 2019

dofile("common.inc");
dofile("settings.inc");

-- times are in minutes.  They are converted to ms and daffy/teppy time is also adjusted later
nailmouldTimer = 7;
crucibleTimer = 10;
stoneblockTimer = 12;
duckTeppyOffset = 10; -- How many extra seconds to add (to each real-life minute) to compensate for game time
timer = 0;   -- Just a default to prevent error
arrangeWindows = true;

askText = "Mason's Bench v1.0 - by wzydhek\n\nMake Nail Moulds, Crucibles or Small Stone Blocks on Mason's Benches.\n\nPin up windows manually or use Window Manager to pin/arrange windows.";

function doit()
	askForWindow(askText);
	config();
		if(arrangeWindows) then
			arrangeInGrid();
		end
	unpinOnExit(start);
end

function start()
	for i=1, passCount do
		-- refresh windows
        message = "Refreshing"
		clickAllText("This Mason's Bench");
		lsSleep(500);

		message = "Clicking " .. product;

        if nailmould then
			clickAllText("Cut a Medium Stone into a Nail Mould");
        elseif crucible then
			clickAllText("Cut a Medium Stone into a Crucible");
		elseif stoneblock then
			clickAllText("Make a Small Stone Block");
        end

		lsSleep(500);
		closePopUp();  --If you don't have enough medium stones in inventory, then a popup will occur. We don't want these, so check.
		sleepWithStatus(adjustedTimer, "Waiting for " .. product .. " to finish", nil, 0.7, 0.7);

	end
	lsPlaySound("Complete.wav");
end


function closePopUp()
  while 1 do
    srReadScreen()
    local ok = srFindImage("OK.png")
    if ok then
      statusScreen("Found and Closing Popups ...", nil, 0.7, 0.7);
      srClickMouseNoMove(ok[0]+5,ok[1],1);
      lsSleep(100);
    else
      break;
    end
  end
end

function config()
  scale = 0.8;
  local z = 0;
  local is_done = nil;
  while not is_done do
    checkBreak("disallow pause");
    lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Configure Mason's Bench");
    local y = 60;

    passCount = readSetting("passCount",passCount);
    lsPrint(15, y, z, scale, scale, 0xffffffff, "Passes:");
    is_done, passCount = lsEditBox("passes", 110, y, z, 50, 30, scale, scale,
                                   0x000000ff, passCount);
    if not tonumber(passCount) then
      is_done = false;
      lsPrint(10, y+30, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passCount = 1;
    end
    writeSetting("passCount",passCount);
    y = y + 48;

	arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
	arrangeWindows = CheckBox(15, y, z+10, 0xFFFFFFff, "Arrange windows (Grid format)", arrangeWindows, 0.65, 0.65);
	writeSetting("arrangeWindows",arrangeWindows);
	y = y + 32;

    if nailmould then
      nailmouldColor = 0x80ff80ff;
    else
      nailmouldColor = 0xffffffff;
    end
    if crucible then
      crucibleColor = 0x80ff80ff;
    else
      crucibleColor = 0xffffffff;
    end
    if stoneblock then
      stoneblockColor = 0x80ff80ff;
    else
      stoneblockColor = 0xffffffff;
    end

    nailmould = readSetting("nailmould",nailmould);
    crucible = readSetting("crucible",crucible);
    stoneblock = readSetting("stoneblock",stoneblock);

    if not crucible and not stoneblock then
      nailmould = CheckBox(15, y, z+10, nailmouldColor, " Cut a Medium Stone into a Nail Mould",
                           nailmould, 0.65, 0.65);
      y = y + 32;
    else
      nailmould = false
    end

    if not nailmould and not stoneblock then
      crucible = CheckBox(15, y, z+10, crucibleColor, " Cut a Medium Stone into a Crucible",
                              crucible, 0.65, 0.65);
      y = y + 32;
    else
      crucible = false
    end

    if not nailmould and not crucible then
      stoneblock = CheckBox(15, y, z+10, stoneblockColor, " Make a Small Stone Block",
                              stoneblock, 0.65, 0.65);
      y = y + 32;
    else
      stoneblock = false;
    end

    writeSetting("nailmould",nailmould);
    writeSetting("crucible",crucible);
    writeSetting("stoneblock",stoneblock);

    if nailmould then
      product = "Nail Mould";
      timer = nailmouldTimer;
    elseif crucible then
      product = "Crucible";
      timer = crucibleTimer;
    elseif stoneblock then
      product = "Small Stone Block";
      timer = stoneblockTimer;
    end

	msTimer = (timer * 60) * 1000

	if (nailmould) then
    msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
  elseif (crucible) then
	  msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
	else
	  msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
	end

	adjustedTimer = msTimer + msTimerTeppyDuckOffset;


    if nailmould or crucible or stoneblock then
    lsPrintWrapped(15, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
                   "Uncheck box to see more options!\n\n" .. product .. " requires " .. timer .. "m per pass\n\n" .. timer .. "m = " .. msTimer .. " ms\n" .. "+ Game Time Offset: " ..  msTimerTeppyDuckOffset .. " ms\n= " .. msTimer + msTimerTeppyDuckOffset .. " ms per pass");

      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
        is_done = 1;
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(shortWait);
  end
end

-- Custom function to override the one in common_click.inc
function clickAllPoints(points, offsetX, offsetY, rightClick)
  if not points then
    error("Incorrect number of arguments for clickAllPoints()");
  end
  if not offsetX then
    offsetX = 5;
  end
  if not offsetY then
    offsetY = 5;
  end

  for i=1, #points  do
    if click_delay > 0 and #points > 1 then
      statusScreen(message .. " " .. #points .. " window(s) ...", nil, 0.7, 0.7);
    end
    safeClick(points[i][0]+offsetX, points[i][1]+offsetY, rightClick);
    lsSleep(click_delay);
  end
  if click_delay > 0 and #points > 1 then
    statusScreen("Done " .. message .. " (" .. #points .. " windows)", nil, 0.7, 0.7);
  end
  lsSleep(click_delay);
end