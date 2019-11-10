dofile("common.inc");

local askText = "Censorship-free autoposting macro.\n\nAutomatically passes through messages.";

function doit()
   askForWindow(askText);
   while 1 do
      srReadScreen();
      local passicon = srFindImage("cb-pass.png");
      if passicon then
         safeClick(passicon[0] + 1, passicon[1] + 1);
      end
      sleepWithStatus(500, "Waiting for new message");
   end
end
