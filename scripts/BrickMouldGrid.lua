-- BrickMouldGrid.lua v1.0 -- Created by Manon & Cegaiel.
-- Will place a grid of 5x5 Flimsy Brick Moulds.
--

dofile("common.inc");
dofile("settings.inc");

NW = makePoint(45, 60);
NE = makePoint(75, 62);
SW = makePoint(45, 87);
SE = makePoint(75, 91);
N = makePoint(59, 51);
S = makePoint(60, 98);
E = makePoint(84, 74);
W = makePoint(37, 75);
BuildButton = makePoint(30, 135);
CancelButton = makePoint(85, 135);

testMode = false; -- set to true to not use any boards, but just move grid and hit cancel button after each move
counter = 1;

function doit()
	askForWindow("BrickRackGrid.lua v1.0 -- Created by Manon & Cegaiel.\n\nWill place a grid of 5x5 Flimsy Brick Moulds.\nMake sure you have the 'Build a Flimsy Brick Mould' window open and pinned.\nMake sure you have 100 boards on you.\n\nThe automato window must be in the TOP-RIGHT corner of the screen.");


	  promptOptions();

	if task == "grid" then
        setCameraView(CARTOGRAPHER2CAM);
        lsSleep(1000);
        PlaceMould(); -- Places the Flimsy Brick Moulds
        closePopUp();

	elseif task == "guild" then
        contributeGuild();
	end

lsPlaySound("complete.wav");
end


function checkBuild()
  statusScreen("Clicking/Waiting on Build button", nil, 0.7, 0.7);
  srReadScreen();
  BuildFlimsy = findText("Build a Flimsy Brick");

  if BuildFlimsy then
    clickText(BuildFlimsy);
  else
    error("Could not find Build a Flimsy Brick menu")
  end

      while 1 do
        srReadScreen();
        buildButtonImage = srFindImage("build.png");
        OK = srFindImage("ok.png");

        if OK then
          closePopUp();
          error("Looks like you don\'t have enough boards")
        elseif buildButtonImage then
          break;
        end
      end --while
end


function PlaceMould()
	--Build Row 2 Column 2
	--NWx2
  moveMould("NW", 2);

	--Build Row 2 Column 3
	--Nx2
  moveMould("N", 2);

	--Build Row 2 Column 4
	--NEx2
  moveMould("NE", 2);

	--Build Row 3 Column 4
	--Ex2
  moveMould("E", 2);

	--Build Row 4 Column 4
	--SEx2
  moveMould("SE", 2);

	--Build Row 4 Column 3
	--Sx2
  moveMould("S", 2);

	--Build Row 4 Column 2
	--SWx2
  moveMould("SW", 2);

	--Build Row 3 Column 2
	--Wx2
  moveMould("W", 2);

	--Build Row 1 Column 1
	--NWx4
  moveMould("NW", 4);

	--Build Row 1 Column 2
	--NWx2
	--Nx2
  moveMould("NW", 2, 1); -- Since this needs two different directions add a true (1) as a THIRD (3rd) parameter so it doesn't click Build yet
  moveMould("N", 2);

	--Build Row 1 Column 3
	--Nx4
  moveMould("N", 4);

	--Build Row 1 Column 4
	--NEx2
	--Nx2
  moveMould("NE", 2, 1);
  moveMould("N", 2);

	--Build Row 1 Column 5
	--NEx4
  moveMould("NE", 4);

	--Build Row 2 Column 5
	--NEx2
	--Ex2
  moveMould("NE", 2, 1);
  moveMould("E", 2);

	--Build Row 3 Column 5
	--Ex4
  moveMould("E", 4);

	--Build Row 4 Column 5
	--Ex2
	--SEx2
  moveMould("E", 2, 1);
  moveMould("SE", 2);

	--Build Row 5 Column 5
	--SEx4
  moveMould("SE", 4);

	--Build Row 5 Column 4
	--SEx2
	--Sx2
  moveMould("SE", 2, 1);
  moveMould("S", 2);

	--Build Row 5 Column 3
	--Sx4
  moveMould("S", 4);

	--Build Row 5 Column 2
	--Sx2
	--SWx2
  moveMould("S", 2, 1);
  moveMould("SW", 2);

	--Build Row 5 Column 1
	--SWx4
  moveMould("SW", 4);

	--Build Row 4 Column 1
	--SWx2
	--Wx2
  moveMould("SW", 2, 1);
  moveMould("W", 2);

	--Build Row 3 Column 1
	--Wx4
  moveMould("W", 4);

	--Build Row 2 Column 1
	--Wx2
	--NWx2
  moveMould("W", 2, 1);
  moveMould("NW", 2);

	--Build center, where you're standing (Row 3 Column 3)
	--NO MOVEMENT
  moveMould("C", 0);
end


function moveMould(direction, times, multipleMoves)
  if not lastMultipleMoves then
    checkBuild();
  end


  if direction == "NW" then
    clickDirection = NW
  elseif direction == "NE" then
    clickDirection = NE
  elseif direction == "SW" then
    clickDirection = SW
  elseif direction == "SE" then
    clickDirection = SE
  elseif direction == "N" then
    clickDirection = N
  elseif direction == "S" then
    clickDirection = S
  elseif direction == "E" then
    clickDirection = E
  elseif direction == "W" then
    clickDirection = W
  elseif direction == "C" then -- center/no movement
  end


  if lastMultipleMoves then
    extraText = "\n" .. lastDirection .. " x" .. lastTimes;
  else
    extraText = "";
  end

  statusScreen("[" .. counter .. "/25] Moving Mould:\n\n" .. direction .. " x" .. times .. extraText, nil, 0.7, 0.7);

  if direction ~= "C" then
    for i=1,times do
      safeClick(clickDirection[0], clickDirection[1]);
    end
  end

  lsSleep(200);


  if multipleMoves == nil then --If we need to move in 2 or more direction, then don't click build yet. multipleMoves is passed to the function (direction, times, multipleMoves)

		if testMode then
		  lsSleep(1000) -- Wait extra long while testing to see if grid location looks right
		  --While testing, let's use cancel instead
		  safeClick(CancelButton[0], CancelButton[1]);
		else
		  safeClick(BuildButton[0], BuildButton[1]);
		end

    lsSleep(200); -- postClick sleep
counter = counter + 1;
  end

  lastMultipleMoves = multipleMoves;
  lastDirection = direction;
  lastTimes = times;

end


function closePopUp()
    while 1 do -- Perform a loop in case there are multiple pop-ups behind each other; this will close them all before continuing.
        checkBreak();
        srReadScreen();
        OK = srFindImage("ok.png");
        if OK then
            srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
            lsSleep(100);
        else
            break;
        end
    end
end

function contributeGuild()
local scale = 0.7;
local message = "Tap Ctrl over each Brick Rack to\n\nContribute to Guild:\n\n" .. guild_name .. "\n\n";
local status = "";

  local shift = false;
  local done = false;
  while not done do
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
		    0xffffffff, "End Script") then
      error(quit_message);
    end
    while lsControlHeld() do
      checkBreak();
      shift = true;
    end
    if shift then
	status = "";
      shift = false;
      local x = 0;
      local y = 0;
      x, y = srMousePos();

      safeBegin();
      srSetMousePos(x, y);
      lsSleep(50);
      srClickMouse(x, y);
      clickText(waitForText("Ownership", 500));
      clickText(waitForText("Contribute this to my guild", 500));
      clickText(waitForText(guild_name, 500));
      waitForText("Once you contribute", 500);
      yesButton = findText("Once you contribute");

	if yesButton then
        srClickMouseNoMove(yesButton[0]+110,yesButton[1]+90);
        status = "Success";
	else
        srClickMouseNoMove(0,0, 1);
        status = "This appears to already be guilded?";
	end

    end

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Done") then
        done = true;
    end

      checkBreak();
      statusScreen(message .. status, nil, scale, scale);
      lsSleep(tick_delay);
  end
end


function promptOptions()
	scale = 0.7;
	local z = 0;
	local is_done = nil;
	-- Edit box and text display
	while not is_done do
		checkBreak("disallow pause");
		lsPrintWrapped(10, 10, z, lsScreenX, scale, scale, 0xFFFFFFff, "Welcome to Brick Mould Grid\n\nGuild Menu: This will allow you to enter your Guild Name and then you can Tap Ctrl over each brick rack to quickly contribute it to your guild.\n\nMake Grid: Proceed to make a 5x5 Grid of Flimsy Brick Racks. Make sure you have 100 Boards in inventory!");		
		local y = 40;
		
		if lsButtonText(10, lsScreenY - 60, z, 100, 0xFFFFFFff, "Guild") then
			is_done = 1;
			promptGuild();
		end

		if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Make Grid") then
			is_done = 1;
			task = "grid"
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
end


function promptGuild()
	scale = 0.7;
	local z = 0;
	while not is_done do
		checkBreak("disallow pause");
		lsPrintWrapped(10, 10, z, lsScreenX, scale, scale, 0xFFFFFFff, "Enter your Guild Name (partial name OK) and click Start.\n\nYou will then be able to Tap Ctrl over each brick rack to contribute it to that Guild.");		
		local y = 130;
		lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Guild Name: ");
		guild_name = readSetting("guild_name",guild_name);
		is_done, guild_name = lsEditBox("guild_name",
			100, y, z, 160, 30, scale, scale,
			0x000000ff, guild_name);
		writeSetting("guild_name",guild_name);

		if lsButtonText(10, lsScreenY - 60, z, 100, 0xFFFFFFff, "Back") then
			is_done = 1;
			promptOptions();
		end

		if guild_name ~= "" then
		  if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Start") then
			is_done = 1;
			task = "guild";
			lsDoFrame();
		  end
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
	
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
end

