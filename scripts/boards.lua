-- boards.lua v1.1 -- Revised by Tallow, Rewrite by Manon to also click repair and use mostly OCR.
-- Run a set of Sawmills or Wood Planes to generate boards.
--

dofile("common.inc");


function doit()
	promptParameters();
	askForWindow("Open and pin as many Wood Planes as you want to use.\n\nAutomatically planes boards from any number of Wood Plane or Carpentry Shop windows. Will repair the wood planes. Make sure to carry Slate blades!\n\nThe automato window must be in the TOP-RIGHT corner of the screen.\nStand where you can reach all Wood Planes with all ingredients on you.\nYou need to have 'Use the chat area instead of popups for many messages' enabled in the interface options.");
    if(arrangeWindows) then
		arrangeInGrid(false, false, 360, 130);
		while (true) do
        	checkBreak();
        	refreshWindows();
        	repairBoards(); -- Repairs Wood Planes
        	planeBoards(); -- Planes Boards
        end
    end
end

function promptParameters()
	arrangeWindows = true;
	unpinWindows = true;
	scale = 1.1;

	local z = 0;
	local is_done = nil;
	local value = nil;
	-- Edit box and text display
	while not is_done do
		-- Make sure we don't lock up with no easy way to escape!
		checkBreak();

		local y = 5;

		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, 
			"Board Maker V2.0 Rewrite by Manon for T9\n\n");

		arrangeWindows = lsCheckBox(10, 40, z, 0xFFFFFFff, "Arrange windows", arrangeWindows);
		y = y + 32;

lsPrintWrapped(10, 60, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, 
			"Will sort your pinned Wood Planes into a grid on your screen.");

		unpinWindows = lsCheckBox(10, 100, z, 0xFFFFFFff, "Unpin windows on exit", unpinWindows);
		y = y + 32;

		lsPrintWrapped(10, 120, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, 
			"On exit will close all windows when you close this macro.\n\nPress OK to continue.");

		if lsButtonText(10, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end

		if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
			"End script") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(tick_delay);
	end
	if(unpinWindows) then
		setCleanupCallback(cleanup); -- unpin all open windows 
	end
end

function refreshWindows()
    srReadScreen();
    this = findAllText("This is");
    for i=1,#this do
        clickText(this[i]);
    end
    lsSleep(100);
end

function repairBoards()
    srReadScreen();
    clickrepair = findAllText("Repair this Wood Plane");
    for i=1,#clickrepair do
        clickText(clickrepair[i]);
        lsSleep(100);
    end
end

function planeBoards()
    srReadScreen();
    clickplane = findAllText("Plane a piece");
    woodplane = findAllText("Wood Plane")
    statusScreen("Found " .. #woodplane .. " Wood Planes.\nPlaning  " .. #clickplane .. " Boards\nRepairing " .. #clickrepair .. " Wood Planes.");
    for i=1,#clickplane do
        clickText(clickplane[i]);
        lsSleep(100);
    end
end

function cleanup()
	if(unpinWindows) then
		closeAllWindows();
	end
end
