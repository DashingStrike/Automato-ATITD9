-- autorun "plus" v1.1 by Ashen
--
-- Auto run, dig for shards, inspect weeds, and forage.

dofile("common.inc");

askText = singleLine([[
This script adds a crude auto-run support to ATITD, with convenient
single-click actions for common things one tends to do while running
all over Egypt that normally take multiple clicks. Press SHIFT in
the ATITD window to begin.
]]);

lastX = 0;
lastY = 0;
autorun = false;

function doDisplay()
	local y = 6;
	local x = 10;

	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	y = y + 12;
	lsPrint(x, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	y = y + 40;

	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Press CTRL to toggle Autorun");
	y = y + 40;

	if (autorun) then
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Autorun ON");
	else
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Autorun OFF");
	end

	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end

	lsDoFrame();
end

function doit()
	local mousePos = askForWindow(askText);
	windowSize = srGetWindowSize();
	local ctr = 0;
	local xyScreenSize = srGetWindowSize();
	while true do
		if ((ctr % 10) == 0) then
			srReadScreen();
			clickAllText("Dig under");
			clickAllText("Forage this");
			clickAllText("Inspect this");
		end

		if (lsControlHeld()) then
			autorun = not autorun;
			while (lsControlHeld()) do
				checkBreak();
				lsSleep(50);
			end
			if (autorun) then
				safeClick(xyScreenSize[0] / 2, xyScreenSize[1] / 3);
			else
				safeClick(xyScreenSize[0] / 2, xyScreenSize[1] / 3, true);
			end
		end

		if (autorun) then
			if ((ctr % 30) == 0) then
				safeClick(xyScreenSize[0] / 2, xyScreenSize[1] / 3);
			end
		end

		checkBreak();
		lsSleep(50);
		ctr = ctr + 1;
		doDisplay();
	end
end
