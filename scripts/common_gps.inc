-----------------------------------------------------------
-- findCoords()
--
-- returns a Point object containing the current x and y
-- coordinates. Use this over fastFindCoords, which is
-- misnamed and is oddly significantly slower.
----------------------------------------------------------
function findCoords()
  local result = nil;
  local str = nil;
  local clockRegion = findClockRegion();
  local anchor = findText("Yea", clockRegion);
  if anchor then
    local lines = findAllText(nil, clockRegion);
    for i=1,#lines do
      --lsPrintln("LINE " .. i .. " : " .. table.concat(lines[i], ","));
	if i == 2 then
	  str = lines[i];
	end
    end

	  -- Numeral 1 always has a space before and/or after it.  This attempts to repair that OCR flaw. All other numbers have no space.
	  str = str[2];
	  str = string.gsub(str, " 1", "1");
	  str = string.gsub(str, "1 ", "1");


	  -- Misc Exceptions we want to strip
	  str = string.gsub(str, "0::#", ":"); -- Giza Exception
	  str = string.gsub(str, "#t#", ":"); -- Napata Exception occurs at minimum: 0, -6327
	  str = string.gsub(str, "<=t", "");
	  str = string.gsub(str, "#u", ":"); -- Zau Exception

	  -- Attempt to find the : to fetch coordinates, but also look at some exceptions
	  if string.find(str, ": ([0-9-]+)") then
	    str = string.sub(str, string.find(str, ": ([0-9-]+)")+2, string.len(str));

	  elseif string.find(str, ":([0-9-]+)") then
	    str = string.sub(str, string.find(str, ":([0-9-]+)")+1, string.len(str));

	  elseif string.find(str, ":#([0-9-]+)") then
	    str = string.sub(str, string.find(str, ":#([0-9-]+)")+1, string.len(str));
	    str = string.gsub(str, "#", ""); -- Remove # sign, sometimes misread by OCR in Meshwesh Delta

	  elseif string.find(str, "<# ([0-9-]+)") then
	    str = string.sub(str, string.find(str, "<# ([0-9-]+)")+1, string.len(str));
	    str = string.gsub(str, "# ", ""); -- East Sinai weird scenario
	  end

	  str = string.gsub(str, "  ", ","); -- Catch double space between numbers
	  str = string.gsub(str, " ", ",");  -- Catch single space between numbers
	  local coords = explode(",", str);

	    for i=1,#coords do
            x = tonumber(coords[1])
            y = tonumber(coords[2])
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
  end -- if anchor
  srSetWindowInvertColorRange(minSetWindowInvertColorRange, maxSetWindowInvertColorRange); -- Reset color range back to default (defined at top of common_find.inc)
  return result;
end


-----------------------------------------------------------
-- walkTo(dest)
--
-- dest needs to be x,y
-- global: bool globalWalkingStop is checked while walking
-- ie if your script sets a global of globalWalkingStop = 1 then walking is cancelled
-- global: bool globalWalking = true is set while walking. Set back to nil when walking is finished.
----------------------------------------------------------

function walkTo(dest)
  srReadScreen();
  local coords = findCoords();
    if not coords then
      error("Could not find coordinates from the clock.\nIs the /clockloc visible or partially covered?");
    end
  globalWalking = 1;
  globalWalkingStop = nil;
  while coords[0] ~= dest[0] or coords[1] ~= dest[1] do
    while coords[0] < dest[0] do
      stepTo(makePoint(1, 0), dest); -- Walking East
      srReadScreen();
      coords = findCoords();
      checkBreak();
      if globalWalkingStop then break; end
    end
    while coords[0] > dest[0] do
      stepTo(makePoint(-1, 0), dest); -- Walking West
      srReadScreen();
      coords = findCoords();
      checkBreak();
      if globalWalkingStop then break; end
    end
    while coords[1] < dest[1] do
      stepTo(makePoint(0, -1), dest, "North"); -- Walking North
      srReadScreen();
      coords = findCoords();
      checkBreak();
      if globalWalkingStop then break; end
    end
    while coords[1] > dest[1] do  -- Walking South
      stepTo(makePoint(0, 1), dest, "South");
      srReadScreen();
      coords = findCoords();
      checkBreak();
      if globalWalkingStop then break; end
    end
  if globalWalkingStop then break; end
  end
  srClickMouseNoMove(5, 5, 1); -- right click to force avatar to stop running. Rarely happens, mainly when zoomed out quite a bit.
  globalWalking = nil;
  globalWalkingStop = nil;
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
-- if fmt == "date" then Returns Date (Shemu I-30) - ie getTime("date")
-- if fmt == "time" then Returns Time (8:52AM) - ie getTime("time")
-- if fmt == "time2" then Returns Time in special format (8_52AM) - ie getTime("time2")
-- if fmt == "datetime2" then Returns date/time in special format (Akhet_I-1_12_00AM) - ie getTime("datetime2")
-- if fmt == "datetime3" then Returns date/time in special format (1_Akhet_I-1_12_00AM) - ie getTime("datetime3")
-- if fmt == nil, then Returns the date in minutes since epoch (123456) - ie getTime()
-- if fmt ~= nil then Returns the date in minutes since epoch (Year 1, Akhet I-1, 12:00AM) - ie getTime(1)
--
-- Returns nil if the date cannot be obtained
---------------------------------------------------------------
function getTime(fmt)
   local str = nil;
   local datetime = nil;
   local date = nil;
   local time = nil;
   local datetime2 = nil;
   local t = findAllText("Year", findClockRegion());

   if #t == 0 then
      return nil;
   end

    for i=1,#t do
      --lsPrintln("LINE " .. i .. " : " .. table.concat(t[i], ","));
	if i == 1 then
	  str = t[i][2];
	end
    end

   -- Strip spaces - Fixes issue where one's (1) will show as a space before and after it. ie 11 shows as 1 1
   str = string.gsub(str, " 1", "1");
   str = string.gsub(str, "1 ", "1");
   str = string.gsub(str, "AMl", "AM");
   str = string.gsub(str, "PMl", "PM");
   str = string.gsub(str, "Axet", "Akhet");
   str = string.gsub(str, "l~", "lV");

      local year, season, month, day, hour, minute, ampm = string.match(str, "Year (%d+) (%a+) (%a+)-(%d+) (%d+):(%d+)(%a+)");
      if year and season and month and day and hour and minute then
         month = string.gsub(month, "l", "I"); -- Change small "L" (misinterpreted) back to capital I
         datetime = "Year " .. year .. ", " .. season .. " " .. month .. "-" .. day .. ", " .. hour .. ":" .. minute .. ampm
         date = season .. " " .. month .. "-" .. day
         time = hour .. ":" .. minute .. ampm
         time2 = hour .. "_" .. minute .. ampm
         datetime2 = season .. "_" .. month .. "-" .. day .. "_" .. hour .. "_" .. minute .. ampm
         datetime3 = year .. "_" .. season .. "_" .. month .. "-" .. day .. "_" .. hour .. "_" .. minute .. ampm
         -- perform data validation
         local seasonIndex = {};
         seasonIndex["Akhet"] = 1;
         seasonIndex["Peret"] = 2;
         seasonIndex["Shemu"] = 3;
         local monthIndex = {};
         --Beware on T9, the clock reads "I" as lower cased "L" or "l"
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
            if fmt == "date" then
               return date;
            elseif fmt == "time" then
               return time;
            elseif fmt == "time2" then
               return time2;
            elseif fmt == "datetime2" then
               return datetime2;
            elseif fmt == "datetime3" then
               return datetime3;
            elseif fmt ~= nil then
               return datetime;
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

function stepTo(dir, dest, compass)
  local offsetY = 0;
  local message = ""
  initStep();
  if compass == "North" then
    offsetY = 50;  -- Postive offset need to prevent clicking on ATITD Clock
  elseif compass == "South" then
    offsetY = -65; -- Negative offset needed to prevent clicking on Icon Tray
  end
  safeClick(gpsCenter[0] + dir[0] * gpsStep[0],
	    (gpsCenter[1] + dir[1] * gpsStep[1]) + offsetY);
  sleepWithStatus(500, dest[0] .. ", " .. dest[1] .. "\n\n" .. coord2region(dest[0], dest[1]), nil, 0.7, "Walking to");
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

-----------------------------------------------------------------------------
-- coord2region(x, y)
--
-- Returns a region name - Valid for T9
-----------------------------------------------------------------------------
function coord2region(x,y)
  if not x  or not y then
    x = 9999;
    y = 9999;
  end

  if x >=-3072 and x <= -745 and y >=7445 and y <= 8192 then
    regionName = "Cyrene"
  elseif x>=2795 and x<=3220 and y>=3385 and y<=3785 then
    regionName = "Hinterlands"
  elseif x>=-3072 and x<=-1910 and y>=6375 and y<=7445 then
    regionName = "Hamim"
  elseif x>=-3072 and x<=-1625 and y>=5150 and y<=6375 then
    regionName = "Bahariya Oasis"
  elseif x>=-3072 and x<=-1910 and y>=3955 and y<=5150 then
    regionName = "Ammonium"
  elseif x>=-3072 and x<=-1910 and y>=2985 and y<=3955 then
    regionName = "Dunqul Oasis"
  elseif x>=-3072 and x<=-1345 and y>=965 and y<=2985 then
    regionName = "Dakhla Oasis"
  elseif x>=-3072 and x<=-350 and y>=-725 and y<=965 then
    regionName = "Buhen"
  elseif x>=-3072 and x<=-1285 and y>=-8192 and y<=-6500 then
    regionName = "Meroe Desert"
  elseif x>=-3072 and x<=-900 and y>=-5690 and y<=-2320 then
    regionName = "Western Desert"
  elseif x>=-3072 and x<=130 and y>=-6500 and y<=-5020 then
    regionName = "Napata"
  elseif x>=945 and x<=3152 and y>=-8192 and y<=-7088 then
    regionName = "Nubia"
  elseif x>=-1285 and x<=1065 and y>=-8192 and y<=-5020 then
    regionName = "Blue Nile"
  elseif x>=-1910 and x<=-745 and y>=6375 and y<=7445 then
    regionName = "Wadi Natrun"
  elseif x>=-1625 and x<=450 and y>=5860 and y<=6625 then
    regionName = "Faiyum"
  elseif x>=-745 and x<=155 and y>=6625 and y<=8192 then
    regionName = "Zau"
  elseif x>=155 and x<=1660 and y>=6625 and y<=8192 then
    regionName = "Meshwesh Delta"
  elseif x>=1660 and x<=2328 and y>=6336 and y<=8192 then
    regionName = "Bitter Lakes"
  elseif x>=2328 and x<=3700 and y>=6336 and y<=8192 then
    regionName = "West Sinai"
  elseif x>=3700 and x<=5120 and y>=6176 and y<=8192 then
    regionName = "East Sinai"
  elseif x>=4255 and x<=5120 and y>=3785 and y<=6176 then
    regionName = "Timna"
  elseif x>=2795 and x<=4255 and y>=3785 and y<=6336 then
    regionName = "South Sinai"
  elseif x>=1860 and x<=2795 and y>=4350 and y<=6336 then
    regionName = "Arsinoe"
  elseif x>=1165 and x<=1860 and y>=5240 and y<=6625 then
    regionName = "Suez"
  elseif x>=155 and x<=1860 and y>=4350 and y<=5570 then
    regionName = "Herakleopolis"
  elseif x>=-1345 and x<=190 and y>=2500 and y<=4530 then
    regionName = "Kharga Oasis"
  elseif x>=450 and x<=1165 and y>=5570 and y<=6625 then
    regionName = "Giza"
  elseif x>=-1910 and x<=-1345 and y>=2985 and y<=5150 then
    regionName = "Nabta Playa"
  elseif x>=2795 and x<=4255 and y>=3785 and y<=6336 then
    regionName = "South Sinai"
  elseif x>=190 and x<=2795 and y>=3385 and y<=4350 then
    regionName = "Hermopolis"
  elseif x>=190 and x<=1985 and y>=2750 and y<=3385 then
    regionName = "Abydos"
  elseif x>=1985 and x<=3220 and y>=2100 and y<=3385 then
    regionName = "Naqada"
  elseif x>=3220 and x<=4515 and y>=1856 and y<=3785 then
    regionName = "Gebel"
  elseif x>=3975 and x<=5120 and y>=-1030 and y<=860 then
    regionName = "Pwenet"
  elseif x>=4515 and x<=5120 and y>=860 and y<=3785 then
    regionName = "Arabia"
  elseif x>=1630 and x<=4515 and y>=465 and y<=2100 then
    regionName = "Red Sea"
  elseif x>=-1625 and x<=450 and y>=4530 and y<=5860 then
    regionName = "Lahun"
  elseif x>=190 and x<=1985 and y>=1360 and y<=2750 then
    regionName = "Asyut"
  elseif x>=-350 and x<=1985 and y>=-1415 and y<=-87 then
    regionName = "Swenett"
  elseif x>=500 and x<=2795 and y>=-3135 and y<=-1310 then
    regionName = "Upper Egypt"
  elseif x>=1630 and x<=3975 and y>=-1415 and y<=465 then
    regionName = "Bernike"
  elseif x>=-350 and x<=1630 and y>=-87 and y<=1360 then
    regionName = "Thebes"
  elseif x>=-1345 and x<=190 and y>=965 and y<=2500 then
    regionName = "Akhetaton"
  elseif x>=-3072 and x<=-350 and y>=-2320 and y<=-725 then
    regionName = "Kerma"
  elseif x>=-900 and x<=500 and y>=-3135 and y<=-1310 then
    regionName = "Philae"
  elseif x>=2795 and x<=5120 and y>=-2675 and y<=-1030 then
    regionName = "Damot"
  elseif x>=-900 and x<=2795 and y>=-3615 and y<=-3135 then
    regionName = "Elephantine"
  elseif x>=1065 and x<=3280 and y>=-7088 and y<=-5620 then
    regionName = "White Nile"
  elseif x>=3152 and x<=5120 and y>=-8192 and y<=-5500 then
    regionName = "Axum"
  elseif x>=2795 and x<=5120 and y>=-5620 and y<=-2675 then
    regionName = "Blemmyes"
  elseif x>=-900 and x<=1500 and y>=-5020 and y<=-3615 then
    regionName = "West Kush"
  elseif x>=1065 and x<=2795 and y>=-5620 and y<=-3615 then
    regionName = "East Kush"
  elseif x == 9999 and y == 9999 then
    regionName = "Invalid Coordinates"
  else
    regionName = "Hinterlands"
  end
  return regionName;
end
