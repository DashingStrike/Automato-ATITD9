-- Gather_Resources.lua v1.0 -- by Darkfyre
-- Revised by Rhaom -- Added auto click movement

dofile("common.inc");
dofile("settings.inc");
dofile("flax_common.inc");
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

loadfile("screen_reader_common.inc")();
loadfile("ui_utils.inc")();

button_names = {"Grass","Slate","Clay"};
counter = 0;
postClickDelay = 500;

moveDirection = 0;
moveCounter = 1;
autoMove = false;

function checkOK()
	while 1 do
		checkBreak();
		srReadScreen();
		OK = srFindImage("OK.png");
			if OK then
			sleepWithStatus(100, "A popup box has been detected!\n\nAre you out of water?\n\nRun to nearby water (leave this popup open).\n\nAs soon as water icon appears, moves will be refilled and popup window closed.");
			  if drawWater(1) then
			    closePopUp();
			  end
			else
			break;
		end
	end
end


function closePopUp()
	srReadScreen();
	local OK = srFindImage("OK.png");
		if OK then
			safeClick(OK[0]+3, OK[1]-5);
	end
end




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
				sleepWithStatus(postClickDelay, "Clicking Grass Icon\n\nGrass Collected: " .. tostring(counter));
				counter = counter + 1;
			else
				sleepWithStatus(100, "Searching for Grass Icon\n\nGrass Collected: " ..tostring(counter));
			end
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
	end
end

function gatherClay()
	while 1 do
		checkOK();
		
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
			sleepWithStatus(postClickDelay, "Clicking Clay Icon\n\nClay Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Clay Icon\n\nClay Collected: " .. tostring(counter));
			end
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