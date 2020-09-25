dofile("common.inc");
dofile("settings.inc");

local mushroomData = {
  {
    name = "Acorn's Cap",
    start = "5:00AM",
    stop = "6:31AM",
    shroomdarId = "AC",
    notes = "Habitat: Along Shores.\n\nSpawner: Groups of 5, decently spaced groups as you run along rivers - Always spawns.",
  },
  {
    name = "Badger Badger",
    start = "2:00PM",
    stop = "4:36PM",
    shroomdarId = "BA",
    notes = "Habitat: Any terrain type and higher elevations.\n\nSpawner: Spawns in large areas, cycling out of the area slowly.",
  },
  {
    name = "Barley Bowl",
    start = "2:00PM",
    stop = "4:36PM",
    shroomdarId = "BB",
    notes = "Habitat: On expanses of flat land, grass or desert.\n\nSpawner: Groups of 2-5, always spawns in same general area in large amounts, migrates very slowly. Usually groups are within sight of each other from one to the next.",
  },
  {
    name = "Beehive",
    start = "8:00PM",
    stop = "10:36PM",
    shroomdarId = "BE",
    notes = "Habitat: In grass and sand irregular to flattish land near -90 360 in medium size area.\n\nSpawner: from a few to 300+",
  },
  {
    name = "Bleeding Hand",
    start = "9:00AM",
    stop = "10:31AM",
    shroomdarId = "BH",
    notes = "Habitat: At base of mountains, on mountains\n\nSpawner: Groups of 5 - Always spawns. Easy spot with lots of them, Lahun, 89, 4821 on the pstchy rocky areas.",
  },
  {
    name = "Brain",
    start = "5:00PM",
    stop = "7:36PM",
    shroomdarId = "BR",
    notes = "Habitat: Spawns in same areas as Cat Nip does but not if Cat Nip is spawning in that place. Especially likes rocky on rough, terraced, sloped sides.\n\nSpawner: Can be a few to upwards of 60+. A cycle spawner, spawns for a few shroom times then disappears for 1–3 weeks.",
  },
  {
    name = "Camels Mane",
    start = "1:00AM",
    stop = "2:31AM",
    shroomdarId = "CM",
    notes = "Habitat: Hilly spots, elevated spots always spawn same areas, usually grass but sometimes sand\n\nSpawner: Groups of 5, from 1 to more groups on a hill",
  },
  {
    name = "Campanella",
    start = "4:00PM",
    stop = "6:36PM",
    shroomdarId = "CP",
    notes = "Habitat: Usually flat (can be on a bit of hill) areas sand or grass\n\nSpawner: Groups of 5, around center of large spawn area is much more concentrated and has sparser amount of groups out from center. Horizon view for flat sand. Always spawns each spawn time.",
  },
  {
    name = "Carrion",
    start = "12:00PM",
    stop = "1:31PM",
    shroomdarId = "CA",
    notes = "Habitat: On rocky outcrops and brown/sand mottled areas.\n\nSpawner: Usually spawns in small groups to very large expanses.\n\nEcology: Leek, Onion, Watermelon known to produce extra seed nearby.",
  },
  {
    name = "Cat Nip",
    start = "5:00PM",
    stop = "7:36PM",
    shroomdarId = "CN",
    notes = "Habitat: Same places as brains. On rock up high, or low hilly, bumpy or rough spots on sides of rock hills too. Tiny and easy to miss.\n\nSpawner: Cycles a few shroom times spawning, then disappears then after a 2–3 weeks spawns again. Can be a few to up to 50+",
  },
  {
    name = "Cobra Hood",
    start = "9:00AM",
    stop = "10:31AM",
    shroomdarId = "CH",
    notes = "Habitat: Especially at base of mountains and up the mountain, grass or sand or rock\n\nSpawner: Groups of 5, always spawns in same spots usually numerous numbers along mountain ranges",
  },
  {
    name = "Colt's Foot",
    start = "10:00AM",
    stop = "11:31AM",
    shroomdarId = "CF",
    notes = "Habitat: In rolling green hills or a larger hill or plateau.\n\nSpawner: Groups of 5, a cycler of small spawn then medium spawn then maybe larger spawn up to 100+ then smaller spawn. Spawns migrate. Comes back at a random time after maybe 1–2 weeks or so.",
  },
  {
    name = "Crows Beak",
    start = "6:00AM",
    stop = "8:36AM",
    shroomdarId = "CB",
    notes = "Habitat: Spawns amongst Fruit of Horus in grassy areas.\n\nSpawner: From 2 to 100+ in with Fruit of Horus, sometimes none.",
  },
  {
    name = "Dead Tongue",
    start = "5:00AM",
    stop = "6:31AM",
    shroomdarId = "DT",
    notes = "Habitat: On shores, sand or grass\n\nSpawner: Groups of 5, always spawns in same general areas usually many groups as you run along shores.\n\nEcology: ph = 7.0600 and nitrogen = 102 exactly",
  },
  {
    name = "Dueling Serpents",
    start = "7:00AM",
    stop = "8:31AM",
    shroomdarId = "DS",
    notes = "Habitat: On large, flat expanses of sand, usually spaced much farther apart than within viewing range of each other.\n\nSpawner: In pairs, looks like two flea dots if zoomed out.",
  },
  {
    name = "Dung Rot",
    start = "3:00PM",
    stop = "4:46PM",
    shroomdarId = "DR",
    notes = "Habitat: Sand or grass, can be along sandy area by shore or near camps after chicken coops start. Look for camps with large number of chicken coops near sand.\n\nSpawner: Can be a single to a huge number 300+. Once chicken coops come out, they go in longer cycles of lots for days and peter out to nothing sometimes. Occasionally Pool of Tranquility shrooms will be at same location.",
  },
  {
    name = "Earth Light",
    start = "11:00AM",
    stop = "12:31PM",
    shroomdarId = "EL",
    notes = "Habitat: Can spawn on all terrain, but seems to do so more on rock terrain.\n\nSpawner: Can be a small patch to a very large amount like 100+. Spawns among Carrion shrooms in small amounts so check those shrooms too and remember both are green. So look for a different profile. Cycler that spawns several times in a spot, migrates and disappears.",
  },
  {
    name = "Eye of Osiris",
    start = "11:00PM",
    stop = "12:31AM",
    shroomdarId = "EO",
    notes = "Habitat: Larger flat grass areas. Look in expanses where shroomdar points to.\n\nSpawner: Groups of 1, always there but greatly spread out singles. Sometimes has huge spawns for a very long time in one area but at some point huge spawns disappear. Probably due to some eco change. Pinkish dot if zoomed out.",
  },
  {
    name = "Falcon's Bait",
    start = "11:00PM",
    stop = "12:31AM",
    shroomdarId = "FB",
    notes = "Habitat: On flat grass and up on small hilly areas. Pan side to side while searching to catch glimpses.\n\nSpawner: Groups of 3 - Always spawns - lots of groups spaced decently near each other.\n\nEcology: Eggplant reproduction nearby.",
  },
  {
    name = "Fish Hook",
    start = "1:00PM",
    stop = "2:31PM",
    shroomdarId = "FH",
    notes = "Habitat: Large flat grass areas usually in Kush\n\nSpawner: In pairs - Always spawns",
  },
  {
    name = "Flat",
    start = "7:00PM",
    stop = "9:36PM",
    shroomdarId = "FL",
    notes = "Habitat: Seems to be near mines on grassy areas.\n\nSpawner: Groups of ?, can be a few to huge numbers of 1000+ in very large area.",
  },
  {
    name = "Fruit of Horus",
    start = "6:00AM",
    stop = "9:21AM",
    shroomdarId = "FR",
    notes = "Habitat: On very large expanses mostly grassy areas but leaks onto rock and sand too. Crow's Beak can be amongst them in amounts of 2 to 100+.\n\nSpawner: Massive amounts that very very slowly migrate. Stays in same areas for a long time but can finally disappear from the area.",
  },
  {
    name = "Golden Sun",
    start = "9:00PM",
    stop = "10:36PM",
    shroomdarId = "GS",
    notes = "Habitat: At rocky 90 degree edges.\n\nSpawner: Groups of 3, almost always spawns at -2358, 2654 area. Look all around high steep cliffy, terraced parts. Can be up to 6 groups. Sometimes not accessible to pick. Small flea dots if zoomed out.",
  },
  {
    name = "Hairy Tooth",
    start = "1:00PM",
    stop = "2:31PM",
    shroomdarId = "HT",
    notes = "Habitat: Usually grass but sometimes leaks onto sand\n\nSpawner: Pairs, always spawns in general large areas, very very slowly migrates. Sometimes along hard desert/grassy lines.",
  },
  {
    name = "Heart of Ash",
    start = "3:00AM",
    stop = "4:31AM",
    shroomdarId = "HA",
    notes = "Habitat: Spawns in same large green flat areas as Peasant Foot does.\n\nSpawner: Groups of 7. Almost always spawns in the same areas but scattered and random spots.",
  },
  {
    name = "Heaven's Torrent",
    start = "8:00PM",
    stop = "9:36PM",
    shroomdarId = "HE",
    notes = "Habitat: Same spots as Salt Water Fungus, on peninsulas and small islands that are in the seas and sometimes in ponds at low elevation\n\nSpawner: Spawns from a few to up to 50+. A cycler. Spawns for several shroom times in a row then disappears for 2–3 weeks.",
  },
  {
    name = "Iron Knot",
    start = "9:00AM",
    stop = "10:31AM",
    shroomdarId = "IK",
    notes = "Habitat: On the side and base of mountains and mountain ranges on about any terrain.\n\nSpawner: Always spawns in its area in fairly large amounts.",
  },
  {
    name = "Limphonus",
    start = "4:00PM",
    stop = "6:01PM",
    shroomdarId = "LI",
    notes = "Habitat: Grass or Sand.\n\nSpawner: Groups of 3. Erratic spawner.\n\nEcology: Something used in camp seems to help them spawn. Glass machines?",
  },
  {
    name = "Marasmius",
    start = "10:00PM",
    stop = "12:36AM",
    shroomdarId = "MA",
    notes = "Habitat: Seems to be in green rolling hills, higher elevations. Sometimes with Fruit of Horus.\n\nSpawner: Erratic spawner.",
  },
  {
    name = "Morel",
    start = "2:00AM",
    stop = "4:36AM",
    shroomdarId = "MO",
    notes = "Habitat: On rocky/grass smaller hilly areas or terraced areas. Pan side to side to catch twinkles and stay zoomed in more. Hard to see small peanut on a stick..\n\nSpawner: Groups of 3, always spawns in same general areas.",
  },
  {
    name = "Moses Basket",
    start = "2:00AM",
    stop = "4:36AM",
    shroomdarId = "MB",
    notes = "Habitat: In large flat deserts where there is nothing else. At Western Desert -2000, -5500 since beginning of Tale 8.\n\nSpawner: Groups of 5, always spawns, lots of groups within sight of each other and then farther away in very large areas.",
  },
  {
    name = "Nature's Jug",
    start = "4:00AM",
    stop = "5:36AM",
    shroomdarId = "NJ",
    notes = "Habitat: Two spawns anywhere in Egypt usually on flatter, lower spot usually on grass.\n\nSpawner: Spawns in a cycle at same spot in an ascending order of powers of 2 as a small to huge circular area of a few then medium amount then large amount up to 300+ then disappears in that spot. Can be a little hard to see on grass since they are dark round shrooms.",
  },
  {
    name = "Nefertari's Crown",
    start = "10:00AM",
    stop = "11:46AM",
    shroomdarId = "NC",
    notes = "Habitat: Among hilly grassy areas\n\nSpawner: Cycler of several to many for maybe 3-6 shroom times then takes 2–3 weeks to return.",
  },
  {
    name = "Nile Fire",
    start = "12:00PM",
    stop = "1:31PM",
    shroomdarId = "NF",
    notes = "Habitat: Large spawns around watery areas.\n\nSpawner: Many groups of 3? - Always spawns.\n\nEcology: High Potassium.",
  },
  {
    name = "Orange Campanella",
    start = "11:00PM",
    stop = "12:31AM",
    shroomdarId = "OC",
    notes = "Habitat: On small hills to taller mountain ranges, grass, stone or sand.\n\nSpawner: Groups of 5, a cycler that spawns for a while in an area of small hills or along a mountain range then disappears for a while to come back later.",
  },
  {
    name = "Peasant Foot",
    start = "3:00AM",
    stop = "4:31AM",
    shroomdarId = "PF",
    notes = "Habitat: Large flat grass areas and around edges of grass areas\n\nSpawner: Groups of 7, occasionally groups of 4 - spawns in above area usually each spawn but not always every shroom time, groups spaced far apart",
  },
  {
    name = "Pool of Tranquility",
    start = "3:00PM",
    stop = "5:01PM",
    shroomdarId = "PT",
    notes = "Habitat: In sand usually near chicken coops. Spawns less often in same areas near chicken coops as Dung Rot so probably has a narrower range of ecology than Dung Rot.\n\nSpawner: Very few spawn naturally. When chicken coops come out then you get larger spawns from a few to 100+.",
  },
  {
    name = "Ptah's Pimple",
    start = "7:00AM",
    stop = "9:36AM",
    shroomdarId = "PP",
    notes = "Habitat: On Sand. Numerous west of Kahun cs in large flat area.\n\nSpawner: Usually spawns in same general sandy areas in pairs. Pairs within viewing area of each other, sometimes farther apart.",
  },
  {
    name = "Ra's Awakening",
    start = "6:00PM",
    stop = "7:31PM",
    shroomdarId = "RA",
    notes = "Habitat: Can be in rough sandy large areas and into green valleys near the sandy areas.\n\nSpawner: Spawns in pairs. Always in their spawning area but very very slowly migrates.",
  },
  {
    name = "Razor's Edge",
    start = "9:00PM",
    stop = "10:36PM",
    shroomdarId = "RE",
    notes = "Habitat: Next to shorter or taller 90 degree strip edges of rock.\n\nSpawner: Groups of ?, a cycler of small spawn then medium spawn then maybe huge spawn up to 300+ then smaller spawn. Comes back at a random time after maybe 1–2 weeks or so.",
  },
  {
    name = "Salt Water Fungus",
    start = "10:00PM",
    stop = "12:36AM",
    shroomdarId = "SW",
    notes = "Habitat: Spawns in same peninsula and island areas as Heaven's Torrent.\n\nSpawner: Spawns a few to 40+ in a cycle of a few consecutive shroom times then disappears for 1–3 weeks.",
  },
  {
    name = "Sand Spore",
    start = "8:00AM",
    stop = "9:31AM",
    shroomdarId = "SS",
    notes = "Habitat: In large sandy areas and sometimes small sandy spots. Hard to see so do not zoom out too far. Pairs are usually far from each other.\n\nSpawner: Spawns in pairs. Always in certain sandy areas so eat dex food like Rumi cheese and run all over the area that shroomdar shows the most sightings.",
  },
  {
    name = "Schizophyllum",
    start = "7:00PM",
    stop = "9:36PM",
    shroomdarId = "SC",
    notes = "Habitat: Near Persephones, Blast and Compression furnaces.\n\nSpawner: Spawns when ecology is changed enough by use of certain furnaces.",
  },
  {
    name = "Scorpion's Brood",
    start = "11:00AM",
    stop = "12:31PM",
    shroomdarId = "SB",
    notes = "Habitat: On sandy rolling hills, stony outcrops and large mountains.\n\nSpawner: Groups of 5. Cycles in waves that move and then disappear after 3-7 spawn times.\n\nEcology: pH 5.984, Phos 89, Potassium 96, Nitrogen 100, Groundwater 100",
  },
  {
    name = "Slave's Bread",
    start = "6:00PM",
    stop = "7:31PM",
    shroomdarId = "SL",
    notes = "Habitat: In rolling sandy to cliffy hills.\n\nSpawner: In pairs, always there, spaced sometimes within viewing range of each other sometimes near but not in viewing range of another pair. Spawns in large area. Can usually pick up to 60-80 during spawn time in one area.",
  },
  {
    name = "Spiderling",
    start = "10:00PM",
    stop = "12:36AM",
    shroomdarId = "SP",
    notes = "Habitat: On hilly, elevated grass or large and small rocky stony elevated outcrops. Looks like dark flea dots if zoomed out. Stay zoomed in more.\n\nSpawner: A cycler of small to medium spawns that migrate and disappear in a few days.",
  },
  {
    name = "Sun Star",
    start = "8:00AM",
    stop = "9:31AM",
    shroomdarId = "SU",
    notes = "Habitat: Out in large expanses of flat desert. I use Horizon View shown above because they are difficult to see zoomed out. Sweep your view back and forth to catch them to the sides of you.\n\nSpawner: Spawns in pairs pretty far apart. Always in same area. North of the Sheba chariot stop is one spot.",
  },
  {
    name = "Toad Skin",
    start = "1:00AM",
    stop = "2:31AM",
    shroomdarId = "TS",
    notes = "Habitat: On small hills, mountains on sand, grass, rocky areas.\n\nEcology: Groups of 5 - Always spawns - 1 or more groups on each small hill.",
  },
  {
    name = "Twirls",
    start = "8:00PM",
    stop = "10:36PM",
    shroomdarId = "TW",
    notes = "Habitat: Near water on sandy areas\n\nSpawner: Groups of ?? - spawns off and on - become more frequent when chicken pens are up - can be 1 to hundreds",
  },
};

local seasons = {"Akhet", "Peret", "Shemu"};
local months = {"I", "II", "III", "IV"};
local days = {
  "01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
  "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
  "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
};
local hours = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"};
local minutes = {
  "00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
  "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
  "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
  "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
  "40", "41", "42", "43", "44", "45", "46", "47", "48", "49",
  "50", "51", "52", "53", "54", "55", "56", "57", "58", "59",
};
local ampms = {"AM", "PM"};

local name = "";

local http;

function doit()
  askForWindow([[
  Shroom Stalker v1.1
  by Kavad.

  This macro will help you hunt mushrooms!

  This macro requires network access to load
  data from Shroomdar, and to submit reports
  there.

  Shout out to Cegaiel for supporting the
  integration with Shroomdar!
  ]]);

  getName();

  for _, mushroom in pairs(mushroomData) do
    mushroom.startMinutes = timeToMinutes(mushroom.start);
    mushroom.stopMinutes  = timeToMinutes(mushroom.stop);
    mushroom.alert        = true;
    mushroom.show         = true;
    mushroom.reports      = {};
  end

  loadSettings();

  http = require("ssl.https");
  loadReports();

  local contextDetails = true;
  while true do
    local mushroomWindow = findText("Pick up the [%w ']+ Mushrooms", nil, REGEX);
    if contextDetails and mushroomWindow then
      local mushroomName = string.match(mushroomWindow[2], "Pick up the ([%w ']+) Mushrooms");
      for _, mushroom in pairs(mushroomData) do
        if mushroomName == mushroom.name then
          displayMushroomDetails(mushroom, true);
          contextDetails = false;
        end
      end
    elseif not mushroomWindow then
      contextDetails = true;
    end

    local status = tick();
    if status then
      sortMushroomsByDelta();

      local y = 5;
      for _, mushroom in pairs(mushroomData) do
        if mushroom.show then
          displayMushroomLine(y, mushroom);

          y = y + 30;
          if y > lsScreenY - 60 then
            break;
          end
        end
      end

      if lsButtonText(5, lsScreenY - 30, 5, 100, 0xffffffff, "Settings") then
        displaySettings();
      end

      if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xffffffff, "Exit") then
        break;
      end
    else
      lsPrint(5, 5, 5, 0.7, 0.7, 0xffffffff, "Time not visible.");
      if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xffffffff, "Back") then
        break;
      end
    end

    lsDoFrame();
    checkBreak();
    lsSleep(10);
  end
end

function writeSettings()
  for _, mushroom in pairs(mushroomData) do
    writeSetting(mushroom.shroomdarId, {
      alert = mushroom.alert,
      show = mushroom.show,
    });
  end
end

function loadSettings()
  for _, mushroom in pairs(mushroomData) do
      local data = readSetting(mushroom.shroomdarId);
      if data then
        mushroom.alert = data.alert;
        mushroom.show  = data.show;
      end
    end
end

function openCharacterMenu()
  srReadScreen();

  local skills = findText("Skills...");
  if not skills then
    local startX, startY = srMousePos();
    local window = srGetWindowSize();
    srSetMousePos(window[0] / 2, window[1] / 2);
    lsSleep(100);
    srKeyEvent("\27"); --Esc
    lsSleep(100);
    srSetMousePos(startX, startY);
  end
end

function getName()
  openCharacterMenu();

  local skills = waitForText("Skills...", 1000, nil, nil, REGION);
  if skills then
    local parse = findText("%w+", skills, REGEX);

    --Names are usually "Name, title" except for "Citizen Name";
    local commaSplit = explode(",", parse[2]);
    local spaceSplit = explode(" ", commaSplit[1]);
    name = spaceSplit[#spaceSplit];
  end

  srKeyEvent("\27"); --Esc
end

function loadReports()
  lsDoFrame();
  statusScreen("Fetching data from Shroomdar...");

  local body, status, auth = http.request("https://automato.sharpnetwork.net/mushroom.asp");
  if status ~= 200 then
    sleepWithStatus(2000, "Error Fetching Data.\nStatus: " .. status .. "\nBody: " .. body .. "\nAuth: " .. table.concat(auth, ", "));
  end

  local mushroomsById = {};
  for _, mushroom in pairs(mushroomData) do
    mushroom.reports = {};
    mushroomsById[mushroom.shroomdarId] = mushroom;
  end

  local lines = explode("\n", body);
  for _, line in pairs(lines) do
    checkBreak();

    local data = explode("|", line);
    if #data == 5 then
      mushroom = mushroomsById[data[1]];
      table.insert(mushroom.reports, {
        datetime = data[2],
        coords = data[3],
        region = data[4],
        name = data[5]
      });
    end
  end
end

function tick()
  srReadScreen();

  local time = getTime("time");
  if not time then
    return false;
  end

  local minutes = timeToMinutes(time);

  for _, mushroom in pairs(mushroomData) do
    local delta = getActiveDelta(minutes, mushroom);
    if mushroom.activeDelta ~= nil and mushroom.alert then
      if mushroom.activeDelta > 0 and delta <= 0 then
        lsPlaySound("trolley.wav");
        sleepWithStatus(2000, mushroom.name .. " is spawning now!");
      elseif mushroom.activeDelta <= 0 and delta > 0 then
        lsPlaySound("beepping.wav");
        sleepWithStatus(2000, mushroom.name .. " has de-spawned!");
      end
    end

    mushroom.activeDelta = delta;
    checkBreak();
  end
  return true;
end

function getDuration(minutes)
  local hours = math.floor(minutes / 60);
  local minutes = minutes % 60;

  local duration = "";
  if hours > 0 then
    duration = hours .. "h";
  end

  if hours > 0 then
    duration = duration .. ", ";
  end

  return duration .. minutes .. "m";
end

function displaySettings()
  sortMushroomsByName();
  while true do
    if lsButtonText(10, 5, 5, 135, 0x00ff00ff, "All Alerts On") then
      setAll('alert', true);
      writeSettings();
    end

    if lsButtonText(155, 5, 5, 135, 0xff0000ff, "All Alerts Off") then
      setAll('alert', false);
      writeSettings();
    end

    if lsButtonText(10, 35, 5, 135, 0x00ff00ff, "Show All") then
      setAll('show', true);
      writeSettings();
    end

    if lsButtonText(155, 35, 5, 135, 0xff0000ff, "Hide All") then
      setAll('show', false);
      writeSettings();
    end

    if lsButtonText(10, 65, 5, 280, 0xffffffff, "Refresh Shroomdar Data") then
      loadReports();
    end

    lsScrollAreaBegin("setting_mushrooms", 5, 100, 0, 280, 200);

    local y = 5;
    for _, mushroom in pairs(mushroomData) do
      if lsButtonText(5, y, 5, 250, 0xffffffff, mushroom.name) then
        lsScrollAreaEnd(y);

        displayMushroomDetails(mushroom);

        lsScrollAreaBegin("setting_mushrooms", 5, 100, 0, 280, 200);
      end
      y = y + 30;
    end

    lsScrollAreaEnd(y);

    if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xffffffff, "Back") then
      break;
    end

    lsDoFrame();
    checkBreak();
    lsSleep(10);
  end
end

function copyShroomdarLink(mushroom)
  lsClipboardSet("https://atitd.sharpnetwork.net/mushrooms/report.asp?shroom=" .. mushroom.shroomdarId);

  promptOkay("A link to the shroomdar page for " .. mushroom.name .. " has been copied to your clipboard. Paste it into your browser.");
end

function reportEcology(mushroom)
  if not promptOkay([[
  This will automatically use an
  'Ecology Survey Kit' and submit the
  results for research.

  If you need kits, visit Somebob's shop:
  917, -4040 near Valley of Queens.

  They cost 1 glass jar, which is returned
  upon usage, making them basically free.
  ]], 0xffffffff, 0.7, nil, nil, 50) then
    return;
  end

  openCharacterMenu();

  local skills = waitForText("Skills...", 5000, "Waiting for Skills...");
  if not skills then
    return;
  end
  clickText(skills);

  local ecology = waitForText("Ecology...", 5000, "Waiting for Ecology...");
  if not ecology then
    return;
  end
  clickText(ecology);

  local survey = waitForText("Survey...", 5000, "Waiting for Survey...");
  if not survey then
    return;
  end
  clickText(survey);

  local study = waitForText("Detailed Study", 5000, "Waiting for Detailed Study");
  if not study then
    return;
  end
  clickText(study);

  local clipboard = waitForImage("clipboard.png", 5000, "Waiting for Clipboard button");
  if not clipboard then
    return;
  end

  -- Clear the clipboard, so that if the copy below fails it's blank
  lsClipboardSet("");

  clickText(clipboard);

  clickText(waitForImage("ok.png", 5000, "Waiting for OK button"));

  local results = lsClipboardGet();
  if string.sub(results, 1, 12) ~= "Heavy Metals" then
    return;
  end

  local body, status, auth = http.request("https://docs.google.com/forms/u/0/d/e/1FAIpQLSczkTr15S3xhLN5JGZMirSjxVigZh9PXkLxU34g9mi4UGxLfQ/formResponse", table.concat({
    "entry.6633223=" .. mushroom.name,
    "entry.1567807693=" .. results,
  }, "&"));
  if status ~= 200 then
    sleepWithStatus(2000, "Error submitting report.\nStatus: " .. status);
  else
    sleepWithStatus(1000, "Report Submitted");
  end
end

function reportToShroomdar(mushroom)
  -- reportIndex is used to refresh the edit inputs each time we display the form
  reportIndex = math.random();

  lsDoFrame();
  lsDoFrame();

  local yearString, seasonString, monthString, dayString, hourString, minuteString, ampmString = string.match(
     getTime("datetime3"),
    "(%d+)_(%w+)_(%w+)-(%d+)_(%d+)_(%d+)(%w+)"
  );

  local years     = {};
  local yearIndex = tonumber(yearString);
  for i = 1, yearIndex do
    table.insert(years, "Year " .. i);
  end

  local reportName = name;

  local seasonIndex = getIndex(seasons, seasonString);
  local monthIndex = getIndex(months, monthString);
  local dayIndex = getIndex(days, dayString);
  local hourIndex = getIndex(hours, hourString);
  local minuteIndex = getIndex(minutes, minuteString);
  local ampmIndex = getIndex(ampms, ampmString);

  local coords = findCoords();
  local coordsX = coords[0];
  local coordsY = coords[1];
  local count  = "1";

  while true do
    lsPrint(5, 5, 5, 0.7, 0.7, 0xffffffff, "Mushroom: " .. mushroom.name);

    lsPrint(5, 30, 5, 0.7, 0.7, 0xffffffff, "Name:");
    local _, reportName = lsEditBox("reportName" .. reportIndex, 75, 25, 5, 200, 30, 0.7, 0.7, 0x000000ff, name);

    lsPrint(5, 60, 5, 0.7, 0.7, 0xffffffff, "Date:");
    yearIndex  = lsDropdown("reportYear" .. reportIndex, 75, 55, 5, 100, yearIndex, years);
    seasonIndex  = lsDropdown("reportSeason" .. reportIndex, 180, 55, 5, 100, seasonIndex, seasons);
    monthIndex = lsDropdown("reportMonth" .. reportIndex, 75, 85, 5, 50, monthIndex, months);
    dayIndex   = lsDropdown("reportDay" .. reportIndex, 130, 85, 5, 50, dayIndex, days);

    lsPrint(5, 120, 5, 0.7, 0.7, 0xffffffff, "Time:");
    hourIndex   = lsDropdown("reportHour" .. reportIndex, 75, 115, 5, 50, hourIndex, hours);
    minuteIndex = lsDropdown("reportMinute" .. reportIndex, 130, 115, 5, 50, minuteIndex, minutes);
    ampmIndex   = lsDropdown("reportAmpm" .. reportIndex, 185, 115, 5, 50, ampmIndex, ampms);

    lsPrint(5, 150, 5, 0.7, 0.7, 0xffffffff, "Coords:");
    local _, coordsX = lsEditBox("reportCoordsX" .. reportIndex, 75, 145, 5, 60, 30, 0.7, 0.7, 0x000000ff, coordsX);
    lsPrint(136, 150, 5, 1.0, 1.0, 0xffffffff, ",");
    local _, coordsY = lsEditBox("reportCoordsY" .. reportIndex, 140, 145, 5, 60, 30, 0.7, 0.7, 0x000000ff, coordsY);

    lsPrint(5, 180, 5, 0.7, 0.7, 0xffffffff, "Count:");
    local _, count = lsEditBox("reportCount" .. reportIndex, 75, 175, 5, 60, 30, 0.7, 0.7, 0x000000ff, count);

    local error = false;
    if string.len(reportName) < 1 then
      lsPrint(5, 210, 5, 0.7, 0.7, 0xff0000ff, "Please enter a name.");
      error = true;
    end

    coordsX = tonumber(coordsX);
    coordsY = tonumber(coordsY);
    if not coordsX or coordsX < -3100 or coordsX > 5200 then
      lsPrint(5, 240, 5, 0.7, 0.7, 0xff0000ff, "Coordinates out of bounds.");
      error = true;
    elseif not coordsY or coordsY < -8200 or coordsY > 8200 then
      lsPrint(5, 240, 5, 0.7, 0.7, 0xff0000ff, "Coordinates out of bounds.");
      error = true;
    end

    count = tonumber(count);
    if not count or count < 1 or count > 999 then
      lsPrint(5, 260, 5, 0.7, 0.7, 0xff0000ff, "Count must be between 1 and 999.");
      error = true;
    end

    if not error and lsButtonText(5, lsScreenY - 30, 5, 80, 0x00ff00ff, "Report") then
      local body, status, auth = http.request("https://atitd.sharpnetwork.net/mushrooms/submit_report.asp", table.concat({
        "mushroom=" .. mushroom.shroomdarId,
        "Year=" .. years[yearIndex],
        "Season=" .. seasons[seasonIndex],
        "Month=" .. months[monthIndex],
        "Day=" .. days[dayIndex],
        "hour=" .. hours[hourIndex],
        "minute=" .. minutes[minuteIndex],
        "ampm=" .. ampms[ampmIndex],
        "x=" .. coordsX,
        "y=" .. coordsY,
        "amount=" .. count,
        "name=" .. name,
      }, "&"));
      if status ~= 200 then
        sleepWithStatus(2000, "Error submitting report.\nStatus: " .. status);
      else
        sleepWithStatus(1000, "Report Submitted");
      end
      break;
    end

    if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xffffffff, "Back") then
      break;
    end

    lsDoFrame();
    checkBreak();
  end
end

function getIndex(haystack, needle)
  for index, value in pairs(haystack) do
    if value == needle then
      return index;
    end
  end

  return nil;
end

function displayMushroomDetails(mushroom, context)
  local tab = "notes";
  while true do
    if context and not findText("Pick up the " .. mushroom.name .. " Mushrooms") then
      return true;
    end

    tick();

    if lsButtonImg(5, 5, 5, 1.0, 0xffffffff, "mushrooms/" .. mushroom.shroomdarId .. ".png") then
      copyShroomdarLink(mushroom);
    end

    lsPrint(110, 5, 5, 1.0, 1.0, 0xffffffff, mushroom.name);
    lsPrint(110, 30, 5, 0.7, 0.7, 0xffffffff, mushroom.start .. " - " .. mushroom.stop);

    if mushroom.activeDelta > 0 then
      local realMinutes = math.floor(mushroom.activeDelta / 3 * 1.15);
      lsPrint(110, 50, 5, 0.7, 0.7, 0xffff00ff, "Spawns in ~ " .. getDuration(realMinutes));
    else
      local realMinutes = math.floor(-mushroom.activeDelta / 3 * 1.15);
      lsPrint(110, 50, 5, 0.7, 0.7, 0xff0000ff, "Despawns in ~ " .. getDuration(realMinutes));
    end

    if tab == "notes" then
      if lsButtonText(110, 70, 5, 90, 0x999999ff, "Notes") then
        tab = "notes";
      end

      if lsButtonText(205, 70, 5, 90, 0xffffffff, "Last Seen") then
        tab = "reports";
      end

       lsPrintWrapped(5, 130, 5, 290, 0.7, 0.7, 0xffffffff, mushroom.notes);
    elseif tab == "reports" then
      if lsButtonText(110, 70, 5, 90, 0xffffffff, "Notes") then
        tab = "notes";
      end

      if lsButtonText(205, 70, 5, 90, 0x999999ff, "Last Seen") then
        tab = "reports";
      end

      lsPrint(5, 130, 5, 0.7, 0.7, 0xffffffff, "Last Seen:");

      local y = 155;
      for _, report in pairs(mushroom.reports) do
        lsPrint(5, y, 5, 0.7, 0.7, 0xffffffff, report.coords);
        lsPrint(95, y, 5, 0.7, 0.7, 0xffffffff, report.region);
        lsPrint(205, y, 5, 0.7, 0.7, 0xffffffff, report.name);
        lsPrint(25, y + 20, 5, 0.7, 0.7, 0xffffffff, report.datetime);
        y = y + 45;
      end
    end

    if lsButtonText(5, lsScreenY - 60, 5, 100, 0xffffffff, "Report") then
      reportToShroomdar(mushroom);
    end

    if lsButtonText(110, lsScreenY - 60, 5, 100, 0xffffffff, "Ecology") then
      reportEcology(mushroom);
    end

    if mushroom.alert then
      if lsButtonText(5, lsScreenY - 30, 5, 100, 0x00ff00ff, "Alerts On") then
        mushroom.alert = false;
        writeSettings();
      end
    else
      if lsButtonText(5, lsScreenY - 30, 5, 100, 0xff0000ff, "Alerts Off") then
        mushroom.alert = true;
        writeSettings();
      end
    end

    if mushroom.show then
      if lsButtonText(110, lsScreenY - 30, 5, 100, 0x00ff00ff, "Shown") then
        mushroom.show = false;
        writeSettings();
      end
    else
      if lsButtonText(110, lsScreenY - 30, 5, 100, 0xff0000ff, "Hidden") then
        mushroom.show = true;
        writeSettings();
      end
    end

    if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xffffffff, "Back") then
      return false;
    end

    lsDoFrame();
    checkBreak();
    lsSleep(10);
  end
end

function displayMushroomLine(y, mushroom)
  local color = 0xffffffff;
  if mushroom.activeDelta > 0 then
    color = 0x999999ff;
  end
  if lsButtonText(5, y, 5, 150, color, mushroom.name) then
    displayMushroomDetails(mushroom);
  end

  if mushroom.activeDelta > 0 then
    local realMinutes = math.floor(mushroom.activeDelta / 3 * 1.15);
    lsPrint(160, y + 5, 5, 0.7, 0.7, 0xffff00ff, "Spawn in " .. getDuration(realMinutes));
  else
    local realMinutes = math.floor(-mushroom.activeDelta / 3 * 1.15);
    lsPrint(160, y + 5, 5, 0.7, 0.7, 0xff0000ff, "Despawn in " .. getDuration(realMinutes));
  end
end

function setAll(property, value)
  for _, mushroom in pairs(mushroomData) do
    mushroom[property] = value;
  end
end

function sortMushroomsByName()
  table.sort(mushroomData, function(a, b)
    return a.name < b.name;
  end);
end

function sortMushroomsByDelta()
  table.sort(mushroomData, function(a, b)
    if a.activeDelta == b.activeDelta then
      return a.name < b.name;
    end

    if a.activeDelta < 0 then
      if b.activeDelta > 0 then
        return true;
      end

      return a.activeDelta > b.activeDelta;
    end

    return a.activeDelta < b.activeDelta;
  end);
end

function getActiveDelta(time, mushroom)
  if mushroom.startMinutes < mushroom.stopMinutes then
    if time >= mushroom.startMinutes and time <= mushroom.stopMinutes then
      --This is active. Negative values are the time until inactive
      return time - mushroom.stopMinutes;
    elseif time < mushroom.startMinutes then
      return mushroom.startMinutes - time;
    else
      return 24 * 60 - time + mushroom.startMinutes;
    end
  else
    if time >= mushroom.startMinutes then
      --This is active. Negative values are the time until inactive
      return time - 24 * 60 - mushroom.stopMinutes;
    elseif time <= mushroom.stopMinutes then
      --This is active. Negative values are the time until inactive
      return time - mushroom.stopMinutes;
    else
      return mushroom.startMinutes - time;
    end
  end
end

function timeToMinutes(time)
  local hour, minute, ampm = string.match(time, "(%d%d?):(%d%d) ?(%a%a)");
  hour   = tonumber(hour);
  minute = tonumber(minute);

  if ampm == "PM" and hour < 12 then
    hour = hour + 12;
  elseif ampm == "AM" and hour == 12 then
    hour = 0;
  end
  return hour * 60 + minute;
end
