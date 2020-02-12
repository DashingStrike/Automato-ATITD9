dofile("common.inc");

essences = {
	{"ResinAcacia",11},
	{"ResinAcaciaSapling",9},
	{"ResinAcaciaYouth",23},
	{"ResinAnaxi",16},
	{"ResinArconis",85},
	{"ResinAshPalm",41},
	{"ResinAutumnBloodbark",73},
	{"ResinAutumnBloodbarkSapling",46},
	{"ResinAutumnBloodbarkYouth",7},
	{"ResinBeetlenut",55},
	{"ResinBlazeMaple",82},
	{"ResinBlazeMapleSapling",45},
	{"ResinBlazeMapleYouth",84},
	{"ResinBloodbark",13},
	{"ResinBottleTree",89},
	{"ResinBrambleHedge",6},
	{"ResinBroadleafPalm",78},
	{"ResinButterleafTree",10},
	{"ResinCeruleanBlue",56},
	{"ResinChakkanutTree",11},
	{"ResinChicory",56},
	{"ResinCinnar",67},
	{"ResinCoconutPalm",26},
	{"ResinCricklewood",48},
	{"ResinDeadwoodTree",35},
	{"ResinDeltaPalm",3},
	{"ResinDikbas",37},
	{"ResinDikbasSapling",33},
	{"ResinDikbasYouth",60},
	{"ResinDwarfSafsaf",11},
	{"ResinElephantia",75},
	{"Resinleather",66},
	{"ResinleatherTreeSapling",28},
	{"ResinleatherTreeYouth",64},
	{"ResinlernPalm",27},
	{"ResinloldedBirch",20},
	{"ResinGiantCricklewood",12},
	{"ResinGoldenHemlock",35},
	{"ResinGoldenHemlockSapling",67},
	{"ResinGreenAsh",43},
	{"ResinGreenAshSapling",8},
	{"ResinGreenAshYouth",65},
	{"ResinHawthorn",67},
	{"ResinHokkaido",8},
	{"ResinIllawara",37},
	{"ResinIllawaraSapling",10},
	{"ResinIllawaraYouth",7},
	{"ResinJacaranda",75},
	{"ResinJacarandaSapling",49},
	{"ResinJacarandaYouth",17},
	{"ResinJapaneseCherry",45},
	{"ResinJapaneseCherrySapling",67},
	{"ResinJapaneseCherryYouth",2},
	{"ResinKaeshra",71},
	{"ResinKatsuraSapling",24},
	{"ResinKatsuraTree",84},
	{"ResinKatsuraYouth",10},
	{"ResinKhaya",42},
	{"ResinKhayaSapling",80},
	{"ResinKhayaYouth",71},	
	{"ResinLocustPalm",80},
	{"ResinMimosa",10},
	{"ResinMimosaSapling",16},
	{"ResinMimosaYouth",20},
	{"ResinMiniPalmetto",84},
	{"ResinMiniaturelernPalm",50},
	{"ResinMonkeyPalm",47},
	{"ResinMontereyPine",50},
	{"ResinMontereyPineMiddleAge",42},
	{"ResinMontereyPineSapling",57},
	{"ResinMontuMaple",61},
	{"ResinOilPalm",20},
	{"ResinOleaceae",39},
	{"ResinOranje",68},
	{"ResinOrrorin",70},
	{"ResinParrotia",78},
	{"ResinParrotiaSapling",48},
	{"ResinParrotiaYouth",72},
	{"ResinPassam",51},
	{"ResinPeachesnCreamMaple",74},
	{"ResinPeachesnCreamSapling",10},
	{"ResinPeachesnCreamYouth",57},
	{"ResinPhoenixPalm",62},
	{"ResinPratyekaTree",64},
	{"ResinRanyahn",16},
	{"ResinRazorPalm",28},
	{"ResinRedMaple",29},
	{"ResinRiverBirch",54},
	{"ResinRiverBirchSapling",69},
	{"ResinRiverBirchYouth",34},
	{"ResinRoyalPalm",23},
	{"ResinSafsafSapling",6},
	{"ResinSafsafWillow",41},
	{"ResinSavaka",3},
	{"ResinScaleyHardwood",30},
	{"ResinSilkyOak",60},
	{"ResinSpikedlishtree",82},
	{"ResinSpindleTree",39},
	{"ResinStoutPalm",16},
	{"ResinStoutPalm",16},
	{"ResinSummerMaple",90},
	{"ResinSummerMapleSapling",59},
	{"ResinSummerMapleYouth",43},
	{"ResinSweetPine",90},
	{"ResinTapacaeMiralis",77},
	{"ResinTinyOilPalm",22},
	{"ResinToweringPalm",88},
	{"ResinTrilobellia",70},
	{"ResinUmbrellaPalm",59},
	{"ResinWhitePine",37},
	{"ResinWhitePineSapling",38},
	{"ResinWhitePineYouth",46},
	{"ResinWindriverPalm",35},
	{"ResinYoungGoldenHemlock",15},
	{"PowderedDiamond",25},
	{"PowderedEmerald",31},
	{"PowderedOpal",17},
	{"PowderedQuartz",},
	{"PowderedRuby",},
	{"PowderedSapphire",},
	{"PowderedTopaz",},
	{"PowderedAmethyst",},
	{"PowderedCitrine",},
	{"PowderedGarnet",},
	{"PowderedJade",},
	{"PowderedLapis",},
	{"PowderedSunstone",},
	{"PowderedTurquoise",},
	{"PowderedAquaPearl",},
	{"PowderedBeigePearl",},
	{"PowderedBlackPearl",},
	{"PowderedCoralPearl",},
	{"PowderedPinkPearl",},
	{"PowderedSmokePearl",},
	{"PowderedWhitePearl",},
	{"SaltsOfAluminum",},
	{"SaltsOfAntimony",},
	{"SaltsOfCopper",},
	{"SaltsOfGold",},
	{"SaltsOfIron",},
	{"SaltsOfLead",},
	{"SaltsOfLithium",},
	{"SaltsOfMagnesium",},
	{"SaltsOfPlatinum",},
	{"SaltsOfSilver",},
	{"SaltsOfStrontium",},
	{"SaltsOfTin",},
	{"SaltsOfTitanium",},
	{"SaltsOfTungsten",},
	{"SaltsOfZinc",},
	{"OysterShellMarbleDust",},
	{"Allbright",},
	{"Aloe",},
	{"AltarsBlessing",},
	{"Anansi",},
	{"Apiphenalm",},
	{"ApothecarysScythe",},
	{"Artemesia",},
	{"Asafoetida",},
	{"Asane",},
	{"Ashoka",},
	{"AzureTristeria",},
	{"Banto",},
	{"BayTree",},
	{"BeeBalm",},
	{"BeetleLeaf",},
	{"BeggarsButton",},
	{"Bhillawa",},
	{"Bilimbi",},
	{"BitterFlorian",},
	{"BlackPepperPlant",},
	{"BlessedMariae",},
	{"Bleubaille",},
	{"BloodBalm",},
	{"BloodBlossom",},
	{"BloodRoot",},
	{"BloodedHarebell",},
	{"Bloodwort",},
	{"BlueDamia",},
	{"BlueTarafern",},
	{"BlueberryTeaTree",},
	{"BluebottleClover",},
	{"BlushingBlossom",},
	{"BrassyCaltrops",},
	{"BrownMuskerro",},
	{"Bucklerleaf",},
	{"BullsBlood",},
	{"BurntTarragon",},
	{"ButterflyDamia",},
	{"Butterroot",},
	{"Calabash",},
	{"Camelmint",},
	{"Caraway",},
	{"Cardamom",},
	{"Cassia",},
	{"Chaffa",},
	{"Chatinabrae",},
	{"Chives",},
	{"Chukkah",},
	{"CicadaBean",},
	{"Cinnamon",},
	{"Cinquefoil",},
	{"Cirallis",},
	{"Clingroot",},
	{"CommonBasil",},
	{"CommonRosemary",},
	{"CommonSage",},
	{"Corsacia",},
	{"Covage",},
	{"Crampbark",},
	{"Cranesbill",},
	{"CreepingBlackNightshade",},
	{"CreepingThyme",},
	{"CrimsonClover",},
	{"CrimsonLettuce",},
	{"CrimsonNightshade",},
	{"CrimsonPipeweed",},
	{"CrimsonWindleaf",},
	{"CrumpledLeafBasil",},
	{"CurlySage",},
	{"CyanCressidia",},
	{"Daggerleaf",},
	{"Dalchini",},
	{"Dameshood",},
	{"DankMullien",},
	{"DarkOchoa",},
	{"DarkRadish",},
	{"DeathsPiping",},
	{"DeadlyCatsclaw",},
	{"Dewplant",},
	{"Digweed",},
	{"Discorea",},
	{"DrapeauDor",},
	{"DustyBlueSage",},
	{"DwarfHogweed",},
	{"DwarfWildLettuce",},
	{"EarthApple",},
	{"Elegia",},
	{"EnchantersPlant",},
	{"Finlow",},
	{"FireAllspice",},
	{"FireLily",},
	{"Fivesleaf",},
	{"FlamingSkirret",},
	{"FlandersBlossom",},
	{"Fleabane",},
	{"FoolsAgar",},
	{"Fumitory",},
	{"Garcinia",},
	{"GarlicChives",},
	{"GingerRoot",},
	{"GingerTarragon",},
	{"GinsengRoot",},
	{"Glechoma",},
	{"Gnemnon",},
	{"Gokhru",},
	{"GoldenDoubloon",},
	{"GoldenGladalia",},
	{"GoldenSellia",},
	{"GoldenSweetgrass",},
	{"GoldenSun",},
	{"GoldenThyme",},
	{"Gynura",},
	{"Harebell",},
	{"Harrow",},
	{"Hazlewort",},
	{"HeadacheTree",},
	{"Heartsease",},
	{"Hogweed",},
	{"HomesteaderPalm",},
	{"HoneyMint",},
	{"Houseleek",},
	{"Hyssop",},
	{"IceBlossom",},
	{"IceMint",},
	{"Ilex",},
	{"IndigoDamia",},
	{"Ipomoea",},
	{"JaggedDewcup",},
	{"Jaivanti",},
	{"Jaiyanti",},
	{"JoyoftheMountain",},
	{"Jugwort",},
	{"KatakoRoot",},
	{"Khokali",},
	{"KingsCoin",},
	{"Lamae",},
	{"Larkspur",},
	{"LavenderNavarre",},
	{"LavenderScentedThyme",},
	{"LemonBasil",},
	{"LemonGrass",},
	{"Lemondrop",},
	{"Lilia",},
	{"Liquorice",},
	{"Lungclot",},
	{"Lythrum",},
	{"Mahonia",},
	{"Maliceweed",},
	{"MandrakeRoot",},
	{"Maragosa",},
	{"Mariae",},
	{"Meadowsweet",},
	{"Medicago",},
	{"Mindanao",},
	{"MiniatureBamboo",},
	{"MiniatureLamae",},
	{"MirabellisFern",},
	{"MoonAloe",},
	{"Morpha",},
	{"Motherwort",},
	{"MountainMint",},
	{"Myristica",},
	{"Myrrh",},
	{"Naranga",},
	{"NubianLiquorice",},
	{"OctecsGrace",},
	{"OpalHarebell",},
	{"OrangeNiali",},
	{"OrangeSweetgrass",},
	{"Orris",},
	{"PaleDhamasa",},
	{"PaleOchoa",},
	{"PaleRusset",},
	{"PaleSkirret",},
	{"Panoe",},
	{"ParadiseLily",},
	{"Patchouli",},
	{"Peppermint",},
	{"Pippali",},
	{"PitcherPlant",},
	{"Primula",},
	{"Prisniparni",},
	{"PulmonariaOpal",},
	{"PurpleTintiri",},
	{"Quamash",},
	{"RedPepperPlant",},
	{"Revivia",},
	{"Rhubarb",},
	{"RoyalRosemary",},
	{"Rubia",},
	{"Rubydora",},
	{"SacredPalm",},
	{"SagarGhota",},
	{"Sandalwood",},
	{"SandyDustweed",},
	{"Satsatchi",},
	{"Schisandra",},
	{"ShrubSage",},
	{"ShrubbyBasil",},
	{"Shyama",},
	{"Shyamalata",},
	{"SicklyRoot",},
	{"SilvertongueDamia",},
	{"Skirret",},
	{"SkyGladalia",},
	{"Soapwort",},
	{"Sorrel",},
	{"Spinach",},
	{"Spinnea",},
	{"Squill",},
	{"SteelBladegrass",},
	{"SticklerHedge",},
	{"StrawberryTea",},
	{"Strychnos",},
	{"SugarCane",},
	{"SweetGroundmaple",},
	{"Sweetflower",},
	{"Sweetgrass",},
	{"Sweetsop",},
	{"Tagetese",},
	{"Tamarask",},
	{"TangerineDream",},
	{"ThunderPlant",},
	{"Thyme",},
	{"TinyClover",},
	{"Trilobe",},
	{"Tristeria",},
	{"TrueTarragon",},
	{"Tsangto",},
	{"Tsatso",},
	{"TurtlesShell",},
	{"UmberBasil",},
	{"UprightOchoa",},
	{"VanillaTeaTree",},
	{"VerdantSquill",},
	{"VerdantTwo-Lobe",},
	{"Wasabi",},
	{"WeepingPatala",},
	{"WhitePepperPlant",},
	{"Whitebelly",},
	{"WildGarlic",},
	{"WildLettuce",},
	{"WildOnion",},
	{"WildYam",},
	{"WoodSage",},
	{"Xanat",},
	{"Xanosi",},
	{"Yava",},
	{"YellowGentian",},
	{"YellowTristeria",},
	{"Yigory",},
	{"Zanthoxylum",},
	{"CamelPheromoneFemale",},
	{"CamelPheromoneMale",}
};

tick_time = 100;
per_click_delay = 50;
per_read_delay = 150;

alcType = {};
alcType[3] = {"Wood Spirits", 1};
alcType[2] = {"Worm Spirits", 2};
alcType[1] = {"Grain Spirits", 3};
alcType[4] = {"Vegetable Spirits", 6};
alcType[5] = {"Mineral Spirits", 7};

function stripCharacters(s)
	local badChars = "%:%(%)%-%,%'%d%s";
	s = string.gsub(s, "[" .. badChars .. "]", "");
	return s;
end

function getSpirits(goal)
	local t = {};
	if goal < 10 then
		t[1] = {};
		t[1][1] = "Rock Spirits";
		t[1][2] = 10-goal;
		if goal ~= 0 then
			t[2] = {};
			t[2][1] = "Wood Spirits";
			t[2][2] = goal;
		end
		return t;
	end
	if goal == 81 or goal == 82 or goal == 83 then
		t[1] = {};
		t[1][1] = "Fish Spirits";
		t[1][2] = 10;
		return t;
	end
	if goal == 84 then
		t[1] = {};
		t[1][1] = "Grey Spirits";
		t[1][2] = 9;
		t[2] = {};
		t[2][1] = "Grain Spirits";
		t[2][2] = 1;
		return t;
	end
	if goal == 85 then
		if goal ~= 0 then
			t[1] = {};
			t[1][1] = "Mineral Spirits";
			t[1][2] = 1;
			t[2] = {};
			t[2][1] = "Vegetable Spirits";
			t[2][2] = 1;
			t[3] = {};
			t[3][1] = "Grey Spirits";
			t[3][2] = 8;
		end
		return t;
	end
	if goal > 80 then
		alcType[7] = {"Grey Spirits", 9};
		alcType[6] = {"Fish Spirits", 8};
	else
		alcType[7] = nil;
		alcType[6] = nil;
	end
	if goal > 70 and goal <= 80 then
		t[1] = {};
		t[1][1] = "Fish Spirits";
		t[1][2] = goal - 70;
		if goal ~= 80 then
			t[2] = {};
			t[2][1] = "Mineral Spirits";
			t[2][2] = 80-goal;
		end
		return t;
	end
	for k = 1, #alcType do
		for l = 1, #alcType do
			for i = 10, 5, -1 do
				j = 10 - i;
				temp = alcType[k][2] * i + alcType[l][2] * j;
				if temp == goal then
					t[1] = {};
					t[1][1] = alcType[k][1];
					t[1][2] = i;
					if j ~= 0 then
						t[2] = {};
						t[2][1] = alcType[l][1];
						t[2][2] = j;
					end
					return t;
				end
			end
		end
	end
	--otherwise, we didn't find it
	
	for k = 1, #alcType do
		for l = 1, #alcType do
			for m = 1, #alcType do
				for i = 8, 5, -1 do
					j = 10 - i - 1;
					temp = alcType[k][2] * i + alcType[l][2] * j + alcType[m][2];
					if temp == goal then
						t[1] = {};
						t[2] = {};
						t[3] = {};
						t[1][1] = alcType[k][1];
						t[1][2] = i;
						t[2][1] = alcType[l][1];
						t[2][2] = j;
						t[3][1] = alcType[m][1];
						t[3][2] = 1;
						return t;
					end
				end
			end
		end
	end
end

function displayStatus()
	lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	
	for window_index=1, #labWindows do
			lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. labState[window_index].status);
	end
	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
		stop_cooking = 1;
	end
	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end
	
	checkBreak();
	lsDoFrame();
end

numFinished = 0;

function labTick(essWin, state)
	message = "";
	statusScreen("Starting ...", nil, 0.7, 0.7);
	state.count = state.count + 1;
	state.status = "Chem Lab: " .. state.count;
	state.active = false;
	local i;
	state.essenceIndex = nil;
	
	if state.finished then
		return;
	end
	
	--and here is where we add in the essence
	local outer;
	while outer == nil do
		safeClick(essWin.x + 10, essWin.y + essWin.height / 2);
		srReadScreen();
		statusScreen("Waiting to Click: Manufacture ...", nil, 0.7, 0.7);
		outer = findText("Manufacture...", essWin);
		lsSleep(per_read_delay);
		checkBreak();
	end
	clickText(outer);
--	lsSleep(per_click_delay);

	statusScreen("Waiting to Click: Essential Distill ...", nil, 0.7, 0.7);
	local t = waitForText("Essential Distill");
	clickText(t);
--	lsSleep(per_click_delay);
	statusScreen("Waiting to Click: Place Essential Mat ...", nil, 0.7, 0.7);
	t = waitForText("Place Essential Mat");
	clickText(t);
--	lsSleep(per_click_delay);

	statusScreen("Searching for Macerator ...", nil, 0.7, 0.7);
	--search for something to add
	local rw = waitForText("Choose a material", nil, nil, nil, REGION);
	rw.x = rw.x+7;
	rw.y = rw.y+29;
	rw.width = 204;
	rw.height = 240;
	local parse = findAllText(nil, rw);
	local foundEss = false;
	if parse then
		for i = 1, #parse do
			parse[i][2] = stripCharacters(parse[i][2]);
			if foundEss == false then
				for k = 1, #essences do
					if essences[k][2] ~= -1 and parse[i][2] == essences[k][1] and foundEss == false then
						state.essenceIndex = k;
						foundEss = true;
						clickText(parse[i]);
						message = "Added Macerator: " .. essences[k][1] .. "\n";
						state.temp = essences[k][2];
						if state.temp == nil then
						  error("That material has not yet been mapped.");
						end
					end
				end
			end
		end
	end
	
	if foundEss == false then
		sleepWithStatus(2000, "foundEss is false")
		state.status = "Couldn't find essence";
		numFinished = numFinished + 1;
		state.finished = 1;
		clickAllImages("cancel.png")
		lsSleep(100);
		return;
	end
	
	clickAllImages("OK.png")
	lsSleep(250);
	
	lsSleep(per_read_delay);
	lsSleep(1000);
	
	local spiritsNeeded = getSpirits(state.temp);
	
	state.lastOffset = 10;
	
	for i = 1, #spiritsNeeded do
		--Add the alcohol
		clickText(waitForText("Manufacture...", nil, nil, essWin));
		lsSleep(per_click_delay);
		clickText(waitForText("Alcohol Lamp."));
		lsSleep(per_click_delay);
		clickText(waitForText("Fill Alcohol Lamp"), nil, 20, 1);
		lsSleep(per_click_delay);

		--click on the spirit itself
		message = message .. "\nAdding Spirits : " .. spiritsNeeded[i][2] .. " " .. spiritsNeeded[i][1];
		statusScreen(message, nil, 0.7, 0.7);
		clickText(waitForText(spiritsNeeded[i][1]));
		lsSleep(per_click_delay);
		waitForText("How much");
		srKeyEvent(spiritsNeeded[i][2] .. "\n");
		lsSleep(per_click_delay + per_read_delay)
		message = message .. " -- OK!"
	end
	
	clickText(waitForText("Manufacture...", nil, nil, essWin));
	lsSleep(per_click_delay + per_read_delay);
	t = waitForText("Essential Distill");
	clickText(t);
	lsSleep(per_click_delay);
	
	local image;
	
	while 1 do
		srReadScreen();
		image = srFindImage("StartDistillMini.png");
		if image then
			safeClick(image[0] + 2, image[1] + 2);
			lsSleep(per_click_delay);
			break;
		else
			statusScreen("Could not find start Essential, updating menu");
			--otherwise, search for place, and and update the menu
			clickText(t);
			lsSleep(200);
		end
	end
		safeClick(essWin.x + 10, essWin.y + essWin.height / 2);
	lsSleep(per_click_delay);
	return;
end

curActive = 1;

function doit()

	last_time = lsGetTimer() + 5000;
	
	askForWindow("Pin all Chemistry Laboratories");
	
	srReadScreen();
	labWindows = findAllText("This is [a-z]+ Chemistry Laboratory", nil, REGION+REGEX);
	
	if labWindows == nil then
		error 'Did not find any open windows';
	end
	
	labState = {};
	local last_ret = {};
	for window_index=1, #labWindows do
		labState[window_index] = {};
		labState[window_index].count = 0;
		labState[window_index].active = false;
		labState[window_index].status = "Initial";
		labState[window_index].needTest = 1;
	end
	
	labState[1].active = true;
	
	while 1 do
		-- Tick
		srReadScreen();

		--labWindows2 = findAllText("This is [a-z]+ Chemistry Laboratory", nil, REGION+REGEX);
		--On around October 22, 2018 - Chem Lab window behavior has changed breaking the macro
		--Once the Chem Lab starts up, the window shrinks down to almost nothing and most options disappear (including This is a Chem Lab)
		-- See https://i.gyazo.com/4ec9eaf1d3bd7dc65e9dc919ef921215.png for example
		-- Now we're forced to search for Utility on menu instead.
		labWindows2 = findAllText("Utility", nil, REGION+REGEX);



		
		local should_continue = nil;
		
		if #labWindows2 == #labWindows then
			for window_index=1, #labWindows do
				local wasActive = labState[window_index].active;


				if wasActive == true then
					local r = labTick(labWindows[window_index], labState[window_index]);
					--check to see if it's still active
					if window_index == #labWindows then
						labState[1].active = true;
					else
						labState[window_index + 1].active = true;
					end
					break;
				end
				if r then
					should_continue = 1;
				end
			end
		else
		--refresh windows. Chem Lab window does not refresh itself after it's done making essence. Refresh to force window to update, so we know when it's done.
		refreshWindows();
		end
		
		--check to see if we're finished.
		if numFinished == #labWindows then
			error "Completed.";
		end

		-- Display status and sleep

		local start_time = lsGetTimer();
		while tick_time - (lsGetTimer() - start_time) > 0 do
			time_left = tick_time - (lsGetTimer() - start_time);
			
			displayStatus(labState);
			lsSleep(25);
		end
		
		checkBreak();
		-- error 'done';
	end
end

function refreshWindows()
  srReadScreen();
  pinWindows = findAllImages("UnPin.png");
	for i=1, #pinWindows do
	  checkBreak();
	  safeClick(pinWindows[i][0] - 7, pinWindows[i][1]);
	  lsSleep(100);
  	end
  lsSleep(500);
end
