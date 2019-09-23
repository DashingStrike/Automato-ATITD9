-- Wood gathering v1.0 by Manon & Cegaiel for T9 Beta
--

dofile("common.inc");

function doit()
    askForWindow("Wood gathering v1.0 by Cegaiel & Manon.\n\nPin 5-10 tree windows, will click them VERTICALLY (left to right if there is a tie - multiple columns are fine). \n\nOptionally, pin a Bonfire window for stashing wood. \n\nIf the trees are part of an oasis, you only need to pin 1 of the trees.");
    while 1 do
        checkBreak();
        refreshWindows();
        findWood();
        refreshWindows();
        bonfire();
        refreshWindows();
        sleepWithStatus(5000, "Searching\n\nPinned Trees found: " .. #nowood .. "\nBonfire found: ".. (#Bonfire > 0 and 'Yes' or 'No') );
    end
end

function refreshWindows()
    srReadScreen();
    this = findAllText("This");
    Bonfire = findAllText("Bonfire");
    for i=1,#this do
        clickText(this[i]);
    end
    lsSleep(500);
end

function findWood()
    srReadScreen();
    clickWood = findAllText("Gather Wood");
    nowood = findAllText("no Wood")
    for i=1,#clickWood do
        clickText(clickWood[i]);
    end
end

function bonfire()
    srReadScreen();
    BonfireAdd = findAllText("Add some Wood");
    for i=1,#BonfireAdd do
        safeClick(BonfireAdd[i][0]+10, BonfireAdd[i][1]+10);
        lsSleep(500);
        srReadScreen();
        max = srFindImage("max.png");
        if max then
            safeClick(max[0]+5,max[1]+5,1);
        else
            sleepWithStatus(500, "Could not add wood to the bonfire");
        end
    end
end

