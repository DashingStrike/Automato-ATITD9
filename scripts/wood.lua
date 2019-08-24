-- Updated by Manon for T8 beta
-- Updated by Huggz for T8 proper
-- Updated by Manon for T9 Beta
--

dofile("common.inc");

delay_time = 3000;
total_delay_time = 300000;

function doit()
	askForWindow("Pin 5-10 tree windows, will click them VERTICALLY (left to right if there is a tie - multiple columns are fine).  Additionally, optionally, pin a Bonfire window for stashing wood. If the trees are part of an oasis, you only need to pin 1 of the trees.");
	-- Find windows
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	
	buttons = findAllImages("wood/This.png");
		
	harvestIndex = 1
	
	while true do
		winPosX = buttons[harvestIndex][0] - 1
		winPosY = buttons[harvestIndex][1] - 1
	
		srClickMouseNoMove(winPosX, winPosY)
		lsSleep(500)
		srReadScreen()
		
		hasWood = srFindImageInRange("wood/GatherWood.png", winPosX, winPosY, 180, 115)
		
		if hasWood == nil then
			statusScreen("Tree " .. harvestIndex .. "/" .. #buttons .. " has no wood.  Waiting...")
		else			
			statusScreen("Grabbing Wood " .. harvestIndex .. "/" .. #buttons);
			srClickMouseNoMove(hasWood[0] + 2, hasWood[1] + 2)
			
			harvestIndex = harvestIndex + 1
			if harvestIndex > #buttons then
				harvestIndex = 1
				
				lsSleep(delay_time)
				
				-- stash to bonfire
				-- add logic to stash to warehouse
				srReadScreen()
				bonfire = srFindImage("wood/Bonfire.png");
				if bonfire then
					statusScreen("Found bonfire...");
					add_wood = srFindImage("wood/AddSomeWood.png");
					if add_wood then
						-- add it
						statusScreen("Adding wood to bonfire");
						srClickMouseNoMove(add_wood[0]+5, add_wood[1]+5);
						lsSleep(500);
						-- click Max
						
						click_max = srFindImage("wood/maxButton.png");
						if(not click_max) then
							click_max = srFindImage("wood/maxButton2.png");
							srClickMouseNoMove(xyWindowSize[0]/2, xyWindowSize[1]/2 + 5);
						end
					else
						statusScreen("No add wood button, refreshing bonfire");
						-- refresh bonfire window
						srClickMouseNoMove(bonfire[0]+5, bonfire[1]+5);
					end
				end
				
			end
		end
		
			
		lsSleep(delay_time)
		checkBreak()
		
	end
end
