-- Console will output last character in each line (when training). 
-- Also check https://www.atitd.org/wiki/tale6/User:Skyfeather/VT_OCR for more info on OCR

dofile("common.inc");
dofile("settings.inc");

offsetX = 102;
offsetY = 72;

function doit()
  askForWindow("Train OCR\n\nType a single letter/number in main chat.\n\nUse offsetX/Y to get the white box to surround this letter/number. Tip: You can also resize Main Chat to move into the white box. Top&Left of white box should border the letter/number. \n\nThen check Train button to show the code (in Console).\n\nThis macro is looking for your main chat window and the last letter/number you typed...\n\nOnce you find the values in Console, copy that to automato/games/ATITD9//data/charTemplate.txt file.");
  while true do
    findStuff();
  end
end


function findStuff()
  checkBreak();

  local y = 0;
  local scale = 0.9;

  srReadScreen();
  --local regions = findAllTextRegions();

  local regions = findChatRegionReplacement();
  local chatBox = makeBox(regions[0],regions[1], lsScreenX, lsScreenY);

  --sleepWithStatus(5000, regions[0] .. ", " .. regions[1] .. ", " .. regions[2] .. ", " .. regions[3]);
  --srStripRegion(chatbox);

  lsPrint(10, lsScreenY - 160, z, scale, scale, 0xFFFFFFff, "offsetX:");

  offsetX = readSetting("offsetX",offsetX);
  foo, offsetX = lsEditBox("offsetX", 80, lsScreenY - 160, 0, 50, 30, 1.0, 1.0, 0x000000ff, offsetX);
  offsetX = tonumber(offsetX);
  if not offsetX then
    lsPrint(140, lsScreenY - 160+3, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
    offsetX = 0;
  end
  writeSetting("offsetX",offsetX);

  lsPrint(10, lsScreenY - 130, z, scale, scale, 0xFFFFFFff, "offsetY:");

  offsetY = readSetting("offsetY",offsetY);
  foo, offsetY = lsEditBox("offsetY", 80, lsScreenY - 130, 0, 50, 30, 1.0, 1.0, 0x000000ff, offsetY);

  offsetY = tonumber(offsetY);
  if not offsetY then
    lsPrint(140, lsScreenY - 130+3, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
    offsetY = 0;
  end
  writeSetting("offsetY",offsetY);

    zoom = CheckBox(10, lsScreenY - 100, z, 0xffffffff, " Zoom 2.5x", zoom);
    if zoom then
      zoomLevel = 2.5;
    else
      zoomLevel = 1.0;
    end


    lsPrint(10, lsScreenY - 80, 10, 0.7, 0.7, 0xFFFFFFff, "Train Results displays in Console!");
    lsPrint(10, lsScreenY - 60, 10, 0.7, 0.7, 0xFFFFFFff, "Replace ? with the character you are training");


  if lsButtonText(0, lsScreenY - 30, z, 100,
                  0xFFFFFFff, "Train") then

    srStripScreen(chatbox)
    --Console will output ??? as last character in each line (when training). Replace ??? with the correct number of letter (case sensitive)
    srTrainTextReader(regions[0]+offsetX,regions[1]+offsetY, '?')
  else
    srStripRegion(regions[0]+offsetX,regions[1]+offsetY,   8, 12)
  end

  srMakeImage("current-region", regions[0], regions[1], lsScreenX, lsScreenY);
  srShowImageDebug("current-region", 5, 5, 1, zoomLevel);
  --srSetMousePos(regions[0]+offsetX,regions[1]+offsetY);



  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
                  0xFFFFFFff, "End Script") then
    error(quitMessage);
  end

  lsDoFrame();
  lsSleep(50);
end
