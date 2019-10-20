dofile("common.inc");

initialText = "Censorship-free autoposting macro. Automatically passes through messages. Hover over ATITD, press shift.";

function doit()
   askForWindow(printText);
   while 1 do
      srReadScreen();
      local passicon = srFindImage("cb-pass.png");
      if passicon then
         safeClick(passicon[0] + 1, passicon[1] + 1);
         lsPrintln(string.format("Clicking %s, %s", passicon[0] + 1, passicon[1] + 1));
      end
      sleepWithStatus(500, "Waiting for new message");
   end
end
