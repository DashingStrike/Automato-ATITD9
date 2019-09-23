-- stoneCutting.lua
-- by Rhaom - v1.0 added September 13, 2019
-- Merged rockSaw.lua & masonsBench.lua into a single script

dofile("common.inc");
dofile("settings.inc");

-- times are in minutes.  They are converted to ms and daffy/teppy time is also adjusted later
cutstoneTimer = 3;
flystoneTimer = 5;
pulleyTimer = 10;
nailmouldTimer = 7;
crucibleTimer = 10;
stoneblockTimer = 12;
duckTeppyOffset = 10; -- How many extra seconds to add (to each real-life minute) to compensate for game time
timer = 0;   -- Just a default to prevent error
arrangeWindows = true;

askText = "Stone cutting v1.0 - by Rhaom\n\nMerged functionality from rockSaw.lua and masonsBench.lua into a single stoneCutting script.\n\nPin up windows manually or use the Arrange Windows option to pin/arrange windows.";

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
		clickAllText("This Rock Saw");
		lsSleep(500);

		message = "Clicking " .. product;

        if cutstone then
			clickAllText("Make a Cut Stone");
        elseif flystone then
			clickAllText("Cut a Medium Stone into a pair of Flystones");
		elseif pulley then
			clickAllText("Cut a Pulley from a Cuttable Stone");
		elseif nailmould then
			clickAllText("Cut a Medium Stone into a Nail Mould");
        elseif crucible then
			clickAllText("Cut a Medium Stone into a Crucible");
		elseif stoneblock then
			clickAllText("Make a Small Stone Block");
        end

		lsSleep(500);
		closePopUp();  --If you don't have enough cuttable stones in inventory, then a popup will occur. We don't want these, so check.
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
	local y = 60;
  
    checkBreak("disallow pause");
	lsPrintWrapped(10,10, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, 
			"Stonecutting V1.0 by Rhaom\n(Merged rockSaw.lua and masonsBench.lua)\n\n");
    
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
	
	if not masonBench then
	rockSaw = readSetting("rockSaw",rockSaw);
	rockSaw = CheckBox(15, y, z+10, 0xFFFFFFff, "Cut stones on a Rocksaw", rockSaw, 0.65, 0.65);
	writeSetting("rockSaw",rockSaw);
	y = y + 32;
	end
	
	if not rockSaw then
	masonBench = readSetting("masonBench",masonBench);
	masonBench = CheckBox(15, y, z+10, 0xFFFFFFff, "Cut stones on a Masons Bench", masonBench, 0.65, 0.65);
	writeSetting("masonBench",masonBench);
	y = y + 32;
	end

    if cutstone then
      cutstoneColor = 0x80ff80ff;
    else
      cutstoneColor = 0xffffffff;
    end
    if flystone then
      flystoneColor = 0x80ff80ff;
    else
      flystoneColor = 0xffffffff;
    end
    if pulley then
      pulleyColor = 0x80ff80ff;
    else
      pulleyColor = 0xffffffff;
    end
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
    cutstone = readSetting("cutstone",cutstone);
    flystone = readSetting("flystone",flystone);
    pulley = readSetting("pulley",pulley);

	if rockSaw then
		if not flystone and not pulley then
		  cutstone = CheckBox(25, y, z+10, cutstoneColor, " Make Cut Stones from Cuttable Stone",
							   cutstone, 0.65, 0.65);
		  y = y + 32;
		else
		  cutstone = false
		end

		if not cutstone and not pulley then
		  flystone = CheckBox(25, y, z+10, flystoneColor, " Make Pair Flystones from Med Stone",
								  flystone, 0.65, 0.65);
		  y = y + 32;
		else
		  flystone = false
		end

		if not cutstone and not flystone then
		  pulley = CheckBox(25, y, z+10, pulleyColor, " Make Pulley from Cuttable Stone",
								  pulley, 0.65, 0.65);
		  y = y + 32;
		else
		  pulley = false;
		end
	end

	if masonBench then
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
	end

    writeSetting("nailmould",nailmould);
    writeSetting("crucible",crucible);
    writeSetting("stoneblock",stoneblock);
    writeSetting("cutstone",cutstone);
    writeSetting("pulley",pulley);
    writeSetting("flystone",flystone);

    if cutstone then
      product = "Cut Stones";
      timer = cutstoneTimer;
    elseif flystone then
      product = "Pair Flystones";
      timer = flystoneTimer;
    elseif pulley then
      product = "Pulley";
      timer = pulleyTimer;
    elseif nailmould then
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

	if (flystone) then
		msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1300 -- Add extra time to compensate for duck/teppy time
    elseif (pulley) then
		msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 200 -- Add extra time to compensate for duck/teppy time
	elseif (cutstone) then
		msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
	elseif (nailmould) then
		msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
	elseif (crucible) then
		msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
	else
		msTimerTeppyDuckOffset = (duckTeppyOffset * timer) * 1000 -- Add extra time to compensate for duck/teppy time
	end

	adjustedTimer = msTimer + msTimerTeppyDuckOffset;

	if rockSaw then
		if cutstone or flystone or pulley then
		lsPrintWrapped(25, y-10, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
					   product .. " requires " .. timer .. "m per pass\n\n" .. timer .. "m = " .. msTimer .. " ms\n" .. "+ Game Time Offset: " ..  msTimerTeppyDuckOffset .. " ms\n= " .. msTimer + msTimerTeppyDuckOffset .. " ms per pass");

		  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
			is_done = 1;
		  end
		end
	end
	
	if masonBench then
		if nailmould or crucible or stoneblock then
		lsPrintWrapped(25, y-10, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
					   product .. " requires " .. timer .. "m per pass\n\n" .. timer .. "m = " .. msTimer .. " ms\n" .. "+ Game Time Offset: " ..  msTimerTeppyDuckOffset .. " ms\n= " .. msTimer + msTimerTeppyDuckOffset .. " ms per pass");

		  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
			is_done = 1;
		  end
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