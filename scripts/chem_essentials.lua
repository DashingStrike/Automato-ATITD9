dofile("common.inc");

local essences = {
  ["Resin:Acacia"] = 11,
  ["Resin:Acacia Sapling"] = 9,
  ["Resin:Acacia Youth"] = 23,
  ["Resin:Anaxi"] = 16,
  ["Resin:Arconis"] = 85,
  ["Resin:Ash Palm"] = 41,
  ["Resin:Autumn Bloodbark"] = 73,
  ["Resin:Autumn Bloodbark Sapling"] = 46,
  ["Resin:Autumn Bloodbark Youth"] = 7,
  ["Resin:Beetlenut"] = 55,
  ["Resin:Blaze Maple"] = 82,
  ["Resin:Blaze Maple Sapling"] = 45,
  ["Resin:Blaze Maple Youth"] = 84,
  ["Resin:Bloodbark"] = 13,
  ["Resin:Bottle Tree"] = 89,
  ["Resin:Bramble Hedge"] = 6,
  ["Resin:Broadleaf Palm"] = 78,
  ["Resin:Butterleaf Tree"] = 10,
  ["Resin:Cerulean Blue"] = 56,
  ["Resin:Chakkanut Tree"] = 11,
  ["Resin:Chicory"] = 56,
  ["Resin:Cinnar"] = 67,
  ["Resin:Coconut Palm"] = 26,
  ["Resin:Cricklewood"] = 48,
  ["Resin:Deadwood Tree"] = 35,
  ["Resin:Delta Palm"] = 3,
  ["Resin:Dikbas"] = 37,
  ["Resin:Dikbas Sapling"] = 33,
  ["Resin:Dikbas Youth"] = 60,
  ["Resin:Dwarf Safsaf"] = 11,
  ["Resin:Elephantia"] = 75,
  ["Resin:leather Tree"] = 66,
  ["Resin:leather Tree Sapling"] = 28,
  ["Resin:leather Tree Youth"] = 64,
  ["Resin:lern Palm"] = 27,
  ["Resin:lolded Birch"] = 20,
  ["Resin:Giant Cricklewood"] = 12,
  ["Resin:Golden Hemlock"] = 35,
  ["Resin:Golden Hemlock Sapling"] = 67,
  ["Resin:Green Ash"] = 43,
  ["Resin:Green Ash Sapling"] = 8,
  ["Resin:Green Ash Youth"] = 65,
  ["Resin:Hawthorn"] = 67,
  ["Resin:Hokkaido"] = 8,
  ["Resin:Illawara"] = 37,
  ["Resin:Illawara Sapling"] = 10,
  ["Resin:Illawara Youth"] = 7,
  ["Resin:Jacaranda"] = 75,
  ["Resin:Jacaranda Sapling"] = 49,
  ["Resin:Jacaranda Youth"] = 17,
  ["Resin:Japanesecherry"] = 45,
  ["Resin:Japanese Cherry Sapling"] = 67,
  ["Resin:Japanese Cherry Youth"] = 2,
  ["Resin:Kaeshra"] = 71,
  ["Resin:Katsura Sapling"] = 24,
  ["Resin:Katsura Tree"] = 84,
  ["Resin:Katsura Youth"] = 10,
  ["Resin:Khaya"] = 42,
  ["Resin:Khaya Sapling"] = 80,
  ["Resin:Khaya Youth"] = 71,
  ["Resin:Locust Palm"] = 80,
  ["Resin:Mimosa"] = 10,
  ["Resin:Mimosa Sapling"] = 16,
  ["Resin:Mimosa Youth"] = 20,
  ["Resin:Mini Palmetto"] = 84,
  ["Resin:Miniaturelern Palm"] = 50,
  ["Resin:Monkey Palm"] = 47,
  ["Resin:Monterey Pine"] = 50,
  ["Resin:Monterey Pine Middle Age"] = 42,
  ["Resin:Monterey Pine Sapling"] = 57,
  ["Resin:Montu Maple"] = 61,
  ["Resin:Oil Palm"] = 20,
  ["Resin:Oleaceae"] = 39,
  ["Resin:Orane"] = 68,
  ["Resin:Orrorin"] = 70,
  ["Resin:Parrotia"] = 78,
  ["Resin:Parrotia Sapling"] = 48,
  ["Resin:Parrotia Youth"] = 72,
  ["Resin:Passam"] = 51,
  ["Resin:Peaches 'n Cream Maple"] = 74,
  ["Resin:Peaches 'n Cream Sapling"] = 10,
  ["Resin:Peaches 'n Cream Youth"] = 57,
  ["Resin:Phoenix Palm"] = 62,
  ["Resin:Pratyeka Tree"] = 64,
  ["Resin:Ranyahn"] = 16,
  ["Resin:Razor Palm"] = 28,
  ["Resin:Red Maple"] = 29,
  ["Resin:River Birch"] = 54,
  ["Resin:River Birch Sapling"] = 69,
  ["Resin:River Birch Youth"] = 34,
  ["Resin:Royal Palm"] = 23,
  ["Resin:Safsaf Sapling"] = 6,
  ["Resin:Safsaf Willow"] = 41,
  ["Resin:Savaka"] = 3,
  ["Resin:Scaley Hardwood"] = 30,
  ["Resin:Silky Oak"] = 60,
  ["Resin:Spikedlishtree"] = 82,
  ["Resin:Spindle Tree"] = 39,
  ["Resin:Stout Palm"] = 16,
  ["Resin:Stout Palm"] = 16,
  ["Resin:Summer Maple"] = 90,
  ["Resin:Summer Maple Sapling"] = 59,
  ["Resin:Summer Maple Youth"] = 43,
  ["Resin:Sweet Pine"] = 90,
  ["Resin:Tapacae Miralis"] = 77,
  ["Resin:Tiny Oil Palm"] = 22,
  ["Resin:Towering Palm"] = 88,
  ["Resin:Trilobellia"] = 70,
  ["Resin:Umbrella Palm"] = 59,
  ["Resin:White Pine"] = 37,
  ["Resin:White Pine Sapling"] = 38,
  ["Resin:White Pine Youth"] = 46,
  ["Resin:Windriver Palm"] = 35,
  ["Resin:Young Golden Hemlock"] = 15,
  ["Powdered:Almandine"] = 56,
  ["Powdered:Amethyst"] = 60,
  ["Powdered:Aquamarine"] = 27,
  ["Powdered:Aqua Pearl"] = 29,
  ["Powdered:Beige Pearl"] = 47,
  ["Powdered:Black Pearl"] = 72,
  ["Powdered:Citrine"] = 2,
  ["Powdered:Coral Pearl"] = 52,
  ["Powdered:Diamond"] = 25,
  ["Powdered:Emerald"] = 31,
  ["Powdered:Garnet"] = 34,
  ["Powdered:Jade"] = 37,
  ["Powdered:Kunzite"] = 41,
  ["Powdered:Lapis"] = 90,
  ["Powdered:Morganite"] = 5,
  ["Powdered:Opal"] = 17,
  ["Powdered:Pink Pearl"] = 35,
  ["Powdered:Quartz"] = 71,
  ["Powdered:Ruby"] = 88,
  ["Powdered:Sapphire"] = 17,
  ["Powdered:Smoke Pearl"] = 36,
  ["Powdered:Sunstone"] = 21,
  ["Powdered:Topaz"] = 2,
  ["Powdered:Turquoise"] = 57,
  ["Powdered:White Pearl"] = 28,
  ["Salts Of Aluminum"] = 29,
  ["Salts Of Antimony"] = 50,
  ["Salts Of Cobalt"] = 68,
  ["Salts Of Copper"] = 41,
  ["Salts Of Gold"] = 9,
  ["Salts Of Iron"] = 4,
  ["Salts Of Lead"] = 88,
  ["Salts Of Lithium"] = nil,
  ["Salts Of Magnesium"] = 52,
  ["Salts Of Nickel"] = 80,
  ["Salts Of Platinum"] = 6,
  ["Salts Of Silver"] = 15,
  ["Salts Of Strontium"] = nil,
  ["Salts Of Tin"] = 46,
  ["Salts Of Titanium"] = nil,
  ["Salts Of Tungsten"] = nil,
  ["Salts Of Zinc"] = 63,
  ["Oyster Shell Marble Dust"] = nil,
  ["Allbright"] = nil,
  ["Aloe"] = nil,
  ["Altar's Blessing"] = nil,
  ["Anansi"] = nil,
  ["Apiphenalm"] = nil,
  ["Apothecary's Scythe"] = nil,
  ["Artemesia"] = nil,
  ["Asafoetida"] = nil,
  ["Asane"] = nil,
  ["Ashoka"] = nil,
  ["Azure Tristeria"] = nil,
  ["Banto"] = nil,
  ["Bay Tree"] = nil,
  ["Bee Balm"] = nil,
  ["Beetle Leaf"] = nil,
  ["Beggar's Button"] = nil,
  ["Bhillawa"] = nil,
  ["Bilimbi"] = nil,
  ["Bitter Florian"] = nil,
  ["Black Pepper Plant"] = 75,
  ["Blessed Mariae"] = nil,
  ["Bleubaille"] = nil,
  ["Blood Balm"] = nil,
  ["Blood Blossom"] = nil,
  ["Blood Root"] = nil,
  ["Blooded Harebell"] = nil,
  ["Bloodwort"] = nil,
  ["Blue Damia"] = nil,
  ["Blue Tarafern"] = nil,
  ["Blueberry Tea Tree"] = nil,
  ["Bluebottle Clover"] = 65,
  ["Blushing Blossom"] = nil,
  ["Brassy Caltrops"] = nil,
  ["Brown Muskerro"] = nil,
  ["Buckler-leaf"] = 16,
  ["Bull's Blood"] = nil,
  ["Burnt Tarragon"] = nil,
  ["Butterfly Damia"] = nil,
  ["Butterroot"] = nil,
  ["Calabash"] = nil,
  ["Camelmint"] = nil,
  ["Caraway"] = nil,
  ["Cardamom"] = 26,
  ["Cassia"] = nil,
  ["Chaffa"] = nil,
  ["Chatinabrae"] = nil,
  ["Chives"] = 15,
  ["Chukkah"] = nil,
  ["Cicada Bean"] = nil,
  ["Cinnamon"] = 88,
  ["Cinquefoil"] = nil,
  ["Cirallis"] = nil,
  ["Clingroot"] = nil,
  ["Common Basil"] = 10,
  ["Common Rosemary"] = 62,
  ["Common Sage"] = 51,
  ["Corsacia"] = nil,
  ["Covage"] = 29,
  ["Crampbark"] = 80,
  ["Cranesbill"] = nil,
  ["Creeping Black Nightshade"] = nil,
  ["Creeping Thyme"] = nil,
  ["Crimson Clover"] = nil,
  ["Crimson Lettuce"] = 74,
  ["Crimson Nightshade"] = nil,
  ["Crimson Pipeweed"] = nil,
  ["Crimson Windleaf"] = nil,
  ["Crumpled Leaf Basil"] = nil,
  ["Curly Sage"] = nil,
  ["Cyan Cressidia"] = nil,
  ["Daggerleaf"] = 33,
  ["Dalchini"] = nil,
  ["Dameshood"] = nil,
  ["Dank Mullien"] = nil,
  ["Dark Ochoa"] = 90,
  ["Dark Radish"] = nil,
  ["Death's Piping"] = nil,
  ["Deadly Catsclaw"] = nil,
  ["Dewplant"] = nil,
  ["Digweed"] = nil,
  ["Discorea"] = 19,
  ["Drapeau D'or"] = nil,
  ["Dusty Blue Sage"] = nil,
  ["Dwarf Hogweed"] = 65,
  ["Dwarf Wild Lettuce"] = nil,
  ["Earth Apple"] = nil,
  ["Elegia"] = nil,
  ["Enchanter's Plant"] = nil,
  ["Finlow"] = nil,
  ["Fire Allspice"] = nil,
  ["Fire Lily"] = nil,
  ["Fivesleaf"] = nil,
  ["Flaming Skirret"] = nil,
  ["Flander's Blossom"] = nil,
  ["Fleabane"] = 2,
  ["Fool's Agar"] = 64,
  ["Fumitory"] = nil,
  ["Garcinia"] = nil,
  ["Garlic Chives"] = nil,
  ["Ginger Root"] = nil,
  ["Ginger Tarragon"] = nil,
  ["Ginseng Root"] = nil,
  ["Glechoma"] = 1,
  ["Gnemnon"] = nil,
  ["Gokhru"] = nil,
  ["Golden Doubloon"] = nil,
  ["Golden Gladalia"] = nil,
  ["Golden Sellia"] = nil,
  ["Golden Sweetgrass"] = nil,
  ["Golden Sun"] = nil,
  ["Golden Thyme"] = nil,
  ["Gynura"] = nil,
  ["Harebell"] = 14,
  ["Harrow"] = nil,
  ["Hazlewort"] = 53,
  ["Headache Tree"] = nil,
  ["Heartsease"] = nil,
  ["Hogweed"] = 80,
  ["Homesteader Palm"] = nil,
  ["Honey Mint"] = nil,
  ["Houseleek"] = 40,
  ["Hyssop"] = 60,
  ["Ice Blossom"] = nil,
  ["Ice Mint"] = nil,
  ["Ilex"] = nil,
  ["Indigo Damia"] = 60,
  ["Ipomoea"] = nil,
  ["Jagged Dewcup"] = nil,
  ["Jaivanti"] = nil,
  ["Jaiyanti"] = nil,
  ["Joyofthe Mountain"] = nil,
  ["Jugwort"] = nil,
  ["Katako Root"] = nil,
  ["Khokali"] = nil,
  ["King's Coin"] = nil,
  ["Lamae"] = nil,
  ["Larkspur"] = nil,
  ["Lavender Navarre"] = nil,
  ["Lavender Scented Thyme"] = nil,
  ["Lemon Basil"] = nil,
  ["Lemon Grass"] = nil,
  ["Lemondrop"] = 52,
  ["Lilia"] = nil,
  ["Liquorice"] = nil,
  ["Lungclot"] = nil,
  ["Lythrum"] = 59,
  ["Mahonia"] = nil,
  ["Maliceweed"] = nil,
  ["Mandrake Root"] = nil,
  ["Maragosa"] = nil,
  ["Mariae"] = 20,
  ["Meadowsweet"] = 51,
  ["Medicago"] = nil,
  ["Mindanao"] = 9,
  ["Miniature Bamboo"] = nil,
  ["Miniature Lamae"] = nil,
  ["Mirabellis Fern"] = nil,
  ["Moon Aloe"] = nil,
  ["Morpha"] = 61,
  ["Motherwort"] = 77,
  ["Mountain Mint"] = 88,
  ["Myristica"] = 9,
  ["Myrrh"] = nil,
  ["Naranga"] = nil,
  ["Nubian Liquorice"] = nil,
  ["Octec's Grace"] = nil,
  ["Opal Harebell"] = nil,
  ["Orange Niali"] = 21,
  ["Orange Sweetgrass"] = nil,
  ["Orris"] = nil,
  ["Pale Dhamasa"] = 62,
  ["Pale Ochoa"] = nil,
  ["Pale Russet"] = nil,
  ["Pale Skirret"] = nil,
  ["Panoe"] = nil,
  ["Paradise Lily"] = nil,
  ["Patchouli"] = nil,
  ["Peppermint"] = nil,
  ["Pippali"] = nil,
  ["Pitcher Plant"] = nil,
  ["Primula"] = nil,
  ["Prisniparni"] = nil,
  ["Pulmonaria Opal"] = nil,
  ["Purple Tintiri"] = nil,
  ["Quamash"] = nil,
  ["Red Nasturtium"] = 46,
  ["Red Pepper Plant"] = nil,
  ["Revivia"] = nil,
  ["Rhubarb"] = nil,
  ["Royal Rosemary"] = nil,
  ["Rubia"] = nil,
  ["Rubydora"] = nil,
  ["Sacred Palm"] = nil,
  ["Sagar Ghota"] = nil,
  ["Sandalwood"] = nil,
  ["Sandy Dustweed"] = nil,
  ["Satsatchi"] = nil,
  ["Schisandra"] = nil,
  ["Shrub Sage"] = 27,
  ["Shrubby Basil"] = nil,
  ["Shyama"] = nil,
  ["Shyamalata"] = nil,
  ["Sickly Root"] = nil,
  ["Silvertongue Damia"] = 50,
  ["Skirret"] = nil,
  ["Sky Gladalia"] = nil,
  ["Soapwort"] = nil,
  ["Sorrel"] = 77,
  ["Spinach"] = nil,
  ["Spinnea"] = nil,
  ["Squill"] = nil,
  ["Steel Bladegrass"] = nil,
  ["Stickler Hedge"] = 11,
  ["Strawberry Tea"] = 46,
  ["Strychnos"] = nil,
  ["Sugar Cane"] = nil,
  ["Sweet Groundmaple"] = nil,
  ["Sweetflower"] = nil,
  ["Sweetgrass"] = nil,
  ["Sweetsop"] = nil,
  ["Tagetese"] = nil,
  ["Tamarask"] = nil,
  ["Tangerine Dream"] = nil,
  ["Thunder Plant"] = nil,
  ["Thyme"] = 56,
  ["Tiny Clover"] = 85,
  ["Trilobe"] = nil,
  ["Tristeria"] = nil,
  ["True Tarragon"] = nil,
  ["Tsangto"] = 12,
  ["Tsatso"] = nil,
  ["Turtle's Shell"] = nil,
  ["Umber Basil"] = nil,
  ["Upright Ochoa"] = nil,
  ["Vanilla Tea Tree"] = nil,
  ["Verdant Squill"] = 76,
  ["Verdant Two-Lobe"] = nil,
  ["Wasabi"] = nil,
  ["Weeping Patala"] = nil,
  ["White Pepper Plant"] = nil,
  ["Whitebelly"] = nil,
  ["Wild Garlic"] = nil,
  ["Wild Lettuce"] = 80,
  ["Wild Onion"] = nil,
  ["Wild Yam"] = nil,
  ["Wood Sage"] = nil,
  ["Xanat"] = nil,
  ["Xanosi"] = 80,
  ["Yava"] = nil,
  ["Yellow Gentian"] = nil,
  ["Yellow Tristeria"] = nil,
  ["Yigory"] = nil,
  ["Zanthoxylum"] = nil,
  ["Camel Pheromone Female"] = nil,
  ["Camel Pheromone Male"] = nil,
};

tick_time = 100;
per_click_delay = 50;
per_read_delay = 150;

local spirits = {
  [0] = "Rock",
  "Wood",
  "Worm",
  "Grain",
  "Grass",
  "Fruit",
  "Vegetable",
  "Mineral",
  "Fish",
  "Grey"
};
local qualities = {
  "Grey",
  "Earth",
  "Water",
  "Fire",
  "Air",
  "Life",
  "Ra"
};

local inventory = {};
local recipeCache = {};
local auto = false;

function getQualitySuffix(quality)
  if quality == 1 then
    return "";
  end

  return " of " .. qualities[quality];
end

function parseInventory()
  local items = {};

  local clipboard = lsClipboardGet();
  local lines = explode("\n", clipboard);
  for _, line in pairs(lines) do
    local count, name = string.match(line, "(%d+) ([^\n\r]+)");
    if count and name then
      items[name] = count;
    end
  end

  return items;
end

function getSpiritInventory()
  while true do
    if not promptOkay("Put your spirits in a container, and copy it's contents to your clipboard from the Utility... menu") then
      error("Canceled by user");
    end

    local items = parseInventory();
    inventory = {};
    local totals = {};
    local counts = {};
    for i = 0, #spirits do
      totals[i] = 0;
      counts[i] = {};

      for j = 1, #qualities do
        local quality = qualities[j];

        local count = items["Spirits:" .. spirits[i] .. " Spirits" .. getQualitySuffix(j)];
        if count then
          totals[i] = count;
          table.insert(counts[i], count .. " " .. quality);

          table.insert(inventory, {
            spirit = i,
            quality = j,
            count = tonumber(count)
          });
        end
      end
    end

    while true do
      local x = 5;
      local y = 5;

      for i = 0, #spirits do
        lsPrint(x, y, 5, 0.7, 0.7, 0xffffffff, spirits[i] .. ":");
        lsPrint(x + 75, y, 5, 0.7, 0.7, 0xffffffff, math.floor(totals[i]));
        lsPrintWrapped(x + 10, y + 15, 5, 125, 0.7, 0.7, 0xffffffff, table.concat(counts[i], ", "));
        y = y + 65;

        if i == 4 then
          x = 155;
          y = 5;
        end
      end

      if #inventory > 0 and lsButtonText(5, lsScreenY - 30, 5, 80, 0x80ff80ff, "Confirm") then
        sortInventory();
        return;
      end

      if lsButtonText(lsScreenX / 2 - 40, lsScreenY - 30, 5, 80, 0xffff80ff, "Retry") then
        break;
      end

      if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xff8080ff, "End") then
        error("Script ended by user");
      end

      lsDoFrame();
      lsSleep(10);
      checkBreak();
    end

    lsSleep(10);
    checkBreak();
  end
end

function updateInventory(recipe)
  for _, stock in pairs(inventory) do
    if recipe[stock.spirit] and recipe[stock.spirit][stock.quality] then
      stock.count = stock.count - recipe[stock.spirit][stock.quality];
      if stock.count == 0 then
        table.remove(inventory, _);
      end
    end
  end

  sortInventory();
end

function sortInventory()
  table.sort(inventory, function(a, b)
    if a.spirit == 9 then
      return false;
    end
    return tonumber(a.count) > tonumber(b.count);
  end);
end

function isValidRecipe(recipe, goal, count)
  local temp  = 0;
  local total = 0;
  for spirit, spiritQualities in pairs(recipe) do
    for quality, amount in pairs(spiritQualities) do
      temp = temp + spirit * amount;
      total = total + amount;
    end
  end

  return temp == goal and total == count;
end

function getRecipe(goal, count, minQuality, maxQuality)
  checkBreak();
  if count == 0 or goal > count * #spirits then
    return {};
  end

  --Avoid the 81 - 83 temps.
  --These temps require a small amount of grey spirits, which is counter productive.
  if goal >= 81 and goal <= 83 then
    goal = 80;
  end

  local recipeKey = table.concat({goal, count, minQuality, maxQuality}, ",");
  if recipeCache[recipeKey] then
    return recipeCache[recipeKey];
  end

  --Start by trying to match the exact quality
  --If that fails, loosen up quality requirements
  for qualityRange = 0, #qualities - 1 do
    for _, stock in pairs(inventory) do
      if stock.quality >= minQuality and stock.quality <= maxQuality then
        local additionalMinQuality = math.max(minQuality, stock.quality - qualityRange);
        local additionalMaxQuality = math.min(maxQuality, stock.quality + qualityRange);
        local max = math.min(stock.count, count);

        --Try to use as much of this spirit as possible
        for i = max, 1, -1 do
          local remaining = goal - stock.spirit * i;

          --If remaining < 0 then this spirit can't add enough temp to be useful
          if remaining >= 0 then
            local recipe = getRecipe(remaining, count - i, additionalMinQuality, additionalMaxQuality);
            if recipe[stock.spirit] == nil then
              recipe[stock.spirit] = {};
            end

            recipe[stock.spirit][stock.quality] = i;

            if isValidRecipe(recipe, goal, count) then
              recipeCache[recipeKey] = recipe;
              return recipe;
            end
          end
        end
      end
    end
  end

  recipeCache[recipeKey] = {};
  return {};
end

function findMaterial()
  statusScreen("Searching for material");
  local materialRegion = waitForText("Choose a material", nil, "Waiting for text 'Choose a material'", nil, REGION);
  local down = waitForImage(
    "downArrow.png",
    nil,
    "Waiting for down arrow image",
    materialRegion
  );
  statusScreen("Searching inventory. Hands off that mouse.");

  local lastParse = nil;
  while true do
    checkBreak();

    local parse = findAllText(nil, materialRegion, nil, {5, 29, -25, -75});
    if not parse then
      return nil;
    end

    --if nothing is changing, we've scrolled to the bottom
    if lastParse and lastParse[#lastParse][2] == parse[#parse][2] then
      return nil;
    end
    lastParse = parse;

    for i = 1, #parse do
      checkBreak();

      local name, count = string.match(parse[i][2], "(.-)%s+(%d+)");
      if name and count then
        local temp = essences[name];
        if tonumber(count) >= 10 and temp ~= nil then
          parse[i][2] = name;
          return parse[i];
        end
      end
    end

    --17 lines fit in the window, so scroll 16 at a time.
    for i = 1, 16 do
      checkBreak();
      safeClick(down[0] + 5, down[1] + 5);
      lsSleep(10);
    end

    srReadScreen();
  end
end

function addSpirits(lab, spirit, quality, count)
  waitAndClickText("Manufacture...", nil, lab);
  waitAndClickText("Alcohol Lamp...");
  waitAndClickText("Fill Alcohol Lamp with Spirits...");
  waitAndClickText(spirits[spirit] .. " Spirits" .. getQualitySuffix(quality));
  waitForText("How much", nil, "Waiting for text 'How much'");
  srKeyEvent(count .. "\n");
end

function processLab(lab)
  waitAndClickText("Manufacture...", nil, lab);
  waitAndClickText("Essential Distillation...");
  waitAndClickText("Place Essential Material Into the Macerator");

  while true do
    local parse = findMaterial();
    if not parse then
      return false;
    end

    local material = parse[2];
    local temp     = essences[material];
    local recipe   = getRecipe(temp, 10, 0, 9);

    while true do
      lsPrint(5, 5, 5, 0.7, 0.7, 0xffffffff, "Material: " .. material);
      lsPrint(5, 25, 5, 0.7, 0.7, 0xffffffff, "Recipe:");

      local y = 45;
      if next(recipe) then
        for spirit, spiritQualities in pairs(recipe) do
          for quality, count in pairs(spiritQualities) do
            lsPrint(5, y, 5, 0.7, 0.7, 0xffffffff, "  " .. count .. " " .. spirits[spirit] .. getQualitySuffix(quality));
            y = y + 20;
          end
        end

        if auto or lsButtonText(5, lsScreenY - 30, 5, 80, 0x80ff80ff, "Make") then
          clickText(parse);
          waitAndClickImage("ok.png");
          lsSleep(1000);
          waitForNoImage("ok.png", nil, "Waiting for material popup to close");

          for spirit, spiritQualities in pairs(recipe) do
            for quality, count in pairs(spiritQualities) do
              addSpirits(lab, spirit, quality, count);
            end
          end;

          updateInventory(recipe);

          waitAndClickText("Manufacture...", nil, lab);
          waitAndClickText("Essential Distillation...");
          local start = waitAndClickText("Start Essential Distillation", 5000);
          if not start then
            return false;
          end
          waitAndClickText("This is", nil, lab);
          return true;
        end
      else
        lsPrint(5, y, 5, 0.7, 0.7, 0xff8080ff, "None");
      end

      if lsButtonText(5, lsScreenY - 60, 5, 80, 0x80ff80ff, "Auto") then
        auto = true;
      end

      if lsButtonText(lsScreenX/2 - 40, lsScreenY - 30, 5, 80, 0xffff80ff, "Skip") then
        essences[material] = nil;
        break;
      end

      if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xff8080ff, "End") then
        error("Script ended by user");
      end

      checkBreak();
      lsDoFrame();
      lsSleep(10);
    end
  end
end

function doit()
  askForWindow([[
Chemistry Essentials
v1.0 by Kavad

You will need to copy your spirit inventory to
clipboard from a building's Utility... menu.
Then simply pickup all your spirits and
materials you want to make essences from.

The macro will search for materials to macerate
and will suggest which spirits to use.
The program starts in manual mode, where you
confirm each essence, but can be set to auto.

Hover over the ATITD window and press shift.
  ]]);

  getSpiritInventory();

  while true do
    local lab = getChemLab();
    if not processLab(lab) then
      while true do
        lsPrint(5, 5, 5, 0.7, 0.7, 0xffffffff, "You are out of essential materials or spirits.");
        if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xffffffff, "Done") then
          return;
        end

        checkBreak();
        lsDoFrame();
        lsSleep(10);
      end
    end
  end
end

function waitAndClickText(text, timeout, region)
  local found = waitForText(
    text,
    timeout,
    "Waiting for text '" .. text .. "'",
    region
  );

  if not found then
    return false;
  end

  clickText(found);
  return true;
end

function waitAndClickImage(image, region)
  clickText(waitForImage(
    image,
    nil,
    "Waiting for image '" .. image .. "'",
    region
  ));
end

function getChemLab(name)
  refreshWindows();

  local building = findText("This is [a-z]+ Chemistry Laboratory", nil, REGEX + REGION);
  while not building do
    building = findText("This is [a-z]+ Chemistry Laboratory", nil, REGEX + REGION);
    if building then
      break;
    end

    lsPrint(5, 5, 5, 0.7, 0.7, 0xffffffff, "Waiting for Chemistry Laboratory");
    if auto then
      if lsButtonText(5, lsScreenY - 30, 5, 80, 0xffff80ff, "Manual") then
        auto = false;
      end
    end

    if lsButtonText(lsScreenX - 85, lsScreenY - 30, 5, 80, 0xff8080ff, "End") then
      auto = false;
    end

    refreshWindows();
    checkBreak();
    lsDoFrame();
    lsSleep(10);
  end

  return building;
end

function refreshWindows()
  srReadScreen();
  pinWindows = findAllImages("UnPin.png");
  for i = 1, #pinWindows do
    safeClick(pinWindows[i][0] - 7, pinWindows[i][1]);
    lsSleep(100);
  end
  srReadScreen();
end
