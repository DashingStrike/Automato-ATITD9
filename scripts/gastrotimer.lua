-- gastrotimer v1.0 (for T9) by Ashen
--
-- Crude stopwatch for testing food pair durations before having Gastronomy 7
-- (for building the food grid).

dofile("common.inc");

askText = singleLine([[
Open your Talents (skills) window with default size and position it in the UPPER RIGHT corner of the screen. This script will watch for changes to the window to determine when food effects have started/stopped. Don't move while timer is running on food or it may be detected as food expiring. Click shift in ATITD window to begin.
]]);

doReset = false;
timerStarted = 0; 
timerText = "";
lastTimerText = "";

function gastroTimer()
	srReadScreen();

	statsChanged = checkStatsChanged();

	if statsChanged then
		doReset();
	else
		updateFoodTime();
	end
end

function doReset()
	lastTimerText = timerText;
	timerStarted = lsGetTimer();
	resetStatsImg();
	updateFoodTime();
end

function updateFoodTime()
	now = lsGetTimer();
	duration = math.floor(((now - timerStarted)) / 1000);
	hh = math.floor((duration / 3600)); duration = duration % 3600;
	mm = math.floor((duration / 60)); duration = duration % 60;
	ss = math.floor(duration);

	timerText = hh .. " : " .. mm .. " : " .. ss;
end

function checkStatsChanged()
	v = srFindImage("gastrostats.png", 5000);

	if (v == nil) then
		return true;
	end

	return false;
end

function resetStatsImg()
	srMakeImage("gastrostats.png", screensize[0]-125, 0, 125, 100);
end

function doDisplay()
	local y = 10;
	local x = 10;

	lsPrint(x, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	lsPrint(x, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	y = y + 40;

	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "CURRENT TIME");
	y = y + 40;

	lsPrint(x, y, 0, 1, 1, 0xB0B0B0ff, timerText);
	y = y + 40;

	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "PREVIOUS TIME");
	y = y + 40;

	lsPrint(x, y, 0, 1, 1, 0xB0B0B0ff, lastTimerText);

	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end

	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Reset") then
		doReset();
	end

	lsDoFrame();
end

function doit()
	askForWindow(askText);
	srReadScreen();
	screensize = srGetWindowSize();
	resetStatsImg();
	timerStarted = lsGetTimer();
	while true do
		gastroTimer();
		checkBreak();
		lsSleep(50);
		doDisplay();
	end
end

