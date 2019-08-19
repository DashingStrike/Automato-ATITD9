-- Gather_Resources.lua v1.0 -- by Darkfyre
-- 
--

dofile("common.inc");

button_names = {"Grass","Slate","Clay"};
counter = 0;
postClickDelay = 500;

function checkOK()
	while 1 do
		checkBreak();
		srReadScreen();
		OK = srFindImage("OK.png");
			if OK then
			sleepWithStatus(100, "A popup box has been detected!\n\nAre you out of water?\n\nRun to nearby water (leave this popup open).\n\nAs soon as water icon appears, jugs will be refilled and popup window closed.");
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
		checkBreak();
		srReadScreen();
		local grass = srFindImage("grass.png");
			if grass then
			srClickMouseNoMove(grass[0]+5,grass[1],1);
			sleepWithStatus(postClickDelay, "Clicking Grass Icon\n\nGrass Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Grass Icon\n\nGrass Collected: " .. tostring(counter));
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
		checkBreak();
		srReadScreen();
		local clay = srFindImage("clay.png");
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
			local y = nil;
			local x = nil;
			local bsize = nil;
			checkBreak();


			lsPrint(5, 260, 2, 0.65, 0.65, 0xffffffff, "     Choose Grass, Slate, Clay button.");


			for i=1, #button_names do
				if button_names[i] == "Grass" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Slate" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Clay" then
					x = 30;
					y = 130;
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


