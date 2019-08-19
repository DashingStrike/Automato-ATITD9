-- boards.lua v1.1 -- Revised by Tallow, modified by Manon to also click repair.
--
-- Run a set of sawmills to generate boards.
--

dofile("common.inc");

askText = singleLine([[
  Board Maker v1.1 (Revised by Tallow) --
  Automatically planes boards from any number of Wood Plane or
  Carpentry Shop windows. Will also repair the wood planes.
  Make sure the VT window is in the TOP-RIGHT corner of the screen.
]]);

wmText = "Tap Ctrl on Wood Planes or Carpentry\nBenches to open and pin.\n\nTap Alt to open, pin and stash.";

--Amount of time to pause after clicking the plane woods button (ms)
pause_time = 100; 

function doit()
  askForWindow(askText);
  askForFocus();
  planeBoards()
end

function planeBoards()
  while 1 do
    -- Click pin ups to refresh the window
    clickAllImages("ThisIs.png");
    sleepWithStatus(200, "Refreshing");

    
    -- Find buttons and click them!
    local clickCountPlane = clickAllImages("boards/PlaneAPiece.png");
    if clickCountPlane > 0 then
      sleepWithStatus(pause_time, "Planing " .. clickCountPlane .. " windows");
    end
    local clickCountRepair = clickAllImages("boards/Repair.png");
    if clickCountRepair > 0 then
      sleepWithStatus(pause_time, "Repaired " .. clickCountRepair .. " windows");
    end
    local OK = clickAllImages("ok.png");
    if  OK > 0 then
      sleepWithStatus(pause_time, "Closing " .. OK .. " popup windows");
    end
  end
  return quit_message;
end
