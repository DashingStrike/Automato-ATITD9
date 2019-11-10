dofile("common.inc");

function doit()
	askForWindow("Test reading main chat. Hover ATITD window and Press Shift to continue.");


  while 1 do
    checkBreak();
    chatRead();
    sleepWithStatus(100,"Last Line:\n" .. lastLine .. "\n\n2nd from Last Line:\n" .. lastLine2, nil, 0.7, "Reading Main Chat");
  end
end

function checkIfMain(chatText)
    for j = 1, #chatText do
        if string.find(chatText[j][2], "^%*%*", 0) then
            return true;
        end
    end
    return false;
end

function chatRead()
    srReadScreen();
    local chatText = getChatText();
    local onMain = checkIfMain(chatText);

    if not onMain then
        if not muteSoundEffects then
            lsPlaySound("timer.wav");
        end
    end

    -- Wait for Main chat screen and alert user if its not showing
    while not onMain do
        checkBreak();
        srReadScreen();
        chatText = getChatText();
        onMain = checkIfMain(chatText);
        sleepWithStatus(100, "Looking for Main chat screen ...\n\nIf Main Chat is showing, then type /afk once or twice so it shows two ** Asterisks in chat window. It parses those double asterisks!", nil, 0.7, "Error Parsing Main Chat");
    end

   -- Verify chat window is showing minimum 2 lines
   while #chatText < 2 do

   	checkBreak();
      srReadScreen();
      chatText = getChatText();
      sleepWithStatus(500, "Error: We must be able to read at least the last 2 lines of main chat!\n\nCurrently we only see " .. #chatText .. " lines ...\n\nYou can overcome this error by typing ANYTHING in main chat.", nil, 0.7, "Error Parsing Main Chat");
   end

   --Read last line of chat and strip the timer ie [01m]+space from it.
   lastLine = chatText[#chatText][2];
   lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));
   --Read next to last line of chat and strip the timer ie [01m]+space from it.
   lastLine2 = chatText[#chatText-1][2];
   lastLineParse2 = string.sub(lastLine2,string.find(lastLine2,"m]")+3,string.len(lastLine2));
end
