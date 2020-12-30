-- boards.lua v1.1 -- Revised by Tallow, Rewrite by Manon to also click repair and use mostly OCR.
-- Run a set of Sawmills or Wood Planes to generate boards.
--

dofile("common.inc");
dofile("settings.inc");

bladeList = {"Slate Blade", "Flint Blade", "Bone Blade", "Carpentry Blade"};

function doit()
  promptParameters();
  askForWindow("Open and pin as many Wood Planes or Carpentry Shops as you want to use." ..
  "\n\nAutomatically planes boards from any number of Wood Plane or Carpentry Shop " ..
  "windows. Will repair the wood planes. Make sure to carry Slate blades!" ..
  "\n\nThe automato window must be in the TOP-RIGHT corner of the screen." ..
  "\nStand where you can reach all Wood Planes with all ingredients on you.");

  if(arrangeWindows) then
    arrangeInGrid(false, false, 360, 130);
  end

  while (true) do
    checkBreak();
    closePopUp();
    refreshWindows();
    repairBoards(); -- Repairs Wood Planes
    planeBoards(); -- Planes Boards
  end
end

function promptParameters()
  arrangeWindows = true;
  unpinWindows = true;
  carpShop = true;
  scale = 1.1;

  local z = 0;
  local is_done = nil;
  -- Edit box and text display
  while not is_done do
    -- Make sure we don't lock up with no easy way to escape!
    checkBreak();

    local y = 5;

    lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

    lsPrint(10, y, 0, scale, scale, 0xd0d0d0ff, "Blade:");
    blade = lsDropdown("Blade", 90, y, 0, 180, blade, bladeList);

    if blade == 1 then
        bladeName = "Slate Blade"
    elseif blade == 2 then
        bladeName = "Flint Blade"
    elseif blade == 3 then
        bladeName = "Bone Blade"
    elseif blade == 4 then
        bladeName = "Carpentry Blade"
    end

    carpShop = readSetting("carpShop",carpShop);
    carpShop = lsCheckBox(10, 40, z, 0xFFFFFFff, "Use carpentry shop", carpShop);
    writeSetting("carpShop",carpShop);

    lsPrintWrapped(10, 60, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
      "Will use Carpentry Shops instead of Wood Planes to plane boards.");

    arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
    arrangeWindows = lsCheckBox(10, 100, z, 0xFFFFFFff, "Arrange windows", arrangeWindows);
    writeSetting("arrangeWindows",arrangeWindows);

    lsPrintWrapped(10, 120, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
      "Will sort your pinned Wood Planes or Carpentry Shops into a grid on your screen.");

    unpinWindows = readSetting("unpinWindows",unpinWindows);
    unpinWindows = lsCheckBox(10, 160, z, 0xFFFFFFff, "Unpin windows on exit", unpinWindows);
    writeSetting("unpinWindows",unpinWindows);

    lsPrintWrapped(10, 180, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff,
      "On exit will close all windows when you close this macro.\n\nPress OK to continue.");

    if lsButtonText(10, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "OK") then
      is_done = 1;
    end

    if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
      "End script") then
      error "Clicked End Script button";
    end

    lsDoFrame();
    lsSleep(100);
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
  if not carpShop then
    clickAllImages("boards/repairWoodPlane.png")
  end
end

function planeBoards()
  srReadScreen();

    while 1 do
      -- Click pin ups to refresh the window
      clickAllImages("ThisIs.png");
      sleepWithStatus(500, "Refreshing");

    srReadScreen();
    local clickCount = 0;
    local ThisIsList = findAllImages("ThisIs.png");
    for i=1,#ThisIsList do
      local x = ThisIsList[i][0];
      local y = ThisIsList[i][1];
      local width = 285;
      local height = 250;
        if not carpShop then
          p = srFindImageInRange("boards/planeWood.png", x, y, width, height, 5000);
        else
          p = srFindImageInRange("boards/carpWood.png", x, y, width, height, 5000);
        end
          if(p) then
            closePopUp();
            waitForStats();
            safeClick(p[0]+4,p[1]+4);
            clickCount = clickCount + 1;
            srReadScreen();
          else
            p = srFindImageInRange("boards/upgrade.png", x, y, width, height, 5000);
            if(p) then
              safeClick(p[0]+4,p[1]+4);
              lsSleep(click_delay);
              srReadScreen();
                if bladeName == "Slate Blade" then
                  p = srFindImage("boards/installASlateBlade.png", 5000);
                elseif bladeName == "Flint Blade" then
                  p = srFindImage("boards/installAFlintBlade.png", 5000);
                elseif bladeName == "Bone Blade" then
                  p = srFindImage("boards/installABoneBlade.png", 5000);
                elseif bladeName == "Carpentry Blade" then
                  p = srFindImage("boards/installACarpentryBlade.png", 5000);
                end
                if(p) then
                  safeClick(p[0]+10,p[1]+10);
                  lsSleep(click_delay);
                  if bladeName == "Carpentry Blade" then
                    srReadScreen();
                    p = srFindImage("boards/quality.png", 5000);
                    if(p) then
                      safeClick(p[0]+4,p[1]+4);
                      lsSleep(click_delay);
                      srReadScreen();
                    end
                end
              end
            end
          end
        end
    end
end

function waitForStats()
  while 1 do
    checkBreak();
    srReadScreen();
    local stats = srFindImage("statclicks/endurance_black_small.png");
    if not stats then
      sleepWithStatus(999, "Waiting for Endurance timer to be visible and white")
    else
      break;
    end
  end
end

function cleanup()
  if(unpinWindows) then
    closeAllWindows();
  end
end

function closePopUp()
  while 1 do -- Perform a loop in case there are multiple pop-ups behind each other;
    checkBreak();
    srReadScreen();
    OK = srFindImage("OK.png");
    if OK then
      srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
      lsSleep(100);
    else
      break;
    end
  end
end
