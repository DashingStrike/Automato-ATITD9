-- Open windows with window_opener.lua
-- Arrange them with winder_arranger.lua in paper press mode
-- Run this
-- Profit!

dofile("common.inc");
dofile("settings.inc");

askText = singleLine([[
  Paper Presses v2.0 (by Larame - adaptation from T8) --
  Automatically runs many paper presses, adding/removing linen as necessary. Make sure the
  VT window is in the TOP-RIGHT corner of the screen.
]])

wmText = "Tap Ctrl on paper presses to open and pin.\nTap Alt on paper presses to open, pin and stash.";

local per_click_delay = 0;
num_loops = 0;

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

function waitForChange()
	local c=0;
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
	end
	-- lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end

function refocus()
	statusScreen("Refocusing...");
	for i=2, #window_locs do
		setWaitSpot(window_locs[i][0], window_locs[i][1]);
		srClickMouseNoMove(window_locs[i][0] + 321, window_locs[i][1] + 74);
		waitForChange();
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

function clickAllText(txt)
  srReadScreen();
  this = findAllText(txt);
  for i=1,#this do
    clickText(this[i]);
    lsSleep(100);
  end
  lsSleep(200);
end

function doit()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow(askText);
  windowManager("Paper Press Setup", wmText, false, true, 420, 145, nil, 10, 25);
  askForFocus();
  unpinOnExit(doPaper);
end

function doPaper()
	for i=1, num_loops do

		-- refresh windows
		refreshWindows();
		lsSleep(200);
		-- refocus();
		
		clickAllText("Line the press with Linen");
		lsSleep(200);
		-- refocus();

		clickAllText("Make some papyrus paper");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(75000, "[" .. i .. "/" .. num_loops .. "] Waiting for 1st batch of paper to finish", nil, 0.7);

		clickAllText("Make some papyrus paper");
		lsSleep(200);
		-- refocus();

		sleepWithStatus(75000, "[" .. i .. "/" .. num_loops .. "] Waiting for 2nd batch of paper to finish", nil, 0.7);

		clickAllText("Remove the Linen from the press");
		lsSleep(200);
		-- refocus();

		clickAllText("Take...");
		lsSleep(200);

		clickAllText("Everything");
		lsSleep(200);
		
	end
end