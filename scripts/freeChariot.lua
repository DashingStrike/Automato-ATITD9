dofile("common.inc");

askForWindow("Click on Chariot, then click on Destination: <Location> you want to travel to. Pin that window.")

function doit()

  startTime = lsGetTimer()
  while 1 do
	srReadScreen();
	window = findText("Travel will be free")
	dest = findText("Travel to")
	if dest then
	  chariot = string.match(dest[2], "Travel to (%a+)")
	end
	travelFree = findText("Travel now for free")

	if window then
	  message = "Waiting for travel to be free ..."
	  safeClick(window[0]+10, window[1]+2)
	else
	  message = "Could not find Chariot window"
	end

	if travelFree then
	  safeClick(travel[0]+10, travel[1]+2)
	  break;
	end

	sleepWithStatus(150, "Traveling to " .. chariot .. "\n\n" .. message .. "\n\nElapsed Time: " .. getElapsedTime(startTime), nil, 0.7, "Monitoring / Refreshing Chariot")

  end
lsPlaySound("complete.wav")
end 
