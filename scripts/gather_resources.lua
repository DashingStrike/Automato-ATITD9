-- Gather_Resources.lua v1.0 -- by Darkfyre
-- Revised by Rhaom -- Added auto click movement
-- Revised by Cegaiel -- Added checkElapsedTime() Attempt to refill jugs when you ran out (if a nearby water source is present), when using AutoMove mode.
                      -- Also abort macro if resources aren't being found (doesn't apply to slate) in a certain amount of time.


dofile("common.inc");
dofile("flax_common.inc");
dofile("settings.inc");

button_names = {"Grass","Slate","Clay","Limestone"};
counter = 0;
postClickDelay = 100;

moveDirection = 0;
moveCounter = 1;
autoMove = false;
lastGathered = lsGetTimer();
timeOut = 10000; -- How many milliseconds (1000 = 1 second) before macro quits if it doesn't find a resource to click on.

function gatherGrass()
	if not autoMove then timeStarted = lsGetTimer(); end
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
			       timeStarted = lsGetTimer()
				end
			end
			
		checkBreak();
		srReadScreen();
		local grass = srFindImage("grass.png");
		
			if autoMove then
				checkElapsedTime();
				moveCharacter();
			end
		
			if grass then
				srClickMouseNoMove(grass[0]+5,grass[1],1);
				sleepWithStatus(2300, "Clicking Grass Icon\nWaiting on Animation\n\nGrass Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
				counter = counter + 1;
				lastGathered = lsGetTimer()
			else
				sleepWithStatus(100, "Searching for Grass Icon\n\n\nGrass Collected: " ..tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
			end
			closePopUp()
	end
end

function gatherLimestone()
	timeStarted = lsGetTimer();
	while 1 do
		checkBreak();
		srReadScreen();
		local slate = srFindImage("limestone.png");
			if slate then
			srClickMouseNoMove(slate[0]+5,slate[1],1);
			sleepWithStatus(2300, "Clicking Limestone Icon\n\nLimestone Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
			counter = counter + 1;
			else
			sleepWithStatus(50, "Searching for Limestone Icon\n\nLimestone Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
			end
			closePopUp()
	end
end

function gatherSlate()
	timeStarted = lsGetTimer();
	while 1 do
		checkBreak();
		srReadScreen();
		local slate = srFindImage("slate.png");
			if slate then
			srClickMouseNoMove(slate[0]+5,slate[1],1);
			sleepWithStatus(postClickDelay, "Clicking Slate Icon\n\nSlate Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
			counter = counter + 1;
			else
			sleepWithStatus(50, "Searching for Slate Icon\n\nSlate Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
			end
			closePopUp()
	end
end

function gatherClay()
	if not autoMove then timeStarted = lsGetTimer(); end
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
			timeStarted = lsGetTimer()
			end
		end
		
		checkBreak();
		srReadScreen();
		local clay = srFindImage("clay.png");
		
			if autoMove then
				checkElapsedTime();
				moveCharacter();
			end
		
			if clay then
			srClickMouseNoMove(clay[0]+5,clay[1],1);
			sleepWithStatus(2300, "Clicking Clay Icon\nWaiting on Animation\n\nClay Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
			counter = counter + 1;
			lastGathered = lsGetTimer()
			else
			sleepWithStatus(100, "Searching for Clay Icon\n\n\nClay Collected: " .. tostring(counter) .. "\n\n\nElapsed Time: " .. getElapsedTime(timeStarted));
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
				"NOT COMPATIBLE WITH SLATE OR LIMESTONE!\n\nChoose which resource to gather will prompt you to select which direction you wish to move in\n\nThere will be some drift, as movement is done via mouse click!");
			end
			
			for i=1, #button_names do
				if button_names[i] == "Grass" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Slate" then
					x = 30;
					y = 40;
					bsize = 130;
				elseif button_names[i] == "Clay" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Limestone" then
					x = 30;
					y = 100;
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
		elseif image_name == "Limestone" then
			gatherLimestone();
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
	xyCenter = getCenterPos();
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
    local ok = srFindImage("ok.png")
    local cancel = srFindImage("cancel.png")
    if ok or cancel then
      statusScreen("Found and Closing Popups ...", nil, 0.7, 0.7);
    end
    if ok then
      srClickMouseNoMove(ok[0]+5,ok[1],1);
      lsSleep(100);
    end
    if cancel then
      srClickMouseNoMove(cancel[0]+5,cancel[1],1);
      lsSleep(100);
    end
    if not ok and not cancel then break; end
  end
end

function checkElapsedTime()
	  if lsGetTimer() - lastGathered > timeOut then
	    srClickMouseNoMove(xyCenter[0]-300, xyCenter[1], 1); --Right click ground (Stop player from walking)
		if drawWater() then -- Attempt to refill jugs, in case we're doing Clay
		  lastGathered = lsGetTimer(); -- Reset Timer and continue, after fetching water
		else	
		  lsPlaySound("fail.wav");
		  error("No resources found within past " .. math.floor(timeOut/1000) .." seconds; Aborting...")
		end
	  end
end


