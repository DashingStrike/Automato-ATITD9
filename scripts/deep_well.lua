dofile("common.inc");

function doit()
  askForWindow(
    "Pin Deep Well window(s)\n\n"..
    "Will auto repair if leather/oil in inventory\n\n" ..
    "Start the macro."
  );

  while true do
    checkBreak();
    waitForEnd();

    local wells = findAllText("This is a Deep Well", nil, REGION);
    if #wells == 0 then
      error "Did not find any Deep Wells";
    end

    local minTension = nil;
    local targetWell = nil;
    for i = 1, #wells do
      local tension = getTension(wells[i]);
      if tension ~= nil then
        if minTension == nil or tension < minTension then
          targetWell = wells[i];
          minTension = tension;
        end
      end
    end

    if repair(targetWell) and minTension < 100 then
      local wind = findText("Wind", targetWell);
      clickText(wind);
    end

    sleepWithStatus(1000, getStatus());
  end
  lsPlaySound("complete.wav")
end

function getStatus()
  srReadScreen();
  local wells = findAllText("This is a Deep Well", nil, REGION);
  if #wells == 0 then
    error "Did not find any Deep Wells";
  end

  local status = "Wells:\n\n";
  for i = 1, #wells do
    safeClick(wells[i].x, wells[i].y);
    local tension = getTension(wells[i]);
    if tension ~= nil then
      status = status .. i .. ". Tension: " .. tension .. "\n";
    end
  end

  return status;
end

function waitForEnd()
  while true do
    checkBreak();
    srReadScreen();
    if srFindImage("endurance.png") then
      return true;
    elseif srFindImage("endurance2.png") then
      return true;
    elseif srFindImage("endurance3.png") then
      return true;
    end

    sleepWithStatus(1000, "Waiting on endurance\n\n" .. getStatus());
  end
end

function getTension(well)
  srReadScreen();
  local spring = findText("Spring Tension", well);
  if spring == nil then
    return nil;
  end
  return tonumber(string.match(spring[2], "Spring Tension is ([-0-9]+)"));
end

function repair(well)
  local repair = findText("Repair", well)
  if repair then
    clickText(repair);
    lsSleep(500);
    srReadScreen();
    local ok = findAllImages("Ok.png");
    if ok then
      clickAllPoints(ok);
      lsSleep(500);
      srReadScreen();
    end

    if findText("Wind", well) == nil then
      unPin(well);
      return false;
    end
  end

  return true;
end

function unPin(well)
  srReadScreen();
  local unpin = findAllImages("UnPin.png", well);
  clickAllPoints(unpin, nil, nil, true);
end
