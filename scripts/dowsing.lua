-- dowsing v1.1 (T9) by Ashen
--
-- Repeatedly dowses whenever able, keeping a log of dowse results in dowsing.txt

dofile("common.inc");

askText = singleLine([[
	Click shift in ATITD window.
]]);

lastX = 0;
lastY = 0;
autorun = false;
statustxt = "";

function doDowse()
	t = srFindImage("dowsing.png", 0);
	if t then
		safeClick(t[0] + 5, t[1] + 5);
		return true;
	end

	return false;
end

function writeDowseLog(text)
	logfile = io.open("dowsing.txt","a+");
	logfile:write(text .. "\n");
	logfile:close();
end

function checkIfMain(chatText)
	for j = 1, #chatText do
		if string.find(chatText[j][2], "^%*%*", 0) then
			return true;
		end
	end
	return false;
end

function getDowseResult()
	srReadScreen();
	local chatText = getChatText();
	local onMain = checkIfMain(chatText);

	if not onMain then
		lsPlaySound("boing.wav");
	end

	-- Wait for Main chat screen and alert user if its not showing
	while not onMain do
		checkBreak();
		srReadScreen();
		chatText = getChatText();
		onMain = checkIfMain(chatText);
		sleepWithStatus(500, "Looking for Main chat screen...\n\nMake sure main chat tab is showing and that the window is sized, wide enough, so that no lines wrap to next line.\n\nAlso if you main chat tab is minimized, you need to check Options, Interface Option, Minimized chat-channels are still visible.", nil, 0.7);
	end

	lastLine = chatText[#chatText][2];
	lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));

	foundSand, x, y = string.match(lastLineParse, "You detect nothing but sand at (%D+) ([-0-9]+) ([-0-9]+)");

	if (foundSand) then
		if ((x ~= lastX) or (y ~= lastY)) then
			writeDowseLog(x .. "," .. y .. "," .. "Sand");
			statustxt = "Sand at " .. x .. "," .. y;
			lastX = x;
			lastY = y;
		end
		return;
	end

	foundOre, x, y = string.match(lastLineParse, "You detect an underground vein of (%D+) at %D+ ([-0-9]+) ([-0-9]+)");

	if (foundOre) then
		if ((x ~= lastX) or (y ~= lastY)) then
			lsPlaySound("cymbals.wav");
			writeDowseLog(x .. "," .. y .. "," .. foundOre);
			statustxt = foundOre .. " at " .. x .. "," .. y;
			lastX = x;
			lastY = y;
		end
		return;
	end

	foundOre, x, y = string.match(lastLineParse, "You detect a vein of (%D+), somewhere nearby %D+ ([-0-9]+) ([-0-9]+)");

	if (foundOre) then
		if ((x ~= lastX) or (y ~= lastY)) then
			lsPlaySound("cymbals.wav");
			writeDowseLog(x .. "," .. y .. "," .. foundOre .. " nearby");
			statustxt = foundOre .. " near " .. x .. "," .. y;
			lastX = x;
			lastY = y;
		end
	end
end

function doDisplay()
	local y = 6;
	local x = 10;

	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	y = y + 12;
	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	y = y + 24;
	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Press CTRL to toggle autorun");
	y = y + 40;

	if (autorun) then
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Autorun ON");
	else
		lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Autorun OFF");
	end

	y = y + 40;
	lsPrint(x, y, 0, 0.7, 0.7, 0xB0B0B0ff, statustxt);

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

		if ((ctr % 10) == 0) then
			srReadScreen();
			doDowse();
			getDowseResult();
		end

		checkBreak();
		lsSleep(50);
		ctr = ctr + 1;
		doDisplay();
	end
end
