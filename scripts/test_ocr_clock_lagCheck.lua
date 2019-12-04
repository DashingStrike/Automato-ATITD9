dofile("common.inc");
	
function doit()

askForWindow("Parses the game clock and extracts the info.\nInfo updates in realtime while running!\nPress Shift over ATITD to continue.");

elapsedTime = 0;
startTime = 0;
lastTime = 0;
Time = 0;
minsElapsed = -1;
elapsedTimeSeconds = 0;
elapsedTimeTotal = 0;
elapsedTimeAvg = 0;
duckTime = 0;
duckTimeSeconds = 0;
duckTimeAvg = 0;
minsElapsedGUI = "Awaiting Change";
message = "";
message2 = "";
scriptStartTime = lsGetTimer();

	findClockInfo();
	while 1 do
        local pos = getMousePos();
        lastTime = Time;
        findClockInfo();

        if minsElapsed == -1 then
          scriptStartTime = lsGetTimer()
        end

        if lastTime ~= Time then
          minsElapsed = minsElapsed + 1;
	     if minsElapsed == 0 then
	       minsElapsedGUI = "Starting Timer";
	       scriptStartTime = lsGetTimer()
	     else
	       minsElapsedGUI = minsElapsed;
	     end

	     if minsElapsed == 0 then
	       startTime = lsGetTimer();
	     elseif minsElapsed >= 1 then
	       elapsedTime = lsGetTimer() - startTime
	       elapsedTimeSeconds = math.floor(elapsedTime/100)/10;
	       elapsedTimeTotal = elapsedTimeTotal + elapsedTime;
	       elapsedTimeAvg = elapsedTimeTotal / minsElapsed;
	       duckTime = elapsedTime * 3;
	       duckTimeSeconds = math.floor(duckTime/100)/10;
	       duckTimeAvg = (elapsedTimeTotal * 3) / minsElapsed;
	       elapsedTimeAvg = math.floor(elapsedTimeAvg/100)/10;
	       duckTimeAvg = math.floor(duckTimeAvg/100)/10;
	       startTime = lsGetTimer();
	     end
        end


	while not coordinates or not fetchTime do
	  findClockInfo()
	  sleepWithStatus(999, "We have a problem finding Clock!", nil, 0.7, "Error Reading Clock")
	end

        sleepWithStatus(100, "Mouse Pos: " .. pos[0] .. ", " .. pos[1] .. "\n\nYear: " .. year .. "\nDate: " .. Date .. "\nTime: " .. Time .. "\nRegion: " .. regionName .. "\nCoords: " 
	  .. Coordinates .. "\nFaction: " .. faction .. "\n\nElapsed Egypt Mins: " .. minsElapsedGUI .. "\nElapsed Real Time: " .. getElapsedTime(scriptStartTime) .. "\nLast Secs per Egypt Minute: " .. elapsedTimeSeconds .. "\nAvg Secs per Egypt Minute: " .. elapsedTimeAvg .. "\nLast Secs per Game Minute: " 
	  .. duckTimeSeconds .. "\nAvg Secs per Game Minute: " .. duckTimeAvg .. "\nAvg Teppy/Duck Multiplier: " .. round(duckTimeAvg/60,4), nil, 0.67, "Reading Clock");

	end
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function findClockInfo()
  srReadScreen();
  coordinates = findCoords()
  if coordinates then
    coordX = coordinates[0];
    coordY = coordinates[1];
    Coordinates = coordX .. ", " .. coordY
    regionName = coord2region(coordX, coordY);
  end
  srReadScreen();
  fetchTime = getTime(1);
  if fetchTime ~= nil then
    year = string.match(fetchTime, "Year (%d+)")
    theDateTime = string.sub(fetchTime,string.find(fetchTime,",") + 0); -- I know it's weird to have +0, but don't remove it or will error, shrug
    stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
    Time = string.sub(stripYear,string.find(stripYear,",") + 2);
    stripYear = "," .. stripYear
    Date = string.sub(stripYear,string.find(stripYear,",") + 1, string.len(stripYear) - string.len(Time) - 2);
    stripYear = string.sub(theDateTime,string.find(theDateTime,",") + 2);
  end
end


--Custom sleepWithStatus to add extra boxes, buttons, etc
local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatus(delay_time, message, color, scale, waitMessage)
  if not waitMessage then
    waitMessage = "Waiting ";
  else
    waitMessage = waitMessage .. " ";
  end
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    newWaitMessage = waitMessage;
    if delay_time >= 1000 then
      newWaitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);

		if faction == "Hyksos" then
		  lsButtonImg(170, 110, 1, 0.20, 0xFFFFFFff, "faction/hyksos.png");
		elseif faction == "Kush" then
		  lsButtonImg(170, 110, 1, 0.17, 0xFFFFFFff, "faction/kush.png");
		elseif faction == "Meshwesh"  then
		  lsButtonImg(170, 110, 1, 0.20, 0xFFFFFFff, "faction/meshwesh.png");
		end

    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end
