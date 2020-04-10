-- stoneCutting.lua
-- by Rhaom - v1.0 added September 13, 2019
-- Merged rockSaw.lua & masonsBench.lua into a single script

dofile("common.inc");
dofile("settings.inc");

arrangeWindows = true;
askText = "Stone cutting v1.0 - by Rhaom" ..
"\n\nMerged functionality from rockSaw.lua and masonsBench.lua into a single stoneCutting script." ..
"\n\nPin up windows manually or use the Arrange Windows option to pin/arrange windows.";

function doit()
	askForWindow(askText);
	config();
		if(arrangeWindows) then
			arrangeInGrid(nil, nil, nil, nil,nil, 10, 25);
		end
	unpinOnExit(start);
end

function config()
  scale = 0.8;
  local z = 0;
  local is_done = nil;
  while not is_done do
	local y = 7;

  checkBreak("disallow pause");

	lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
		"Global Settings\n-------------------------------------------");
	y = y + 35;

	passCount = readSetting("passCount",tonumber(passCount));
    lsPrint(15, y, z, scale, scale, 0xffffffff, "Passes :");
    is_done, passCount = lsEditBox("passCount", 110, y-2, z, 50, 30, scale, scale,
                                   0x000000ff, passCount);
    if not tonumber(passCount) then
      is_done = false;
      lsPrint(10, y+30, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      passCount = 1;
    end
    writeSetting("passCount",tonumber(passCount));
    y = y + 32;

	arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
	arrangeWindows = CheckBox(15, y, z+10, 0xFFFFFFff, "Arrange windows (Grid format)", arrangeWindows, 0.65, 0.65);
	writeSetting("arrangeWindows",arrangeWindows);
	y = y + 28;

	lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xffff40ff,
		"Product Settings\n-------------------------------------------");
	y = y + 35;
	rockSaw = readSetting("rockSaw",rockSaw);
	masonBench = readSetting("masonBench",masonBench);
	if not masonBench then
	  rockSaw = CheckBox(15, y, z+10, 0xFFFFFFff, "Cut stones on a Rocksaw", rockSaw, 0.65, 0.65);
	  writeSetting("rockSaw",rockSaw);
	  writeSetting("nailmould",false);
	  writeSetting("crucible",false);
	  writeSetting("stoneblock",false);
	  y = y + 22;
	end

	if not rockSaw then
	  masonBench = CheckBox(15, y, z+10, 0xFFFFFFff, "Cut stones on a Masons Bench", masonBench, 0.65, 0.65);
	  writeSetting("masonBench",masonBench);
	  writeSetting("cutstone",false);
	  writeSetting("flystone",false);
	  writeSetting("pulley",false);
	  y = y + 22;
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
		  y = y + 25;
		else
		  cutstone = false
		end

		if not cutstone and not pulley then
		  flystone = CheckBox(25, y, z+10, flystoneColor, " Make a Pair of Flystones from Med Stone",
								  flystone, 0.65, 0.65);
		  y = y + 25;
		else
		  flystone = false
		end

		if not cutstone and not flystone then
		  pulley = CheckBox(25, y, z+10, pulleyColor, " Make a Pulley from Cuttable Stone",
								  pulley, 0.65, 0.65);
		  y = y + 25;
		else
		  pulley = false;
		end
	end

	if masonBench then
		if not crucible and not stoneblock then
		  nailmould = CheckBox(25, y, z+10, nailmouldColor, " Cut a Medium Stone into a Nail Mould",
							   nailmould, 0.65, 0.65);
		  y = y + 25;
		else
		  nailmould = false
		end

		if not nailmould and not stoneblock then
		  crucible = CheckBox(25, y, z+10, crucibleColor, " Cut a Medium Stone into a Crucible",
								  crucible, 0.65, 0.65);
		  y = y + 25;
		else
		  crucible = false
		end

		if not nailmould and not crucible then
		  stoneblock = CheckBox(25, y, z+10, stoneblockColor, " Cut a Medium Stone into a Small Stone Block",
								  stoneblock, 0.65, 0.65);
		  y = y + 25;
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

    if nailmould then
      product = "Nail Moulds";
    elseif crucible then
      product = "Crucibles";
    elseif stoneblock then
      product = "Small Stone Blocks";
    elseif cutstone then
      product = "Cut Stones";
    elseif flystone then
      product = "Pair Flystones";
    elseif pulley then
      product = "Pulleys";
    end


	if rockSaw then
		if cutstone or flystone or pulley then
		  if lsButtonText(10, lsScreenY - 30, z, 100, 0x00ff00ff, "Begin") then
			is_done = 1;
		  end
		end
	end

	if masonBench then
		if nailmould or crucible or stoneblock then
		  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Begin") then
			is_done = 1;
		  end
		end
	end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFF0000ff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(shortWait);
  end
end

function start()
--sleepWithStatus(2000, product)
	for i=1, passCount do
		-- refresh windows
		message = "Refreshing"
		refreshWindows();
		lsSleep(500);

		message = "Clicking " .. product;

		if cutstone then
				clickAllText("Cut Stone");
			elseif flystone then
				clickAllText("Flystones");
			elseif pulley then
				clickAllText("Pulley");
			elseif nailmould then
				clickAllText("Nail Mould");
			elseif crucible then
				clickAllText("Crucible");
			elseif stoneblock then
				clickAllText("Small Stone Block");
		end

		lsSleep(500);
		closePopUp();  --If you don't have enough cuttable stones in inventory, then a popup will occur.
		checkMaking();
	end
	lsPlaySound("Complete.wav");
end

function refreshWindows()
    srReadScreen();
    this = findAllText("This");
    for i = 1, #this do
        clickText(this[i]);
    end
    lsSleep(100);
end

function checkMaking()
			while 1 do
				refreshWindows();
				srReadScreen();
				making = findAllText("Making")
					if #making == 0 then
						break; --We break this while statement because Making is not detect, hence we're done with this round
					end
				sleepWithStatus(999, "Waiting for " .. product .. " to finish", nil, 0.7, "Monitoring Pinned Window(s)");
			end
end

function closePopUp()
  while 1 do
    srReadScreen()
    local ok = srFindImage("OK.png")
    if ok then
      statusScreen("Found and Closing Popups ...", nil, 0.7);
      srClickMouseNoMove(ok[0]+5,ok[1],1);
      lsSleep(100);
    else
      break;
    end
  end
end
