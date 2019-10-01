dofile("common.inc");

function doit()

askForWindow("Find Coordinates on the Clock");

  while 1 do
    checkBreak();
    srReadScreen();
    local startPos = findCoords();
    local message = "Faction Detected: " .. faction .. "\n\n";
  if startPos then
    message = message .. "Coordinates Found:\n\n" .. startPos[0] .. ", " .. startPos[1];
  else
    message = message .. "Coordinates NOT Found";
  end
    message = message .. "\n\n\nNote: You can run around and see coordinates update ...";
    statusScreen(message, nil, 0.7, 0.7);
    lsSleep(10);
  end
end