-- Macro created by Unknown, updated for T8 by Manon on 10 March 2018.
-- WaypointColors are hexadecimal RGBA
-- Tree and color definitions updated for T9 by Spatulus 2019-10-25

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("common.inc");
dofile("serialize.inc");
dofile("settings.inc");
dofile("constants.inc");

routeFileName = "gatherRoutes.txt";
defaultRoutesFileName = "defaultRoutes.inc";
routes = {};
routeNames = {};

Waypoint = 1;
Bonfire = 2;
Warehouse = 3;
WindriverPalm = 4;
UmbrellaPalm = 5;
ToweringPalm = 6;
TinyOilPalm = 7;
TapacaeMiralis = 8;
StoutPalm = 9;
SpindleTree = 10;
SpikedFishTree = 11;
RoyalPalm = 12;
RedMaple = 13;
RazorPalm = 14;
Ranyahn = 15;
PhoenixPalm = 16;
Passam = 17;
Orrorin = 18;
Oleaceae = 19;
OilPalm = 20;
MonkeyPalm = 21;
MiniPalmetto = 22;
MiniatureFernPalm = 23;
LocustPalm = 24;
Kaeshra = 25;
Hokkaido = 26;
Hawthorn = 27;
GiantCricklewood = 28;
FoldedBirch = 29;
FernPalm = 30;
FeatherTree = 31;
Elephantia = 32;
DeltaPalm = 33;
Cricklewood = 34;
CoconutPalm = 35;
Cinnar = 36;
Chicory = 37;
ChakkanutTree = 38;
CeruleanBlue = 39;
ButterleafTree = 40;
BroadLeafPalm = 41;
BrambleHedge = 42;
BottleTree = 43;
Bloodbark = 44;
Beetlenut = 45;
AshPalm = 46;
Anaxi = 47;
Water = 48;
MenuClick = 49;
Arconis = 50;
PratyekaTree = 51;
Savaka = 52;
Trilobellia = 53;
BlazeMaple = 54;
Dikbas = 55;
Illawara = 56;
Jacaranda = 57;
Katsura = 58;
Khaya = 59;
Mimosa = 60;
MontereyPine = 61;
MontuMaple = 62;
Oranje = 63;
Parrotia = 64;
PnCMaple = 65;
SilkyOak = 66;
AutumnBloodbark = 67;
RiverBirch = 68;
GoldenHemlock = 69;
JapaneseCherry = 70;
GreenAsh = 71;
Acacia = 72;
SummerMaple = 73;
WhitePine = 74;
Safsaf = 75;
SweetPine = 76;
Papyrus = 77;

WaypointOrder = {};
WaypointOrder[#WaypointOrder+1] = Waypoint;
WaypointOrder[#WaypointOrder+1] = MenuClick;
WaypointOrder[#WaypointOrder+1] = Bonfire;
WaypointOrder[#WaypointOrder+1] = Warehouse;
WaypointOrder[#WaypointOrder+1] = Water;
WaypointOrder[#WaypointOrder+1] = Acacia;
WaypointOrder[#WaypointOrder+1] = Anaxi;
WaypointOrder[#WaypointOrder+1] = Arconis;
WaypointOrder[#WaypointOrder+1] = AshPalm;
WaypointOrder[#WaypointOrder+1] = AutumnBloodbark;
WaypointOrder[#WaypointOrder+1] = Beetlenut;
WaypointOrder[#WaypointOrder+1] = BlazeMaple;
WaypointOrder[#WaypointOrder+1] = Bloodbark;
WaypointOrder[#WaypointOrder+1] = BottleTree;
WaypointOrder[#WaypointOrder+1] = BrambleHedge;
WaypointOrder[#WaypointOrder+1] = BroadLeafPalm;
WaypointOrder[#WaypointOrder+1] = ButterleafTree;
WaypointOrder[#WaypointOrder+1] = CeruleanBlue;
WaypointOrder[#WaypointOrder+1] = ChakkanutTree;
WaypointOrder[#WaypointOrder+1] = Chicory;
WaypointOrder[#WaypointOrder+1] = Cinnar;
WaypointOrder[#WaypointOrder+1] = CoconutPalm;
WaypointOrder[#WaypointOrder+1] = Cricklewood;
WaypointOrder[#WaypointOrder+1] = DeltaPalm;
WaypointOrder[#WaypointOrder+1] = Dikbas;
WaypointOrder[#WaypointOrder+1] = Elephantia;
WaypointOrder[#WaypointOrder+1] = FeatherTree;
WaypointOrder[#WaypointOrder+1] = FernPalm;
WaypointOrder[#WaypointOrder+1] = FoldedBirch;
WaypointOrder[#WaypointOrder+1] = GiantCricklewood;
WaypointOrder[#WaypointOrder+1] = GoldenHemlock;
WaypointOrder[#WaypointOrder+1] = GreenAsh
WaypointOrder[#WaypointOrder+1] = Hawthorn;
WaypointOrder[#WaypointOrder+1] = Hokkaido;
WaypointOrder[#WaypointOrder+1] = Illawara;
WaypointOrder[#WaypointOrder+1] = Jacaranda;
WaypointOrder[#WaypointOrder+1] = JapaneseCherry;
WaypointOrder[#WaypointOrder+1] = Kaeshra;
WaypointOrder[#WaypointOrder+1] = Katsura;
WaypointOrder[#WaypointOrder+1] = Khaya;
WaypointOrder[#WaypointOrder+1] = LocustPalm;
WaypointOrder[#WaypointOrder+1] = Mimosa;
WaypointOrder[#WaypointOrder+1] = MiniatureFernPalm;
WaypointOrder[#WaypointOrder+1] = MiniPalmetto;
WaypointOrder[#WaypointOrder+1] = MonkeyPalm;
WaypointOrder[#WaypointOrder+1] = MontereyPine;
WaypointOrder[#WaypointOrder+1] = MontuMaple;
WaypointOrder[#WaypointOrder+1] = OilPalm;
WaypointOrder[#WaypointOrder+1] = Oleaceae;
WaypointOrder[#WaypointOrder+1] = Oranje;
WaypointOrder[#WaypointOrder+1] = Orrorin;
WaypointOrder[#WaypointOrder+1] = Parrotia;
WaypointOrder[#WaypointOrder+1] = Passam;
WaypointOrder[#WaypointOrder+1] = PhoenixPalm;
WaypointOrder[#WaypointOrder+1] = PnCMaple;
WaypointOrder[#WaypointOrder+1] = PratyekaTree;
WaypointOrder[#WaypointOrder+1] = Ranyahn;
WaypointOrder[#WaypointOrder+1] = RazorPalm;
WaypointOrder[#WaypointOrder+1] = RedMaple;
WaypointOrder[#WaypointOrder+1] = RiverBirch;
WaypointOrder[#WaypointOrder+1] = RoyalPalm;
WaypointOrder[#WaypointOrder+1] = Savaka;
WaypointOrder[#WaypointOrder+1] = SilkyOak;
WaypointOrder[#WaypointOrder+1] = SpikedFishTree;
WaypointOrder[#WaypointOrder+1] = SpindleTree;
WaypointOrder[#WaypointOrder+1] = StoutPalm;
WaypointOrder[#WaypointOrder+1] = TapacaeMiralis;
WaypointOrder[#WaypointOrder+1] = TinyOilPalm;
WaypointOrder[#WaypointOrder+1] = ToweringPalm;
WaypointOrder[#WaypointOrder+1] = Trilobellia;
WaypointOrder[#WaypointOrder+1] = UmbrellaPalm;
WaypointOrder[#WaypointOrder+1] = WindriverPalm;
WaypointOrder[#WaypointOrder+1] = SummerMaple;
WaypointOrder[#WaypointOrder+1] = WhitePine;
WaypointOrder[#WaypointOrder+1] = Safsaf;
WaypointOrder[#WaypointOrder+1] = SweetPine;
WaypointOrder[#WaypointOrder+1] = Papyrus;

WaypointTypes = {};
WaypointTypes[Waypoint] = "Waypoint";
WaypointTypes[Bonfire] = "Bonfire";
WaypointTypes[Warehouse] = "Warehouse";
WaypointTypes[MenuClick] = "Menu Click";
WaypointTypes[Water] = "Water";
WaypointTypes[ToweringPalm] = "Towering Palm";
WaypointTypes[RoyalPalm] = "Royal Palm";
WaypointTypes[StoutPalm] = "Stout Palm";
WaypointTypes[FernPalm] = "Fern Palm";
WaypointTypes[BottleTree] = "Bottle Tree";
WaypointTypes[Hokkaido] = "Hokkaido";
WaypointTypes[Ranyahn] = "Ranyahn";
WaypointTypes[BrambleHedge] = "Bramble Hedge";
WaypointTypes[CeruleanBlue] = "Cerulean Blue";
WaypointTypes[Bloodbark] = "Bloodbark";
WaypointTypes[Beetlenut] = "Beetlenut";
WaypointTypes[DeltaPalm] = "Delta Palm";
WaypointTypes[OilPalm] = "Oil Palm";
WaypointTypes[TinyOilPalm] = "Tiny Oil Palm";
WaypointTypes[Chicory] = "Chicory";
WaypointTypes[SpikedFishTree] = "Spiked Fish Tree";
WaypointTypes[PhoenixPalm] = "Phoenix Palm";
WaypointTypes[RedMaple] = "Red Maple";
WaypointTypes[Elephantia] = "Elephantia";
WaypointTypes[Passam] = "Passam";
WaypointTypes[SpindleTree] = "Spindle Tree";
WaypointTypes[UmbrellaPalm] = "Umbrella Palm";
WaypointTypes[WindriverPalm] = "Windriver Palm";
WaypointTypes[Oleaceae] = "Oleaceae";
WaypointTypes[Cinnar] = "Cinnar";
WaypointTypes[FoldedBirch] = "Folded Birch";
WaypointTypes[RazorPalm] = "Razor Palm";
WaypointTypes[BroadLeafPalm] = "Broad Leaf Palm";
WaypointTypes[ButterleafTree] = "Butterleaf Tree";
WaypointTypes[Orrorin] = "Orrorin";
WaypointTypes[FeatherTree] = "Feather Tree";
WaypointTypes[AshPalm] = "Ash Palm";
WaypointTypes[Kaeshra] = "Kaeshra";
WaypointTypes[TapacaeMiralis] = "Tapacae Miralis";
WaypointTypes[CoconutPalm] = "Coconut Palm";
WaypointTypes[MonkeyPalm] = "Monkey Palm";
WaypointTypes[LocustPalm] = "Locust Palm";
WaypointTypes[ChakkanutTree] = "Chakkanut Tree";
WaypointTypes[Anaxi] = "Anaxi";
WaypointTypes[MiniPalmetto] = "Mini Palmetto";
WaypointTypes[MiniatureFernPalm] = "Miniature Fern Palm";
WaypointTypes[Hawthorn] = "Hawthorn";
WaypointTypes[BrambleHedge] = "BrambleHedge";
WaypointTypes[Cricklewood] = "Cricklewood";
WaypointTypes[GiantCricklewood] = "Giant Cricklewood";
WaypointTypes[Arconis] = "Arconis";
WaypointTypes[PratyekaTree] = "Pratyeka Tree";
WaypointTypes[Savaka] = "Savaka";
WaypointTypes[Trilobellia] = "Trilobellia";
WaypointTypes[BlazeMaple] = "Blaze Maple";
WaypointTypes[Dikbas] = "Dikbas";
WaypointTypes[Illawara] = "Illawara";
WaypointTypes[Jacaranda] = "Jacaranda";
WaypointTypes[Katsura] = "Katsura";
WaypointTypes[Khaya] = "Khaya";
WaypointTypes[Mimosa] = "Mimosa";
WaypointTypes[MontereyPine] = "Monterey Pine";
WaypointTypes[MontuMaple] = "Montu Maple";
WaypointTypes[Oranje] = "Oranje";
WaypointTypes[Parrotia] = "Parrotia";
WaypointTypes[PnCMaple] = "Peaches 'n Cream Maple";
WaypointTypes[SilkyOak] = "Silky Oak";
WaypointTypes[AutumnBloodbark] = "Autumn Bloodbark";
WaypointTypes[RiverBirch] = "River Birch";
WaypointTypes[GoldenHemlock] = "Golden Hemlock";
WaypointTypes[JapaneseCherry] = "Japanese Cherry";
WaypointTypes[GreenAsh] = "Green Ash";
WaypointTypes[Acacia] = "Acacia";
WaypointTypes[SummerMaple] = "Summer Maple";
WaypointTypes[WhitePine] = "White Pine";
WaypointTypes[Safsaf] = "Safsaf";
WaypointTypes[SweetPine] = "Sweet Pine";
WaypointTypes[Papyrus] = "Papyrus";

WaypointColors = {};
WaypointColors[Bonfire] = 0x3F3325FF;
WaypointColors[Warehouse] = 0xD3AB86FF; -- was 0xA07338FF
WaypointColors[MenuClick] = 0x0;
WaypointColors[ToweringPalm] = 0x5E7C2FFF;
WaypointColors[RoyalPalm] = 0x83201FF;
WaypointColors[StoutPalm] = 0x546945FF;
WaypointColors[FernPalm] = 0x7A7E24FF;
WaypointColors[BottleTree] = 0x4F630CFF;
WaypointColors[Hokkaido] = 0x254A42FF;
WaypointColors[Ranyahn] = 0x986953FF;
WaypointColors[BrambleHedge] = 0x555452FF;
WaypointColors[CeruleanBlue] = 0x506A7CFF;
WaypointColors[Bloodbark] = 0x412324FF;
WaypointColors[Beetlenut] = 0x1E5229FF;
WaypointColors[DeltaPalm] = 0x8B97A6FF;
WaypointColors[OilPalm] = 0x335D2CFF;
WaypointColors[TinyOilPalm] = 0x356027FF;
WaypointColors[Chicory] = 0x547707FF;
WaypointColors[SpikedFishTree] = 0x94C34BFF;
WaypointColors[PhoenixPalm] = 0xB49F54FF;
WaypointColors[RedMaple] = 0x7B2101FF;
WaypointColors[Elephantia] = 0x6B974FFF;
WaypointColors[Passam] = 0x93AA90FF;
WaypointColors[SpindleTree] = 0x394314FF;
WaypointColors[UmbrellaPalm] = 0x475122FF;
WaypointColors[WindriverPalm] = 0xC1D00FF;
WaypointColors[Oleaceae] = 0x5C4722FF;
WaypointColors[Cinnar] = 0x4E6D1DFF;
WaypointColors[FoldedBirch] = 0x6B8935FF;
WaypointColors[RazorPalm] = 0x455839FF;
WaypointColors[BroadLeafPalm] = 0x3A3E13FF;
WaypointColors[ButterleafTree] = 0x5B6548FF;
WaypointColors[Orrorin] = 0x906D59FF;
WaypointColors[FeatherTree] = 0x152967FF;
WaypointColors[AshPalm] = 0x160013FF;
WaypointColors[Kaeshra] = 0x5E8B47FF;
WaypointColors[TapacaeMiralis] = 0x9D6848FF;
WaypointColors[CoconutPalm] = 0x8D8F51FF;
WaypointColors[MonkeyPalm] = 0x62605FFF;
WaypointColors[LocustPalm] = 0x9C8A7BFF;
WaypointColors[ChakkanutTree] = 0x3C3A32FF;
WaypointColors[Anaxi] = 0xC3838FF;
WaypointColors[MiniPalmetto] = 0x8B6B21FF;
WaypointColors[MiniatureFernPalm] = 0x656917FF;
WaypointColors[Hawthorn] = 0x1E1B1CFF;
WaypointColors[Cricklewood] = 0x5D2F00FF;
WaypointColors[GiantCricklewood] = 0x401500FF;
WaypointColors[Arconis] = 0x508729FF;
WaypointColors[PratyekaTree] = 0x253A0EFF;
WaypointColors[Savaka] = 0x557919FF;
WaypointColors[Trilobellia] = 0x9C7A02FF;
WaypointColors[BlazeMaple] = 0xC40606FF;
WaypointColors[Dikbas] = 0xC39593FF;
WaypointColors[Illawara] = 0xDAD0CFFF;
WaypointColors[Jacaranda] = 0xC97DFFFF;
WaypointColors[Katsura] = 0xCD5932FF;
WaypointColors[Khaya] = 0x57570DFF;
WaypointColors[Mimosa] = 0x598742FF;
WaypointColors[MontereyPine] = 0x775701FF;
WaypointColors[MontuMaple] = 0xAE4600FF;
WaypointColors[Oranje] = 0xCC761AFF;
WaypointColors[Parrotia] = 0xF2C43CFF;
WaypointColors[PnCMaple] = 0xE64500FF;
WaypointColors[SilkyOak] = 0xA6B022FF;
WaypointColors[AutumnBloodbark] = 0x7B0C0CFF;
WaypointColors[RiverBirch] = 0xDD9E52FF;
WaypointColors[GoldenHemlock] = 0xD5BF16FF;
WaypointColors[JapaneseCherry] = 0xECA4ECFF;
WaypointColors[GreenAsh] = 0xFFFF25FF;
WaypointColors[Acacia] = 0x5D5913FF;
WaypointColors[SummerMaple] = 0x1C711CFF;
WaypointColors[WhitePine] = 0x0A830AFF;
WaypointColors[Safsaf] = 0x076501FF;
WaypointColors[SweetPine] = 0x97BE7DFF;

keyDelay = 30;
minDelta = 45;

wood = false;
slate = false;
grass = false;
clay = false;
papy = false;
repeatForever = true;
juglessGather = false;

gather_iterations = 0;
gather_randomNumber = 0;
unique = 0;

walkingRoute = false;
routeStartTime = 0;

function doit()
    if(not promptOkay("WARNING! This macro requires your chats to be minimized and your \"Use arrow keys for movement\" option to be enabled. Enable fast gather from the One-Click Options menu.")) then
        return;
    end
    if(not promptOkay("Time of day, shadows and light intensity should be on lowest setting. Updated for T8 by Manon.")) then
        return;
    end
    math.randomseed(lsGetTimer());
    gather_randomNumber = math.random();

    loadRoutes();
    queryRoute();
end

function updateUnique()
    gather_iterations = gather_iterations + 1;
    unique = gather_iterations .. "_" .. gather_randomNumber;
end

route = 0;

function queryRoute()
    local scale = 1.4;
    local z = 0;
    local done = false;
    local nada = nil;

    while not done do
        local showEditRoute = nil;
        checkBreak();
        lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
        local y = 10;
        lsPrint(5, y, z, 1, 1, 0xFFFFFFff, "Route:");
        y = y + 32;
        route = readSetting("route",route);
        route = lsDropdown("routeToWalk" .. unique, 5, y, 0, 405, route, routeNames);
        writeSetting("route",route);
        y = y + 32;
        if lsButtonText(5, y, z, 80, 0xFFFFFFff, "New") then
            showEditRoute = #routeNames+1;
        end
        if lsButtonText(93, y, z, 80, 0xFFFFFFff, "Edit") then
            showEditRoute = route;
        end
        if lsButtonText(181, y, z, 80, 0xFFFFFFff, "Delete") then
            if(promptOkay("Are you sure you want to delete route \"" .. routeNames[route] .. "\"?")) then
                if(deleteRoute(route)) then
                    route = route - 1;
                    if(route < 1) then
                        route = 1;
                    end
                    updateUnique();
                end
            end
        end
        y = y + 64;
        wood = readSetting("wood",wood);
        wood = lsCheckBox(10, y, z, 0xFFFFFFff, " Gather wood", wood);
        writeSetting("wood",wood);
        y = y + 32;
        slate = readSetting("slate",slate);
        slate = lsCheckBox(10, y, z, 0xFFFFFFff, " Gather slate", slate);
        writeSetting("slate",slate);
        y = y + 32;
        grass = readSetting("grass",grass);
        grass = lsCheckBox(10, y, z, 0xFFFFFFff, " Gather grass", grass);
        writeSetting("grass",grass);
        y = y + 32;
        clay = readSetting("clay",clay);
        clay = lsCheckBox(10, y, z, 0xFFFFFFff, " Gather clay and flint", clay);
        writeSetting("clay",clay);
        y = y + 36;
        papy = readSetting("papy",papy);
        papy = lsCheckBox(10, y, z, 0xFFFFFFff, " Plant Papyrus", papy);
        writeSetting("papy",papy);
        if(papy) then
			y = y + 32;
				lsPrint(35, y+5, z, 1, 1, 0xFFFFFFff, "Pass Delay (ms)");
				papyDelay = readSetting("papyDelay",papyDelay);
				nada, papyDelay = lsEditBox("papyDelay",
					200, y+7, z, 70, 0, 1.0, 1.0, 0x000000ff, papyDelay);
				writeSetting("papyDelay",papyDelay);
				if (papy and (not tonumber(papyDelay))) then
					lsPrint(35, y+32, z+10, 0.9, 0.9, 0xFF2020ff, "MUST BE A NUMBER");
				end
		end
        y = y + 36;
        repeatForever = readSetting("repeatForever",repeatForever);
        repeatForever = lsCheckBox(10, y, z, 0xFFFFFFff, " Repeat forever", repeatForever);
        writeSetting("repeatForever",repeatForever);
        lsSetCamera(0,0,lsScreenX,lsScreenY);
        if lsButtonText(10, 320, z, 90, 0xFFFFFFff, "GO!") then
            followRoute(route);
        end
        if lsButtonText(200, 320, z, 90, 0xFFFFFFff, "Exit") then
            done = true;
            return;
        end
        lsDoFrame();
        lsSleep(tick_delay);
        if(showEditRoute) then
            if(editRoute(showEditRoute)) then
                route = showEditRoute;
                updateUnique();
            end
            showEditRoute = nil;
        end
    end
end

function deleteRoute(route)
    local temp = {};
    local i;
    local j;
    for i = 1, #routes do
        if(i < route) then
            j = i;
        else
            j = i - 1;
        end
        if(i ~= route) then
            temp[j] = {};
            temp[j][0] = routes[i][0];
            temp[j][1] = {};
            local k;
            for k = 1, #routes[i][1] do
                temp[j][1][k] = {};
                temp[j][1][k][1] = routes[i][1][k][1];
                temp[j][1][k][2] = routes[i][1][k][2];
                temp[j][1][k][3] = routes[i][1][k][3];
            end
        end
    end
    routes = {};
    for i = 1, #temp do
        routes[i] = {};
        routes[i][0] = temp[i][0];
        routes[i][1] = {};
        for j = 1, #temp[i][1] do
            routes[i][1][j] = {};
            routes[i][1][j][1] = temp[i][1][j][1];
            routes[i][1][j][2] = temp[i][1][j][2];
            routes[i][1][j][3] = temp[i][1][j][3];
        end
    end
    saveRoutes();
    return true;
end


function editRoute(route)
    local scale = 1.4;
    local z = 0;
    local done = nil;
    local nada = nil;

    lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
--    lsScreenX = 500;
--    lsScreenY = 500;

    local WaypointTypesOrdered = {};
    local i;
    for i = 1, #WaypointTypes do
        WaypointTypesOrdered[i] = WaypointTypes[WaypointOrder[i]];
    end

    local thisRoute = {};
    if(route <= #routeNames) then
        thisRoute[0] = routes[route][0];
        thisRoute[1] = {};
        local i;
        for i = 1, #routes[route][1] do
            thisRoute[1][i] = {};
            thisRoute[1][i][1] = routes[route][1][i][1];
            thisRoute[1][i][2] = routes[route][1][i][2];
            thisRoute[1][i][3] = routes[route][1][i][3];
        end
        thisRoute[2] = {};
        if(#routes[route] < 2) then
            thisRoute[2][1] = "";
        else
            for i = 1, #routes[route][2] do
                thisRoute[2][i] = routes[route][2][i];
            end
        end
    else
        thisRoute[0] = "";
        thisRoute[1] = {};
        thisRoute[1][1] = {};
        thisRoute[1][1][1] = 0;
        thisRoute[1][1][2] = 0;
        thisRoute[1][1][3] = 1;
        thisRoute[2] = {};
        thisRoute[2][1] = "";
    end

    updateUnique();
    while not done do
        checkBreak();
        if(lsControlHeld()) then
            while(lsControlHeld()) do
                lsPrintWrapped(10, 10, z, lsScreenX, 1, 1, 0xFFFFFFff, "Release the Ctrl key");
                lsDoFrame();
                lsSleep(tick_delay);
            end
            local routePos = #thisRoute[1];
            thisRoute = insertWaypointAfter(routePos,thisRoute);
            routePos = routePos + 1;
            updateUnique();
            local pos = getCoords();
            thisRoute[1][routePos][1] = pos[0];
            thisRoute[1][routePos][2] = pos[1];
        end
        local gotoRoute = nil;
        local y = 10;
        lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
        lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Route:");
        y = y + 32;
        done, thisRoute[0] = lsEditBox("routeName" .. unique,
            5, y, z, 404, 30, scale, scale, 0x000000ff, thisRoute[0]);
        done = nil;
        y = y + 50;
        lsScrollAreaBegin("routeScrollArea",
            5, y, z, 405, 330);
        y = y + 5;
        local haveMenuClick = false;
        local i;
        local sy = 0;
        for i = 1, #thisRoute[1] do
            local x = 0;
            local coordw = 60;
            local waypointw = 195;
            local buttonw = 20;
            if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "+") then
                thisRoute = insertWaypointAfter(i,thisRoute);
                updateUnique();
            end
            x = x + buttonw + 2;
            if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "-") then
                thisRoute = deleteWaypoint(i, thisRoute);
                updateUnique();
            end
            x = x + buttonw + 2;
            if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "G") then
                gotoRoute = i;
            end
            x = x + buttonw + 2;
            local t;
            if(#thisRoute[1] >= i) then
                t = thisRoute[1][i][1];
            end
            nada, t = lsEditBox("waypointX_" .. i .. "_" .. unique,
                x, sy, z+1, coordw, 30, scale, scale, 0x000000ff, t);
            if(#thisRoute[1] >= i) then
                thisRoute[1][i][1] = t;
            end
            x = x + coordw + 2;
            if(#thisRoute[1] >= i) then
                t = thisRoute[1][i][2];
            end
            nada, t = lsEditBox("waypointY_" .. i .. "_" .. unique,
                x, sy, z+1, coordw, 30, scale, scale, 0x000000ff, t);
            if(#thisRoute[1] >= i) then
                thisRoute[1][i][2] = t;
            end
            x = x + coordw + 2;
            if(#thisRoute[1] >= i) then
                t = findWaypointOrder(thisRoute[1][i][3]);
            end
            t = lsDropdown("waypointType_" .. i .. "_" .. unique,
                x, sy, z, waypointw, t, WaypointTypesOrdered);
            if(#thisRoute[1] >= i) then
                thisRoute[1][i][3] = WaypointOrder[t];
                if(thisRoute[1][i][3] == MenuClick) then
                    haveMenuClick = true;
                end
            end
            x = x + waypointw*scale + 2;
            sy = sy + 32;
        end
        if(haveMenuClick) then
            sy = sy + 32;
            lsPrint(5, sy, z, 1, 1, 0xFFFFFFff, "Menu text to find");
            sy = sy + 32;
            local deleteOne = nil;
            local i;
            for i = 1, #thisRoute[2] do
                local x = 0;
                local buttonw = 20;
                if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "+") then
                    thisRoute = insertMenuTextAfter(i,thisRoute);
                    updateUnique();
                end
                x = x + buttonw + 2;
                if(i > 1) then
                    if lsButtonText(x, sy, z, buttonw, 0xFFFFFFff, "-") then
                        deleteOne = i;
                    end
                end
                x = x + buttonw + 2;
                t = thisRoute[2][i];
                nada, t = lsEditBox("menuText_" .. i .. "_" .. unique,
                    x, sy, z+1, 300, 30, scale, scale, 0x000000ff, t);
                thisRoute[2][i] = t;
                sy = sy + 32;
            end
            if(deleteOne) then
                thisRoute = deleteMenuText(deleteOne, thisRoute);
                updateUnique();
            end
        end
        sy = sy + 32;
        lsPrintWrapped(10, sy, z, lsScreenX, 1, 1, 0xFFFFFFff, "Tap Ctrl to add a waypoint using your current location");
        local height = #thisRoute[1] + #WaypointTypes;
        lsScrollAreaEnd(25 * height);
        y = y + 362;
        done = nil;
        if lsButtonText(10, y, z, 90, 0xFFFFFFff, "Save") then
            if(routeText == "") then
                if(not PromptOkay("There's nothing to save.")) then
                    done = false;
                end
            elseif(routeName == "") then
                if(not PromptOkay("Every route needs a name.")) then
                    done = false;
                end
            else
                done = true;
                saveRoute(thisRoute,route);
                return true;
            end
        end
        if lsButtonText(190*scale, y, z, 90, 0xFFFFFFff, "Cancel") then
            loadRoutes();
            done = true;
        end
        lsDoFrame();
        lsSleep(tick_delay);
        if(gotoRoute) then
            routeTo(gotoRoute, thisRoute);
            updateUnique();
        end
    end
    return false;
end

function clearScrollArea(area)
    lsPrintln(">>clearScrollArea()");
    lsScrollAreaEnd(1);
end

function alreadyExists(name)
    local i;
    for i = 1, #routes do
        if(name == routes[i][0]) then
            return true;
        end
    end
    return false;
end

function deleteNamedRoute(name)
    local temp = {};
    local i;
    local j = 1;
    for i = 1, #routes do
        if(name ~= routes[i][0]) then
            temp[j] = {};
            temp[j][0] = routes[i][0];
            temp[j][1] = {};
            local k;
            for k = 1, #routes[i][1] do
                temp[j][1][k] = {};
                temp[j][1][k][1] = routes[j][1][k][1];
                temp[j][1][k][2] = routes[j][1][k][2];
                temp[j][1][k][3] = routes[j][1][k][3];
            end
            j = j + 1;
        end
    end
    routes = {};
    for i = 1, #temp do
        routes[i] = {};
        routes[i][0] = temp[i][0];
        routes[i][1] = {};
        for j = 1, #temp[i][1] do
            routes[i][1][j] = {};
            routes[i][1][j][1] = temp[i][1][j][1];
            routes[i][1][j][2] = temp[i][1][j][2];
            routes[i][1][j][3] = temp[i][1][j][3];
        end
    end
end

function insertWaypointAfter(where,thisRoute)
    local temp = {};
    local i;
    for i = 1, ((#thisRoute[1]) + 1) do
        temp[i] = {};
        if(i <= where) then
            temp[i][1] = thisRoute[1][i][1];
            temp[i][2] = thisRoute[1][i][2];
            temp[i][3] = thisRoute[1][i][3];
        elseif(i == where + 1) then
            temp[i][1] = 0;
            temp[i][2] = 0;
            temp[i][3] = 1;
        else
            temp[i][1] = thisRoute[1][i-1][1];
            temp[i][2] = thisRoute[1][i-1][2];
            temp[i][3] = thisRoute[1][i-1][3];
        end
    end
    thisRoute[1] = {};
    for i = 1, #temp do
        thisRoute[1][i] = {};
        thisRoute[1][i][1] = temp[i][1];
        thisRoute[1][i][2] = temp[i][2];
        thisRoute[1][i][3] = temp[i][3];
    end
    return thisRoute;
end


function deleteWaypoint(where,thisRoute)
    if(#thisRoute[1] == 1) then
        thisRoute[1][1][1] = 0;
        thisRoute[1][1][2] = 0;
        thisRoute[1][1][3] = 1;
        return thisRoute;
    end

    local temp = {};
    local i;
    for i = 1, #thisRoute[1] do
        if(i < where) then
            temp[i] = {};
            temp[i][1] = thisRoute[1][i][1];
            temp[i][2] = thisRoute[1][i][2];
            temp[i][3] = thisRoute[1][i][3];
        elseif(i > where) then
            temp[i-1] = {};
            temp[i-1][1] = thisRoute[1][i][1];
            temp[i-1][2] = thisRoute[1][i][2];
            temp[i-1][3] = thisRoute[1][i][3];
        end
    end
    thisRoute[1] = {};
    for i = 1, #temp do
        thisRoute[1][i] = {};
        thisRoute[1][i][1] = temp[i][1];
        thisRoute[1][i][2] = temp[i][2];
        thisRoute[1][i][3] = temp[i][3];
    end
    return thisRoute;
end

function saveRoute(thisRoute,route)
    local r = route;
    routes[r] = {};
    routes[r][0] = thisRoute[0];
    routes[r][1] = {};
    routes[r][2] = {};
    local i;
    for i = 1, #thisRoute[1] do
        routes[r][1][i] = {};
        routes[r][1][i][1] = thisRoute[1][i][1];
        routes[r][1][i][2] = thisRoute[1][i][2];
        routes[r][1][i][3] = thisRoute[1][i][3];
    end
    for i = 1, #thisRoute[2] do
        routes[r][2][i] = thisRoute[2][i];
    end
    serialize(routes,routeFileName);
    loadRoutes();
end

function saveRoutes()
    serialize(routes,routeFileName);
    loadRoutes();
end

function loadRoutes()
    routes = {};
    routeNames = {};
    local success = false;
    if(pcall(dofile,routeFileName)) then
        success, routes = deserialize(routeFileName);
    else
        if(pcall(dofile,defaultRoutesFileName)) then
            success, routes = deserialize(defaultRoutesFileName);
        end
    end
    if(not success) then
        error("Cannot find any routes.  Please try updating the macros again.");
    end
    local i;
    for k,v in pairs(routes) do
        routeNames[k] = routes[k][0];
    end
end

function routeTo(waypoint,thisRoute)
    prepareForWalking();
    local x = tonumber(thisRoute[1][waypoint][1]);
    local y = tonumber(thisRoute[1][waypoint][2]);
    walkTo(x, y, true);
end

function followRoute(route)
    if(slate or clay or grass or wood or papy) then
        local haveWarehouse = false;
        local i;
        for i = 1, #routes[route][1] do
            if(routes[route][1][i][3] == Warehouse) then
                haveWarehouse = true;
            end
        end
        if(not haveWarehouse) then
            if papy then 
                haveWarehouse = false;
            else
                if(not promptOkay("This route does not include a warehouse.  If you add a warehouse's coords to this route, resources will be stashed there every time you reach those coordinates.")) then
                    return;
                end
            end
        end
    else
        if(not wood or slate or clay or grass or papy) then
            if(not promptOkay("You have not specified any resources to gather.  Are you sure that's what you want?")) then
                return;
            end
        end
    end
    prepareForWalking();
    local curr = 1;
    local fails = 0;
    local direction = 1;
    local lastPos = {0,0};
    local r = routes[route][1];
    routeStartTime = lsGetTimer();
    walkingRoute = true;
    while (1) do
        updateStatus();
        srReadScreen();
        local pos;
        pos = findCoords();
        if (pos) then
            lastPos = pos;
        end
        setStatus("Moving to " .. WaypointTypes[r[curr][3]] .. "\n(" .. r[curr][1] .. ", " .. r[curr][2] .. ")");
        if(not walkTo(r[curr][1],r[curr][2])) then
            return;
        end
        if(r[curr][3] == MenuClick) then
            if(#routes[route] > 2 or #routes[route][2] > 0) then
                refreshMenus();
                doMenuClick(routes[route][2][1]);
            end
        elseif(r[curr][3] == Bonfire) then
            if(ensureClickWaypoint(r,curr)) then
                stashWood();
            end
        elseif(r[curr][3] == Warehouse) then
            srReadScreen()
            local stash = findText("Stash...")
            if stash then
                stashAllButWood();
            end
        elseif(papy and r[curr][3] ~= Waypoint) then
            plantPapy();
        elseif(r[curr][3] == Water) then
            while(not fillJugs()) do
                walkTo(r[curr][1]+math.random(-1,1),r[curr][2]+math.random(-1,1),false,false);
                if(not walkTo(r[curr][1],r[curr][2])) then
                    return false;
                end
            end
        elseif(wood and r[curr][3] ~= Waypoint) then
            if(ensureClickWaypoint(r,curr)) then
                lsSleep(250);
                srReadScreen();
                noWoodMenuPos = findText("no Wood");
                if(noWoodMenuPos) then
                    safeClick(noWoodMenuPos[0]-7,noWoodMenuPos[1]);
                    lsSleep(250);
                else
                    utilityPos = findText("Utility");
                    if(utilityPos) then
                        safeClick(utilityPos[0]-7,utilityPos[1]);
                        lsSleep(250);
                    else
                        sleepWithBreak(1000);
                    end
                end
                srReadScreen();
            end
        end
        curr = curr + 1;
        if(curr > #r) then
            curr = 1;
            if papyDelay then
                sleepWithStatus(tonumber(papyDelay), "Waiting before starting next round")
            end
            if(not repeatForever) then
                routeStartTime = 0;
                walkingRoute = false;
                return;
            end
        end
    end
    routeStartTime = 0;
    walkingRoute = false;
end

function fillJugs()
    stopMoving();
    lsSleep(2000);
    srReadScreen();
    local pos = srFindImage("water.png",5000);
    if(pos) then
        safeClick(pos[0],pos[1]);
        lsSleep(1000);
        srReadScreen();
        clickMax();
        emptyJugs = 0;
        lsSleep(2500);
        return true;
    end
    return false;
end

function sign(x)
    if(x > 0) then
        return 1;
    end
    if(x == 0) then
        return 0;
    end
    return -1;
end

function ensureClickWaypoint(route,waypoint)
    lsSleep(300);
    local typeOfWaypoint = route[waypoint][3];
    local lastWaypoint;
    if(waypoint > 1) then
        lastWaypoint = waypoint - 1;
    else
        lastWaypoint = #route;
    end
    local dx = sign(route[waypoint][1] - route[lastWaypoint][1]);
    local dy = sign(route[waypoint][2] - route[lastWaypoint][2]);
    local direction;
    if(dx < 0) then
        if(dy < 0) then
            direction = 1;
        else
            direction = 2;
        end
    else
        if(dx < 0) then
            direction = 3;
        else
            direction = 4;
        end
    end
    local fails;
    for fails = 1, 4 do
        if(clickWaypoint(route[waypoint][3])) then
            return true;
        end
        pos = findCoords();
        if(pos) then
            if(direction == 1) then
                walkTo(route[waypoint][1]-1,route[waypoint][2]-1,false,false);
                walkTo(route[waypoint][1]+1,route[waypoint][2]+1,false,false);
            elseif (direction == 2) then
                walkTo(route[waypoint][1]-1,route[waypoint][2]+1,false,false);
                walkTo(route[waypoint][1]+1,route[waypoint][2]-1,false,false);
            elseif (direction == 3) then
                walkTo(route[waypoint][1]+1,route[waypoint][2]-1,false,false);
                walkTo(route[waypoint][1]-1,route[waypoint][2]+1,false,false);
            else
                walkTo(route[waypoint][1]+1,route[waypoint][2]+1,false,false);
                walkTo(route[waypoint][1]-1,route[waypoint][2]-1,false,false);
            end
            if(not walkTo(route[waypoint][1],route[waypoint][2])) then
                return false;
            end
            direction = direction + 1
            if(direction > 4) then
                direction = 1;
            end
        end
    end
    return false;
end

function clickWaypoint(typeOfWaypoint)
    local xyWindowSize = srGetWindowSize();
    local mid = {};
    mid[0] = xyWindowSize[0] / 2;
    mid[1] = xyWindowSize[1] / 2;
    --srSetMousePos(mid[0],mid[1]);
    local dx;
    local dy;
    local delta;
    local offset = {};
    setStatus("Looking for " .. WaypointTypes[typeOfWaypoint]);
    srReadScreen();
    local xyWindowSize = srGetWindowSize();
    local maxDelta = math.max(xyWindowSize[0] / 2.1, xyWindowSize[1] / 2.1);
    for delta = minDelta, maxDelta, 5 do
        local minX = math.max(0, mid[0] - delta);
        local minY = math.max(0, mid[1] - delta);
        local maxX = math.min(mid[0] + delta, xyWindowSize[0]-1);
        local maxY = math.min(mid[1] + delta, xyWindowSize[1]-1);
        for dx = (delta * -1), delta, 3 do
            if(mid[0]+dx < xyWindowSize[0]) then
                if(clickWaypointPixel(mid[0]+dx,maxY,typeOfWaypoint)) then
                    return true;
                end
                if(clickWaypointPixel(mid[0]+dx,minY,typeOfWaypoint)) then
                    return true;
                end
            end
        end
        for dy = (delta * -1), delta, 3 do
            if(mid[1]+dy < xyWindowSize[1]) then
                if(clickWaypointPixel(maxX,mid[1]+dy,typeOfWaypoint)) then
                    return true;
                end
                if(clickWaypointPixel(minX,mid[1]-dy,typeOfWaypoint)) then
                    return true;
                end
            end
        end
    end
    return false;
end

function clickWaypointPixel(x, y, typeOfWaypoint)

    local pos = {};
    local xyWindowSize = srGetWindowSize();

    checkBreak();
    if(typeOfWaypoint == Bonfire) then
        local currColor = srReadPixelFromBuffer(x, y);

        if(compareColorEx(WaypointColors[typeOfWaypoint],currColor,6,2)) then
            local mid = {};
            mid[0] = xyWindowSize[0] / 2;
            mid[1] = xyWindowSize[1] / 2;
            safeClick(x,y);
            lsSleep(150);
            srReadScreen();
            local pos = findText("Bonfire");
            if(not pos) then
                lsPrintln("Looking for " .. WaypointTypes[typeOfWaypoint] .. " but clicking didn't bring up a menu.");
                return false;
            end
            setStatus(WaypointTypes[typeOfWaypoint] .. " clicked");
            lsPrintln(WaypointTypes[typeOfWaypoint] .. " clicked");
            return true;
        end
        return false;
    end
    local radius = 2;
    local rgbTol = 450;
    local hueTol = 450;

    local roughness = 20;
    if (typeOfWaypoint == Oranje) or (typeOfWaypoint == Ranyahn) or (typeOfWaypoint == Hawthorn) or (typeOfWaypoint == MiniatureFernPalm) then
        roughness = 100;
        radius = 4;
    end
    local foundSomething = false;
    if(pixelBlockCheck(x, y, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius)) then
        if(typeOfWaypoint == Warehouse) then
            stopMoving();
            lsSleep(500);
            local mid = {};
            mid[0] = xyWindowSize[0] / 2;
            mid[1] = xyWindowSize[1] / 2;
            --srSetMousePos(mid[0],mid[1]);
            safeClick(x,y);
            lsSleep(150);
            srReadScreen();
            local pos = findText("full");
            if(not pos) then
                lsPrintln("Looking for " .. WaypointTypes[typeOfWaypoint] .. " but clicking didn't bring up a menu.");
                checkForMenu();
                return false;
            end
            setStatus(WaypointTypes[typeOfWaypoint] .. " clicked");
            lsPrintln(WaypointTypes[typeOfWaypoint] .. " clicked");
--            safeClick(x-5,y);
            lsSleep(150);
            srReadScreen();
            return true;
        else
            if(pixelBlockCheck(x + radius*2, y + radius*2, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius) and
               pixelBlockCheck(x - radius*2, y - radius*2, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius)) then
                foundSomething = true;
            end
            if(pixelBlockCheck(x - radius*2, y + radius*2, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius) and
               pixelBlockCheck(x + radius*2, y - radius*2, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius)) then
                foundSomething = true;
            end
            if(pixelBlockCheck(x, y + radius*2, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius) and
               pixelBlockCheck(x, y - radius*2, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius)) then
                foundSomething = true;
            end
            if(pixelBlockCheck(x - radius*2, y, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius) and
               pixelBlockCheck(x + radius*2, y, WaypointColors[typeOfWaypoint], rgbTol, hueTol, roughness, radius)) then
                foundSomething = true;
            end
        end
    end
    if(foundSomething) then
        safeClick(x,y);
        lsSleep(150);
        srReadScreen();
        pos = findText("Examine this");
        if(pos) then
            safeClick(x-5,y);
            lsPrintln("Found a plant, but didn't want that.");
            return false;
        end
        pos = findText("This is");
        if(pos) then
            safeClick(x-5,y);
            lsPrintln("Found something other than " .. WaypointTypes[typeOfWaypoint]);
            return false;
        end
        setStatus(WaypointTypes[typeOfWaypoint] .. " clicked");
        lsPrintln(WaypointTypes[typeOfWaypoint] .. " clicked");
        return true;
    end
    return false;
end

function pixelBlockCheck(x, y, color, rgbTol, hueTol, roughness, size)
    local startX = x - size;
    local startY = y - size;
    local endX = x + size;
    local endY = y + size;
    local i;
    for i = startX, endX do
        local j;
        for j = startY, endY do
            local currColor = srReadPixelFromBuffer(x, y);
            if(not compareColorEx(color,currColor,rgbTol,hueTol)) then
                return false;
            end
            local totalRoughness = 0;
            local dx;
            for dx = -1, 1 do
                local dy;
                for dy = -1, 1 do
                    if(dx ~= 0 or dy ~= 0) then
                        local neighbor = srReadPixelFromBuffer(x + dx, y + dy);
                        totalRoughness = totalRoughness + compareColor(currColor,neighbor);
                        if(totalRoughness > roughness) then
                            return false;
                        end
                    end
                end
            end
        end
    end
    return true;
end

function stopMoving()
    srKeyUp(VK_ALL);
    movingLeft = false;
    movingRight = false;
    movingUp = false;
    movingDown = false;
end

function walkTo(x, y, showStatus, promptIfNotMoving)
    if(promptIfNotMoving == nil) then
        promptIfNotMoving = true;
    end
    local moveDelay = 1; -- 25;
    local movingRight = false;
    local movingLeft = false;
    local movingUp = false;
    local movingDown = false;
    local lastRightLeftChange = 0;
    local lastUpDownChange = 0;
    local xn = tonumber(x);
    local yn = tonumber(y);
    if(not showStatus) then
        showStatus = false;
    end
    local direction = 1;
    local errorCount = 0;
    local moving = false;
    local lastMoveTime = lsGetTimer();
    local lastPos = {};
    lastPos[0] = 0;
    lastPos[1] = 0;
    while(1) do
        updateStatus();
        srReadScreen();
        if(checkSlate() or checkClay() or checkGrass()) then
            moving = true;
            lastMoveTime = lsGetTimer();
        end
        checkForMenu();
        local pos;
        pos = findCoords();
        if (pos) then
            if(#pos < 1) then
                fatalError("#pos < 2 in walkTo() ... (" .. #pos .. ")");
            end
            if(pos[0] == lastPos[0] and pos[1] == lastPos[1]) then
                moving = false;
                if(lsGetTimer() > lastMoveTime + 8000) then
                    if(promptIfNotMoving) then
                        if(not promptOkay("You don't appear to be moving.  Are your chats minimized?  Is your \"Use arrow keys for movement\" option enabled?")) then
                            stopMoving();
                            return false;
                        end
                    else
                        stopMoving();
                        return false;
                    end
                    lastMoveTime = lsGetTimer();
                end
            else
                moving = true;
                lastMoveTime = lsGetTimer();
                lastPos = pos;
            end
            if(showStatus) then
                setStatus("Moving from (" .. pos[0] .. ", " .. pos[1] .. ")\nTo (" .. xn .. ", " .. yn .. ")");
            end
            errorCount = 0;
            if((pos[0] == xn) and (pos[1] == yn)) then
                srReadScreen();
                srKeyUp(VK_ALL);
                return true;
            end
            if(pos[0] < xn) then
                if(movingLeft) then
                    srKeyUp(VK_LEFT);
                    movingLeft = false;
                    lastRightLeftChange = 0;
                end
                t = lsGetTimer();
                if(lastRightLeftChange < t - 100 or not movingRight) then
                    srKeyDown(VK_RIGHT);
                    movingRight = true;
                    lastRightLeftChange = t;
                end
            elseif(pos[0] > xn) then
                if(movingRight) then
                    srKeyUp(VK_RIGHT);
                    movingRight = false;
                    lastRightLeftChange = 0;
                end
                t = lsGetTimer();
                if(lastRightLeftChange < t - 100 or not movingLeft) then
                    srKeyDown(VK_LEFT);
                    movingLeft = true;
                    lastRightLeftChange = t;
                end
            else
                if(movingLeft) then
                    srKeyUp(VK_LEFT);
                    movingLeft = false;
                    lastRightLeftChange = 0;
                elseif(movingRight) then
                    srKeyUp(VK_RIGHT);
                    movingRight = false;
                    lastRightLeftChange = 0;
                end
            end
            if(pos[1] < yn) then
                if(movingDown) then
                    srKeyUp(VK_DOWN);
                    movingDown = false;
                    lastUpDownChange = 0;
                end
                t = lsGetTimer();
                if(lastUpDownChange < t - 100 or not movingUp) then
                    srKeyDown(VK_UP);
                    movingUp = true;
                    lastUpDownChange = t;
                end
            elseif(pos[1] > yn) then
                if(movingUp) then
                    srKeyUp(VK_UP);
                    movingUp = false;
                    lastUpDownChange = 0;
                end
                t = lsGetTimer();
                if(lastUpDownChange < t - 100 or not movingDown) then
                    srKeyDown(VK_DOWN);
                    movingDown = true;
                    lastUpDownChange = t;
                end
            else
                if(movingDown) then
                    srKeyUp(VK_DOWN);
                    movingDown = false;
                    lastUpDownChange = 0;
                elseif(movingUp) then
                    srKeyUp(VK_UP);
                    movingUp = false;
                    lastUpDownChange = 0;
                end
            end
--            lsSleep(moveDelay);
        else
            errorCount = errorCount + 1;
            setStatus("Can't find position.  Make sure clockloc is shown. (" .. errorCount .. ")");
            lsSleep(1000);
            if(direction == 1) then
                srRightArrow();
            elseif (direction == 2) then
                srLeftArrow();
            elseif (direction == 3) then
                srUpArrow();
            else
                srDownArrow();
            end
            lsSleep(keyDelay);
            direction = direction + 1;
            if(direction > 4) then
                direction = 1;
            end
        end
        pos = srFindImage("DoYouWantToDropSomething.png",5000);
        if(pos) then
            fatalError("You are overloaded.");
        end
        pos = srFindImage("cancelThin.png",5000);
        if(pos) then
            safeClick(pos[0]+5,pos[1]+5);
        end
    end
    srKeyUp(VK_ALL);
end

function checkSlate()
    if(not slate) then
        return false;
    end
    local pos = srFindImage("slate.png");
    if(pos) then
        stopMoving();
        safeClick(pos[0] + 3, pos[1] + 3);
        sleepWithBreak(1500);
        return true;
    end
    return false;
end

function checkGrass()
    if(not grass) then
        return false;
    end
    local pos = srFindImage("grass.png");
    if(pos) then
        safeClick(pos[0] + 3, pos[1] + 3);
        sleepWithBreak(1250);
        return true;
    end
    return false;
end

function checkClay()
    if(not clay) then
        return false;
    end
    local xyWindowSize = srGetWindowSize();
    local midX = xyWindowSize[0] / 2;
    local xyWindowSize = srGetWindowSize();
    local midX = xyWindowSize[0] / 2;
    local pos = srFindImage("clay.png");
    if(pos) then
        safeClick(pos[0] + 3, pos[1] + 3);
        sleepWithBreak(1250);
        return true;
    end
    return false;
end

function clickColor(color)
    local xyWindowSize = srGetWindowSize();
    local mid = {};
    mid[0] = xyWindowSize[0] / 2;
    mid[1] = xyWindowSize[1] / 2;
    --srSetMousePos(mid[0],mid[1]);
    local dx;
    local dy;
    local delta;
    local offset = {};
    setStatus("Searching...");
    srReadScreen();
    for delta = 1, 300, 2 do
        for dx = (delta * -1), delta do
            if(clickColorPixel(mid[0]+dx,mid[1]+delta,color)) then
                return true;
            end
            if(clickColorPixel(mid[0]+dx,mid[1]-delta,color)) then
                return true;
            end
        end
        for dy = (delta * -1), delta do
            if(clickColorPixel(mid[0]+delta,mid[1]+dy,color)) then
                return true;
            end
            if(clickColorPixel(mid[0]-delta,mid[1]-dy,color)) then
                return true;
            end
        end
    end
    return false;
end

function clickColorPixel(x, y, color)
    local pos = {};
    pos[0] = x;
    pos[1] = y;
    local offset = {};
    offset[0] = 0;
    offset[1] = 0;
    local currColor = srReadPixelFromBuffer(x, y);
    checkBreak();
    if(math.floor(currColor/256) == math.floor(color/256)) then
        safeClick(pos[0],pos[1]);
        lsSleep(250);
        return true;
    end
    return false;
end

function clickMax()
    srReadScreen();
    local maxButton = srFindImage("max.png",3000);
    if(maxButton) then
        srClickMouseNoMove(maxButton[0]+5,maxButton[1],0);
    else
        fatalError("Unable to find the Max button");
    end
    lsSleep(150);
    srReadScreen();
end

function stashWood()
    lsSleep(250);
    srReadScreen();
    addWoodPos = findText("Add some Wood");
    if(addWoodPos) then
        safeClick(addWoodPos[0] + 10, addWoodPos[1] + 5);
        lsSleep(250);
        srReadScreen();
        clickMax();
    else
        fatalError("Unable to find the Add some Wood menu item.");
    end
    setStatus("Wood stashed");
end

function plantPapy()
    if(not papy) then
        return false;
    end
    srReadScreen();
    local pos = findText("Papyrus");
    if(pos) then
        safeClick(pos[0]+20, pos[1]+5);
        sleepWithBreak(500);
        return true;
    else
        fatalError("Unable to find the Papyrus option.");
    end
    return false;
end

function stashAllButWood()
    local needMax;
    local count = 0;
    local stashedSomething = true;
    while(stashedSomething) do
        stashedSomething = false;
        needMax = true;
        lsSleep(150);
        srReadScreen();
        local pos = findText("Stash...");
        if(pos) then
            safeClick(pos[0] + 10, pos[1] + 5);
            lsSleep(250);
            srReadScreen();
            local pos = findText("Clay (");
            if(pos) then
                stashItem(pos,true);
                stashedSomething = true;
            else
                pos = findText("Flint (");
                if(pos) then
                    stashItem(pos,true);
                    stashedSomething = true;
                else
                    pos = findText("Slate (");
                    if(pos) then
                        stashItem(pos,true);
                        stashedSomething = true;
                    else
                        pos = findText("Grass (");
                        if(pos) then
                            stashItem(pos,true);
                            stashedSomething = true;
                        else
                            pos = findText("Tadpoles");
                            if(pos) then
                                stashItem(pos,true);
                                stashedSomething = true;
                            else
                                pos = findText("Wood (");
                                if(pos) then
                                        stashItem(pos,true);
                                        stashedSomething = true;
                                else
                                    pos = findText("Insect...");
                                    if(pos) then
                                        safeClick(pos[0] + 10, pos[1] + 5);
                                        lsSleep(150);
                                        srReadScreen();
                                        pos = findText("All Insect");
                                        if(pos) then
                                            stashItem(pos,false);
                                            stashedSomething = true;

                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if(stashedSomething) then
                clickWaypoint(Warehouse);
            else
                safeClick(10,200);
            end
        else
            if(count < 1) then
                fatalError("Unable to find the Stash menu item.");
            end
        end
        count = count + 1;
    end
end

function stashItem(pos,clickMaxButton)
    safeClick(pos[0] + 20, pos[1] + 5);
    if(clickMaxButton) then
        lsSleep(150);
        srReadScreen();
        clickMax();
    end
    lsSleep(150);
    srReadScreen();
end

local prepareForWalkingInitialized = false;

function prepareForWalking()
    if(prepareForWalkingInitialized) then
        return;
    end
    prepareForWalkingInitialized = true;
    askForWindow("Make sure your chats are minimized then hover ATITD window and press Shift to continue.");
    lsSleep(150);
    local xyWindowSize = srGetWindowSize();
    local mid = {};
    mid[0] = xyWindowSize[0] / 2;
    mid[1] = xyWindowSize[1] / 2;
    --srSetMousePos(mid[0],mid[1]);
    lsSleep(150);
    setCameraView(CARTOGRAPHER2CAM);
end

function zoomIn()
    srReadScreen();
    local pos = findText("Year");
    if(not pos) then
        pos = findText("2, ");
    end
    if(not pos) then
        pos = findText("3, ");
    end
    if(not pos) then
        error("Unable to find the clock.");
    end
    srClickMouse(pos[0]+10, pos[1]+10);
    srSetMousePos(100,-20);
    sleepWithStatus(1000,"Zooming in");
end

local statusMessage = "";

function setStatus(message)
    if not message then
        message = "";
    end
    statusMessage = message;
    updateStatus();
end

function updateStatus()
    local color = 0xFFFFFFff;
    local allow_break = true;
    lsPrintWrapped(10, 80, 0, lsScreenX - 20, 0.8, 0.8, color, statusMessage);
    lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, 0.8, 0.8, 0xffd0d0ff,error_status);
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,0xFFFFFFff, "End script") then
        error(quit_message);
    end
    if allow_break then
        lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,"Hold Ctrl+Shift to end this script.");
        if allow_pause then
            lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,"Hold Alt+Shift to pause this script.");
        end
        checkBreak();
    end

    if(walkingRoute) then
        local duration = math.floor((lsGetTimer() - routeStartTime) / 1000);
        local hours = math.floor(duration / 60 / 60);
        local minutes = math.floor((duration - hours * 60 * 60) / 60);
        local seconds = duration - hours * 60 * 60 - minutes * 60;
--        lsPrint(10, 38, 0, 0.7, 0.7, 0xB0B0B0ff,"Elapsed: " .. hours .. ":" .. minutes .. ":" .. seconds);
        lsPrint(10, 38, 0, 0.7, 0.7, 0xB0B0B0ff,string.format("Elapsed: %02d:%02d:%02d",hours,minutes,seconds));
    end

    lsSleep(tick_delay);
    lsDoFrame();
end

function checkForMenu()
  srReadScreen();
  pos = srFindImage("unpinnedPin.png",5000);
  if pos then
    safeClick(pos[0],pos[1]-14);
    lsPrintln("checkForMenu(): Found a menu...returning true");
    return true;
  end
  return false;
end

function getCoords()
    prepareForWalking();
    srReadScreen();
    local pos = findCoords();
    return pos;
end

function findWaypointOrder(wpType)
    local i;
    for i = 1, #WaypointTypes do
        if(WaypointOrder[i] == wpType) then
            return i;
        end
    end
    return nil;
end

function refreshMenus()
    local old_click_delay = click_delay;
    click_delay = 20;
    srReadScreen();
    clickAllImages("UnPin.png", -20, 3);
    lsSleep(tick_delay);
    srReadScreen();
    click_delay = old_click_delay;
end

function doMenuClick(text)
    local old_click_delay = click_delay;
    click_delay = 75;
    srReadScreen();
    clickAllText(text, 20, 3);
    lsSleep(tick_delay);
    srReadScreen();
    click_delay = old_click_delay;
end

function insertMenuTextAfter(where,thisRoute)
    local temp = {};
    local i;
    for i = 1, ((#thisRoute[2]) + 1) do
        temp[i] = {};
        if(i <= where) then
            temp[i] = thisRoute[2][i];
        elseif(i == where + 1) then
            temp[i] = "";
        else
            temp[i] = thisRoute[2][i-1];
        end
    end
    thisRoute[2] = {};
    for i = 1, #temp do
        thisRoute[2][i] = temp[i];
    end
    return thisRoute;
end

function deleteMenuText(where,thisRoute)
    if(#thisRoute[2] == 1) then
        thisRoute[2][1] = "";
        return thisRoute;
    end

    local temp = {};
    local i;
    for i = 1, #thisRoute[2] do
        if(i < where) then
            temp[i] = thisRoute[2][i];
        elseif(i > where) then
            temp[i-1] = thisRoute[2][i];
        end
    end
    thisRoute[2] = {};
    for i = 1, #temp do
        thisRoute[2][i] = temp[i];
    end
    return thisRoute;
end