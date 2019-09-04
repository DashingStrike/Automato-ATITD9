-- Gather_Resources.lua v1.0 -- by Darkfyre
-- Revised by Rhaom -- Added auto click movement


dofile("common.inc");
dofile("flax_common.inc");
dofile("settings.inc");

button_names = {"Grass","Slate","Clay"};
counter = 0;
postClickDelay = 800;

moveDirection = 0;
moveCounter = 1;
autoMove = false;


function gatherGrass()
	while 1 do
	
			if (autoMove) then
			while not is_done do
				statusScreen("Select line of direction.");
					if lsButtonText(10, 100, 0, 250, 0xFFFFFFff, "West - East") then
						moveDirection = 0;
						is_done = 1;
					end
					if lsButtonText(10, 140, 0, 250, 0xFFFFFFff, "North - South") then
						moveDirection = 1;
						is_done = 1;
					end
					if lsButtonText(10, 180, 0, 250, 0xFFFFFFff, "East - West") then
						moveDirection = 2;
						is_done = 1;
					end
					if lsButtonText(10, 220, 0, 250, 0xFFFFFFff, "South - North") then
						moveDirection = 3;
						is_done = 1;
					end
				end
			end
			
		checkBreak();
		srReadScreen();
		local grass = srFindImage("grass.png");
		
			if autoMove then
				moveCharacter();
			end
		
			if grass then
				srClickMouseNoMove(grass[0]+5,grass[1],1);
				sleepWithStatus(2500, "Clicking Grass Icon\nWaiting on Animation\n\nGrass Collected: " .. tostring(counter));
				counter = counter + 1;
			else
				sleepWithStatus(100, "Searching for Grass Icon\n\n\nGrass Collected: " ..tostring(counter));
			end
			closePopUp()
	end
end

function gatherSlate()
	while 1 do
		checkBreak();
		srReadScreen();
		local slate = srFindImage("slate.png");
			if slate then
			srClickMouseNoMove(slate[0]+5,slate[1],1);
			sleepWithStatus(postClickDelay, "Clicking Slate Icon\n\nSlate Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Slate Icon\n\nSlate Collected: " .. tostring(counter));
			end
			closePopUp()
	end
end

function gatherClay()
	while 1 do
		
		if (autoMove) then
			while not is_done do
				statusScreen("Select line of direction.");
					if lsButtonText(10, 100, 0, 250, 0xFFFFFFff, "West - East") then
						moveDirection = 0;
						is_done = 1;
					end
					if lsButtonText(10, 140, 0, 250, 0xFFFFFFff, "North - South") then
						moveDirection = 1;
						is_done = 1;
					end
					if lsButtonText(10, 180, 0, 250, 0xFFFFFFff, "East - West") then
						moveDirection = 2;
						is_done = 1;
					end
					if lsButtonText(10, 220, 0, 250, 0xFFFFFFff, "South - North") then
						moveDirection = 3;
						is_done = 1;
					end
			end
		end
		
		checkBreak();
		srReadScreen();
		local clay = srFindImage("clay.png");
		
			if autoMove then
				moveCharacter();
			end
		
			if clay then
			srClickMouseNoMove(clay[0]+5,clay[1],1);
			sleepWithStatus(2500, "Clicking Clay Icon\n\nWaiting on Animation\n\nClay Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Clay Icon\n\n\nClay Collected: " .. tostring(counter));
			end
			closePopUp()
	end
end

function doit()
  gatherResources();
end

function gatherResources()
	askForWindow('Searches for and clicks the selected resource (clay, grass, slate) until stopped.\n\nGrass: It\'s efficient (less running) if you walk instead of run (Self Click -> Emote -> Gait: Walking -- Gait: Running to restore)\n\nPress Shift over ATITD window to continue.');
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = 0;
			local x = nil;
			local z = 0;
			local bsize = nil;
			checkBreak();
			
			lsPrint(45, 130, 2, 0.65, 0.65, 0xffffffff, "     Choose Grass, Slate, Clay button.");
			
			autoMove = readSetting("autoMove",autoMove);
			autoMove = CheckBox(35, 160, z, 0xFFFFFFff, " Set Automove Direction", autoMove, 0.65, 0.65);
			writeSetting("autoMove",autoMove);
						
			if autoMove then
			lsPrintWrapped(25, 185, z+10, lsScreenX - 20, 0.7, 0.7, 0xd0d0d0ff,
				"NOT COMPATIBLE WITH SLATE!\n\nChoose which resource to gather will prompt you to select which direction you wish to move in\n\nThere will be some drift, as movement is done via mouse click!");
			end
			
			for i=1, #button_names do
				if button_names[i] == "Grass" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Slate" then
					x = 30;
					y = 50;
					bsize = 130;
				elseif button_names[i] == "Clay" then
					x = 30;
					y = 90;
					bsize = 130;
				end
				if lsButtonText(x, y, 0, 250, 0xe5d3a2ff, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end
			end

		       if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Grass" then
			gatherGrass();	
		elseif image_name == "Slate" then
			gatherSlate();
		elseif image_name == "Clay" then
			gatherClay();
		end
	end
end

-------------------------------------------------------------------------------
-- moveCharacter()
--
-- Directional character movement
-------------------------------------------------------------------------------

function moveCharacter()
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local xyCenter = getCenterPos();
	if moveDirection == 0 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0]+300, xyCenter[1], 0);
		else
			srClickMouseNoMove(xyCenter[0]-300, xyCenter[1], 0);	
		end
		lsSleep(move_delay);
	end
	if moveDirection == 1 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0], xyCenter[1]+300, 0);
		else
			srClickMouseNoMove(xyCenter[0], xyCenter[1]-300, 0);	
		end
		lsSleep(move_delay);
	end
	if moveDirection == 2 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0]-300, xyCenter[1], 0);
		else
			srClickMouseNoMove(xyCenter[0]+300, xyCenter[1], 0);	
		end
		lsSleep(move_delay);
	end
	if moveDirection == 3 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0], xyCenter[1]-300, 0);
		else
			srClickMouseNoMove(xyCenter[0], xyCenter[1]+300, 0);	
		end
		lsSleep(move_delay);
	end
	if moveCounter < 5 then
		directionCounter = 1;
	else
		directionCounter = 0;
	end
	if moveCounter > 8 then
		moveCounter = 0;
	else
		moveCounter = moveCounter + 1;
	end
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
