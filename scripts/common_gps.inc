-----------------------------------------------------------
-- findCoords()
--
-- returns a Point object containing the current x and y
-- coordinates. Use this over fastFindCoords, which is
-- misnamed and is oddly significantly slower.
----------------------------------------------------------
function findCoords()
  local result = nil;
  local clockRegion = findClockRegion();
  local anchor = findText("Yea", clockRegion);
  if anchor then
    local lines = findAllText(nil, clockRegion);
--    for i=1,#lines do
--      lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));
--    end
    local x, y;
    for _, line in ipairs(lines) do
      local str = line[2];
      local start;
      start, _, x, y = string.find(str, ":  ([0-9- ]+), ([0-9- ]+)");
      if start then
        x = string.gsub(x, " ", "")
        y = string.gsub(y, " ", "")
        break;
      end
    end
--  One more check to ensure x and y have values. If they're nil, exit with a friendlier message than.
--  "wrong number of parameters sent to makePoint". -Tizuby
    if x == nil or y == nil then
      error("Could not find coordinates from the clock.\nIs the /clockloc visible or partially covered?");
    end
    result = makePoint(tonumber(x), tonumber(y));
    if not result[0] or not result[1] then
      result = nil;
      lsPrintln("Failed to find coords");
    else
      --lsPrintln("Coordinates: " .. result[0] .. ", " .. result[1]);
    end
  end
  srSetWindowInvertColorRange(minSetWindowInvertColorRange, maxSetWindowInvertColorRange); -- Reset color range back to default (defined at top of common_find.inc)
  return result;
end

function walkTo(dest)
  srReadScreen();
  local coords = findCoords();
    if not coords then
      error("Could not find coordinates from the clock.\nIs the /clockloc visible or partially covered?");
    end
  while coords[0] ~= dest[0] or coords[1] ~= dest[1] do
    while coords[0] < dest[0] do
      stepTo(makePoint(1, 0), dest); -- Walking East
      srReadScreen();
      coords = findCoords();
      checkBreak();
    end
    while coords[0] > dest[0] do
      stepTo(makePoint(-1, 0), dest); -- Walking West
      srReadScreen();
      coords = findCoords();
      checkBreak();
    end
    while coords[1] < dest[1] do
      stepTo(makePoint(0, -1), dest); -- Walking North
      srReadScreen();
      coords = findCoords();
      checkBreak();
    end
    while coords[1] > dest[1] do  -- Walking South
      stepTo(makePoint(0, 1), dest, 1); -- Add 1 (true for iconTrayCheck)
      srReadScreen();
      coords = findCoords();
      checkBreak();
    end
  end
  return coords;
end

local gpsInit = false;
local gpsCenter;
local gpsStep;

--------------------------------------------------------------
-- getTime(fmt)
--
-- fmt -  format of resultant text
--
-- Returns the date in minutes since epoch (Year 1, Akhet I-1, 12:00AM)
-- Returns nil if the date cannot be obtained
---------------------------------------------------------------
function getTime(fmt)
   local t = findAllText("Year", nil, nil, NOPIN);
   if t == nil then
      return t;
   end
   for i=1, #t do
      local year, season, month, day, hour, minute, ampm = string.match(t[i][2], "Year (%d+), (%a+) (%a+)-(%d+), (%d+):(%d+)(%a+)");
      if year and season and month and day and hour and minute then
         -- perform data validation
         local seasonIndex = {};
         seasonIndex["Akhet"] = 1;
         seasonIndex["Peret"] = 2;
         seasonIndex["Shemu"] = 3;
         local monthIndex = {};
         monthIndex["I"] = 1;
         monthIndex["II"] = 2;
         monthIndex["III"] = 3;
         monthIndex["IV"] = 4;
         year = tonumber(year);
         day = tonumber(day);
         hour = tonumber(hour);
         minute = tonumber(minute);
         season = seasonIndex[season];
         month = monthIndex[month];
         if ampm == "AM" then
            ampm = 0;
         elseif ampm == "PM" then
            ampm = 12;
         else
            ampm = nil;
         end
         if year and season and month and day and hour and minute and ampm then
            if fmt ~= nil then
               return t[i][2];
            end
            if hour == 12 then
               hour = 0;
            end
            hour = hour + ampm;
            local seasons = (year - 1)*3 + season;
            local months = (seasons - 1)*4 + month;
            local days = (months - 1)*30 + day;
            local hours = (days - 1)*24 + hour;
            local minutes = hours*60 +  minute;
            return minutes;
         end
      end
   end
   return nil;
end

function initStep()
  if not gpsInit then
    srReadScreen();
    gpsInit = true;
    -- Macro written with 1720 pixel wide window

    xyWindowSize = srGetWindowSize();

    local pixel_scale = xyWindowSize[0] / 1720;
    lsPrintln("pixel_scale " .. pixel_scale);

    gpsStep = makePoint(340*pixel_scale, 380*pixel_scale);

    local walk_x_drift = 14;
    local walk_y_drift = 18;
    if (lsScreenX < 1280) then 
      -- Have to click way off center in order to not move at high resolutions
      walk_x_drift = math.floor(walk_x_drift * pixel_scale);
      walk_y_drift = math.floor(walk_y_drift * pixel_scale);
    else
      -- Very little drift at these resolutions, clicking dead center
      -- barely moves
      walk_x_drift = 1;
      walk_y_drift = 1;
    end

    gpsCenter = makePoint(xyWindowSize[0] / 2 - walk_x_drift,
			  xyWindowSize[1] / 2 + walk_y_drift);
  end
end

function stepTo(dir, dest, checkIconTray)
  local iconTrayOffsetY = 50;
  local message = ""
  initStep();
  local centerScreenBottom = makePoint(xyWindowSize[0]/2, xyWindowSize[1]); -- xyWindowSize already defined in global from previous initStep();

  if checkIconTray then
    local iconTrayOpen = srFindImageInRange("icon_tray_opened.png", centerScreenBottom[0]-450, centerScreenBottom[1]-120, 200, 120); -- Check if icon tray is open, screenRead performed by initStep();
    local iconTrayClose = srFindImageInRange("icon_tray_closed.png", centerScreenBottom[0]-80, centerScreenBottom[1]-80, 200, 80); -- Check if icon tray is closed, screenRead performed by initStep();
      if iconTrayOpen then
        iconTrayOffsetY = 50; -- offset clicking Y position to avoid clicking icon tray (where grass, water, etc icons exist).
      elseif iconTrayClose then
        iconTrayOffsetY = 30; -- offset clicking Y position to avoid the up arrow, on icon tray and re-opening it.
      end
  end

  safeClick(gpsCenter[0] + dir[0] * gpsStep[0],
	    (gpsCenter[1] + dir[1] * gpsStep[1]) - iconTrayOffsetY);
  sleepWithStatus(500, "Walking to: " .. dest[0] .. ", " .. dest[1], nil, 0.7, 0.7);
end

local ffc_coordsPos = nil;
local ffc_dash = -1;
local ffc_comma = -2;

------------------------------------------------------------------------------------
-- fastFindCoords()
--
-- DEPRECATED. Less reliable and nearly 10x slower than findCoords().
-- Use findCoords() instead. Returns the current coordinates as a Point object.
------------------------------------------------------------------------------------
function fastFindCoords()
	local pos;
	if(not ffc_coordsPos) then
		pos = srFindImage("Year.png",5000);
		if(not pos) then
			pos = findText("Year");
			if(not pos) then
				for i=1,9 do
					pos = findText("ar " .. i .. ", ");
					if(pos) then
						break
					end
				end
				
				if(not pos) then
					lsPrintln("fastFindCoords() : Can't find the clock");
					return nil;
				end
			end
		end
		local window = getWindowBorders(pos[0], pos[1]);
    srReadScreen(); -- required due to image search functions after a potential text search.
		window.top = window.top + 13;
		window.y = window.y + 13;
		window.height = window.height - 13;
		window.bottom = window.y + window.height;
		pos = srFindImageInRange("colon.png", window.x, window.y, window.width, window.height,5000);
		if(not pos) then
			lsPrintln("fastFindCoords() : Can't find the colon on the second line of the clock");
			return nil;
		end
		window.width = window.width + window.x - pos[0] - 5;
		window.left = pos[0] + 5;
		window.x = pos[0] + 5;
		window.right = window.x + window.width;
		window.top = pos[1];
		window.y = window.top;
		window.height = window.bottom - window.top;
		ffc_coordsPos = window;
	end
	if(not ffc_coordsPos) then
		lsPrintln("fastFindCoords() : Can't find the coordinates");
		return nil;
	end
	
	local digits = ffc_readDigits(ffc_coordsPos);
	if(digits) then
		return ffc_parseDigits(digits);
	end
	return nil;
end

-----------------------------------------------------------------------------
-- ffc_parseDigits(digits)
--
-- Helper function for fastFindCoords(). Deprecated.
-----------------------------------------------------------------------------
function ffc_parseDigits(digits)
	local x;
	local pos;
	x, pos = ffc_parseOneCoord(digits);
	local y;
	y, pos = ffc_parseOneCoord(digits,pos);
	if((not x) or (not y)) then
		if(not x) then
			lsPrintln("fastFindCoords() : x is nil");
		end
		if(not y) then
			lsPrintln("fastFindCoords() : y is nil");
		end
		return nil;
	end
	return makePoint(x,y);
end

-------------------------------------------------------------------------------
-- ffc_parseOneCoord(digits, pos)
--
-- Helper function for fastFindCoords(). Deprecated.
------------------------------------------------------------------------------
function ffc_parseOneCoord(digits,pos)
	if(pos == nil) then
		pos = 1;
	end
	if(pos > #digits) then
		lsPrintln("ffc_parseOneCoord(): pos > #digits(" .. #digits .. ")");
		return nil, nil;
	end
	local negative = false;
	local val = 0;
	local i;
	for i=pos,#digits do
		if(digits[i][2] == ffc_comma) then
			if(negative) then
				val = val * -1;
			end
			return val, i+1;
		end
		if(digits[i][2] == ffc_dash) then
			negative = true;
		else
			val = val * 10 + digits[i][2];
		end
	end
	if(negative) then
		val = val * -1;
	end
	return val, #digits+1;
end

-----------------------------------------------------------------------------
-- ffc_readDigits(box)
--
-- Helper function for fastFindCoords(). DEPRECATED.
-----------------------------------------------------------------------------
function ffc_readDigits(box)
	local digits = {};
	local i;
	for i=0,9 do
		local x = ffc_coordsPos.x;
		local pos = true;
		while((x < ffc_coordsPos.x + ffc_coordsPos.width - 6) and pos) do
			pos = srFindImageInRange(i .. ".png",x,ffc_coordsPos.y,ffc_coordsPos.width,ffc_coordsPos.height,5000);
			if(pos) then
				digits[#digits+1] = {pos[0],i};
				x = pos[0] + 7;
			end
		end
	end
	if(#digits < 2) then
		lsPrintln("ffc_readDigits() : Unable to read any digits");
		return nil;
	end
	local x = ffc_coordsPos.x;
	local pos = true;
	while(pos) do
		pos = srFindImageInRange("dash.png",x,ffc_coordsPos.y,ffc_coordsPos.width,ffc_coordsPos.height,5000);
		if(pos) then
			digits[#digits+1] = {pos[0],ffc_dash};
			x = x + 5;
		end
	end
	pos = srFindImageInRange("comma.png",ffc_coordsPos.x,ffc_coordsPos.y,ffc_coordsPos.width,ffc_coordsPos.height,5000);
	if(pos) then
		digits[#digits+1] = {pos[0],ffc_comma};
	end
	table.sort(digits, ffc_compareDigits);
	return digits;
end

-----------------------------------------------------------------------------
-- ffc_compareDigits(left,right)
--
-- Helper function for fastFindCoords(). DEPRECATED.
-----------------------------------------------------------------------------
function ffc_compareDigits(left,right)
	if(left[1] < right[1]) then
		return true;
	end
	return false;
end
