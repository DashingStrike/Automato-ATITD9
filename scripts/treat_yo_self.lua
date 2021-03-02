-- Treat Yo' Self by Kavad
-- used a bit of logic for reading values from wtt_k_values.lua by Dunagain

dofile("common.inc");

local materialIndex = "wood";

local materials = {
  wood = {
    attributes = {
      {
        name = "Flexibility",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Rigid"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Pliable"
          }
        }
      },
      {
        name = "Cuttability",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Hard"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Soft"
          }
        }
      },
      {
        name = "Flammability",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Fireproof"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Volatile"
          }
        }
      },
      {
        name = "Water Resist",
        attributes = {
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Rotproof"
          }
        }
      },
      {
        name = "Insect Tox",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Termite-prone"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Termite-resistant"
          }
        }
      },
      {
        name = "Human Tox",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Nontoxic"
          }
        }
      },
      {
        name = "Darkness",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "White"
          },
          {
            min = 11,
            max = 25,
            target = 18,
            name = "Blonde"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Black"
          }
        }
      },
      {
        name = "Glossiness",
        attributes = {
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Glossy"
          }
        }
      },
    },
    treatments = {
      {
        name = "Ash",
        targets = {
          56,
          56,
          0,
          24,
          40,
          48,
          40,
          0,
        }
      },
      {
        name = "Beeswax",
        targets = {
          48,
          40,
          40,
          72,
          24,
          40,
          24,
          72,
        }
      },
      {
        name = "Bonemeal",
        targets = {
          72,
          32,
          16,
          48,
          32,
          0,
          0,
          56,
        }
      },
      {
        name = "Charcoal",
        targets = {
          16,
          0,
          48,
          40,
          32,
          8,
          72,
          16,
        }
      },
      {
        name = "Lead",
        targets = {
          8,
          8,
          24,
          32,
          72,
          64,
          64,
          32,
        }
      },
      {
        name = "Lime",
        targets = {
          0,
          24,
          8,
          48,
          8,
          16,
          0,
          16,
        }
      },
      {
        name = "Oil",
        targets = {
          56,
          32,
          48,
          56,
          16,
          32,
          56,
          56,
        }
      },
      {
        name = "Petroleum",
        targets = {
          40,
          16,
          72,
          64,
          64,
          56,
          48,
          48,
        }
      },
      {
        name = "Potash",
        targets = {
          24,
          64,
          16,
          8,
          32,
          24,
          8,
          8,
        }
      },
      {
        name = "Saltpeter",
        targets = {
          64,
          72,
          56,
          16,
          56,
          8,
          16,
          48,
        }
      },
      {
        name = "Sulfur",
        targets = {
          16,
          0,
          64,
          40,
          48,
          72,
          40,
          24,
        }
      },
      {
        name = "Water",
        targets = {
          32,
          48,
          32,
          0,
          0,
          8,
          32,
          40,
        }
      },
    },
    priorities = {8,1,2,3,4,5,6,7},
    building = "Wood Treatment Tank",
    treatmentMenu = "Treat...",
    treatmentMenuItem = "Treat with %s",
    file = "treat_boards.txt",
  },
  metal = {
    attributes = {
      {
        name = "Tensility",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Brittle"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Ductile"
          }
        }
      },
      {
        name = "Lustre",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Tarnished"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Shiny"
          }
        }
      },
      {
        name = "Strength",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Plastic"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Hard"
          }
        }
      },
      {
        name = "Corrosion",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Stainless"
          },
          {
            min = 12,
            max = 21,
            target = 16,
            name = "Resistant"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Prone"
          }
        }
      },
      {
        name = "Conductivity",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Insulative"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Conductive"
          }
        }
      },
      {
        name = "Toxicity",
        attributes = {
          {
            min = 0,
            max = 11,
            target = 0,
            name = "Nontoxic"
          },
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Toxic"
          }
        }
      },
      {
        name = "Purity",
        attributes = {
          {
            min = 68,
            max = 72,
            target = 72,
            name = "10"
          },
          {
            min = 60,
            max = 72,
            target = 72,
            name = "9"
          },
          {
            min = 52,
            max = 72,
            target = 72,
            name = "8"
          },
          {
            min = 44,
            max = 72,
            target = 72,
            name = "7"
          },
          {
            min = 36,
            max = 72,
            target = 72,
            name = "6"
          },
          {
            min = 28,
            max = 72,
            target = 72,
            name = "5"
          },
          {
            min = 20,
            max = 72,
            target = 72,
            name = "4"
          },
          {
            min = 12,
            max = 72,
            target = 72,
            name = "3"
          },
          {
            min = 4,
            max = 72,
            target = 72,
            name = "2"
          },
          {
            min = 0,
            max = 72,
            target = 72,
            name = "1"
          },
        }
      },
      {
        name = "Plating",
        attributes = {
          {
            min = 61,
            max = 72,
            target = 72,
            name = "Plated"
          }
        }
      },
    },
    treatments = {
      {
        name = "Arsenic",
        targets = {
          72,
          40,
          48,
          0,
          16,
          8,
          56,
          24,
        }
      },
      {
        name = "Cabbage Juice",
        targets = {
          24,
          48,
          56,
          32,
          0,
          64,
          16,
          72,
        }
      },
      {
        name = "Cactus Sap",
        targets = {
          16,
          64,
          8,
          72,
          56,
          24,
          40,
          0,
        }
      },
      {
        name = "Coal",
        targets = {
          40,
          56,
          72,
          16,
          64,
          0,
          24,
          32,
        }
      },
      {
        name = "Gravel",
        targets = {
          48,
          72,
          24,
          8,
          40,
          16,
          32,
          64,
        }
      },
      {
        name = "Lime",
        targets = {
          0,
          24,
          16,
          56,
          32,
          48,
          64,
          40,
        }
      },
      {
        name = "Potash",
        targets = {
          8,
          16,
          64,
          48,
          24,
          30,
          0,
          56,
        }
      },
      {
        name = "Salt",
        targets = {
          32,
          8,
          0,
          40,
          48,
          56,
          72,
          16,
        }
      },
      {
        name = "Saltpeter",
        targets = {
          64,
          32,
          40,
          24,
          8,
          72,
          16,
          48,
        }
      },
      {
        name = "Sulfur",
        targets = {
          56,
          0,
          32,
          64,
          72,
          40,
          48,
          8,
        }
      },
    },
    priorities = {6,8,1,2,3,5,7,4},
    building = "Chemical Bath",
    treatmentMenu = "Dissolve...",
    treatmentMenuItem = "Dissolve %s in the Acid",
    file = "treat_metal.txt",
  },
};

local suggestionData = {
  {
    name = "Great",
    color = 0x80ff80ff,
  },
  {
    name = "Good",
    color = 0xffff80ff,
  },
  {
    name = "Okay",
    color = 0xffbb80ff,
  }
};

local blueColors = {
  0X010130FF, 0x0706FDFF, 0x0707FEFF,
  0x0706FEFF, 0x0606FDFF, 0x0605D4FF,
  0x0505D4FF, 0x0605D5FF, 0x040382FF,
  0x030382FF, 0x040383FF, 0x807FFEFF,
  0x7FFFFEFF, 0X2F2EFDFF, 0X2E2EFDFF,
  0xD0D0FFFF, 0x7F7FFEFF, 0x77FEFFFF,
  0x76FEFFFF
};

local recipeData = {};

function matchPixel(pixel)
local match = false;
  for k,v in pairs(blueColors)
  do
    local d = v - pixel;
    if (d % 4294967296 ==  0)
    then
      match = true ;
    end
  end
  return match;
end

function calcValue(property)
  local x      = materials[materialIndex].attributes[property].pos[1];
  local y      = materials[materialIndex].attributes[property].pos[2];
  local result = 0;
  local pixel  = srReadPixelFromBuffer(x, y);

  while (matchPixel(pixel) == true) do
    result = result + 1;
    x      = x + 1;
    pixel  = srReadPixelFromBuffer(x, y);
  end

  return result;
end

function calcPos()
  srReadScreen();

  tank    = findText("This is [a-z]+ " .. materials[materialIndex].building, nil, REGION + REGEX);
  utility = findText("Utility", tank);
  while not tank or not utility do
    checkBreak();
    srReadScreen();
    tank = findText("This is [a-z]+ " .. materials[materialIndex].building, nil, REGION + REGEX);
    utility = findText("Utility", tank);
    sleepWithStatus(250,"Waiting for " .. materials[materialIndex].building .. " window", nil, 0.7);
  end

  if utility then
    statsX = utility[0] + 112;
    statsY = utility[1] + 71;

    for index, data in pairs(materials[materialIndex].attributes) do
      materials[materialIndex].attributes[index].pos = {statsX, statsY};
      statsY = statsY + 16;
    end
  end
end

function displayBuildingSelection()
  while true do
    lsPrint(5, 5, 0, 0.7, 0.7, 0xffffffff, "Which building do you want to use?");

    if lsButtonText(5, 30, 0, 190, 0x80ff80ff, materials["wood"].building) then
      materialIndex = "wood";
      break;
    end

    if lsButtonText(5, 70, 0, 120, 0x80ff80ff, materials["metal"].building) then
      materialIndex = "metal";
      break;
    end

    checkBreak();
    lsDoFrame();
    lsSleep(50);
  end
end

function displayGoals()
  while true do
    lsPrint(5, 5, 5, 0.7, 0.7, 0xffffff, "Select goal attributes:");

    local attributesY = 35;
    for index, data in pairs(materials[materialIndex].attributes) do
      lsPrint(5, attributesY, 0, 0.7, 0.7, 0xffffffff, data.name .. ":");

      local options = {"None"};
      for attribute, attributeData in pairs(data.attributes) do
        local name = attributeData.name;
        if data.name == "Purity" then
          name = name .. "+";
        end

        table.insert(options, name);
      end

      data.goal = lsDropdown(index, 100, attributesY, 0, 180, data.goal + 1, options) - 1;
      attributesY = attributesY + 30;
    end

    checkBreak();
    lsDoFrame();
    if lsButtonText(lsScreenX - 105, lsScreenY - 30, 0, 100, 0x80ff80ff, "Next") then
      break;
    end
  end

  while true do
    lsPrintWrapped(5, 5, 0, lsScreenX - 5, 0.7, 0.7, 0xffffffff, [[
The macro will monitor your building
and suggest treatments to apply.

You can click the suggestion to apply it.
It will keep track of what it uses this way.
It will only suggest 10 seconds at a time,
so that it can respond to changes.

This should achieve most of the useful recipes,
however complex recipes may get stuck.

The macro may not detect attributes if they
are right at the border, due to rounding.

If this proves reliable, a full-auto mode is feasible.

Enjoy.
]]);

    if lsButtonText(lsScreenX - 105, lsScreenY - 30, 0, 100, 0x80ff80ff, "Start") then
      break;
    end

    checkBreak();
    lsDoFrame();
    lsSleep(50);
  end
end

function printProperty(y, name, value, attribute, goal)
  lsPrint(5, y, 5, 0.7, 0.7, 0xffffffff, name);
  lsPrint(95, y, 5, 0.7, 0.7, 0xffffffff, value);
  lsPrint(140, y, 5, 0.7, 0.7, 0xffffffff, attribute);

  local goalColor = 0xff8080ff;
  if goal == "Goal" then
    goalColor = 0xffffffff;
  elseif attribute == goal then
    goalColor = 0x80ff80ff;
  elseif name == "Purity" and attribute >= goal then
    goalColor = 0x80ff80ff;
  end

  if name == "Purity" and goal ~= "" then
    goal = goal .. "+";
  end

  lsPrint(220, y, 5, 0.7, 0.7, goalColor, goal);
end

function displayProperties()
  local propertyY = 45;
  for index, data in pairs(materials[materialIndex].attributes) do
    local attributeValue = "";
    if data.attribute ~= nil then
      attributeValue = data.attributes[data.attribute].name;
    end

    local goalValue = "";
    if data.goal ~= 0 then
      goalValue = data.attributes[data.goal].name;
    end

    printProperty(propertyY, data.name, data.value, attributeValue, goalValue);
    propertyY = propertyY + 20;
  end
end

function isTreatmentUseful(property, treatment)
  local target = property.attributes[property.goal].target;
  if target > property.value and treatment.target < property.value then
    return false;
  end

  if target < property.value and treatment.target > property.value then
    return false;
  end

  return true;
end

function getScore(index, treatment, time)
  local data = materials[materialIndex].attributes[index];
  if data.goal == 0 then
    return 0;
  end

  local target          = data.attributes[data.goal].target;
  local treatmentTarget = treatment.targets[index];
  local delta           = getExpectedDelta(data.value, treatmentTarget, time);

  if target > data.value and treatmentTarget < data.value then
    return -delta;
  end

  if target < data.value and treatmentTarget > data.value then
    return -delta;
  end

  return delta;
end

function getExpectedDelta(currentValue, treatmentTarget, time)
    local pull     = square(treatmentTarget - currentValue) - 9 * time;
    local expected = treatmentTarget;
    if pull > 0 then
      if currentValue > treatmentTarget then
        expected = treatmentTarget + math.sqrt(pull);
      else
        expected = treatmentTarget - math.sqrt(pull);
      end
    end

    return math.abs(currentValue - expected);
end

function square(value)
  return value * value;
end

function shouldTreat(attribute, delta)
  if attribute.goal == 0 then
    return false;
  end

  if attribute.name == "Purity" then
    local min = attribute.attributes[attribute.goal].min;
    if attribute.value - min < 8 then
      return true;
    end
  else
    local targetValue = attribute.attributes[attribute.goal].target;
    if attribute.goal ~= attribute.attribute or math.abs(attribute.value - targetValue) > 8 then
      return true;
    end
  end

  return false;
end

function treatmentsRemaining()
  local count = 0;
  for index, data in pairs(materials[materialIndex].attributes) do
    if shouldTreat(data) then
      count = count + 1;
    end
  end

  return count;
end

function getTreatmentTime(index, treatment)
  local data            = materials[materialIndex].attributes[index];
  local treatmentTarget = treatment.targets[index];
  local delta           = 0;

  if treatmentsRemaining() == 1 then
    if data.value < treatmentTarget and data.attributes[data.goal].min < treatmentTarget then
      delta = treatmentTarget - data.attributes[data.goal].min - 1;
    elseif data.value > treatmentTarget and data.attributes[data.goal].max > treatmentTarget then
      delta = data.attributes[data.goal].max - treatmentTarget - 1;
    end
  end

  local time = math.ceil((square(data.value - treatmentTarget) - square(delta)) / 9);
  return math.min(10, time);
end

function goalsRemaining()
  local count = 0;
  for index, data in pairs(materials[materialIndex].attributes) do
    if data.goal ~= 0 then
      if data.name == "Purity" then
        if data.goal < data.attribute then
          return true;
        end
      elseif data.goal ~= data.attribute then
        return true;
      end
    end
  end

  return count;
end

function insertSuggestion(suggestions, treatmentIndex, score, time)
  if score <= 0 then
    return;
  end

  for index, suggestion in pairs(suggestions) do
    if score > suggestion.score then
      table.insert(suggestions, index, {
        treatmentIndex = treatmentIndex;
        score          = score;
        time           = time;
      });
      return;
    end
  end

  table.insert(suggestions, {
    treatmentIndex = treatmentIndex;
    score          = score;
    time           = time;
  });
end

function loadRecipes()
  if materials[materialIndex].recipes then
    return;
  end

  materials[materialIndex].recipes = {};

  local file = io.open(materials[materialIndex].file, "r");
  io.close(file);
  for line in io.lines(materials[materialIndex].file) do
    table.insert(materials[materialIndex].recipes, line);
  end
end

function hasRecipe(recipe)
  loadRecipes();

  for _, existingRecipe in pairs(materials[materialIndex].recipes) do
    if recipe == existingRecipe then
      return true;
    end
  end

  return false;
end

function saveRecipe(recipe)
  logfile = io.open(materials[materialIndex].file, "a+");
  logfile:write("\n" .. recipe);
  logfile:close();

  table.insert(materials[materialIndex].recipes, recipe);
  recipeData = {};
end

function displayRecipe()
  if #recipeData == 0 then
    return;
  end

  local names = {};
  for index, data in pairs(materials[materialIndex].attributes) do
    if data.attribute ~= nil then
      table.insert(names, data.attributes[data.attribute].name);
    end
  end

  local steps = {};
  for _, step in pairs(recipeData) do
    if step.treatment == steps[#steps - 1] then
      steps[#steps] = steps[#steps] + step.time;
    else
      table.insert(steps, step.treatment);
      table.insert(steps, step.time);
    end
  end
  local recipeText = table.concat(names, ", ") .. " : " .. table.concat(steps, " ") .. " - #treat_yo_self";

  if materialIndex == "metal" then
    local metalLine = findText("Metal in Bath:");
    local parsed = explode(":", metalLine[2]);
    local parsed = explode(",", parsed[2]);
    recipeText = "(" .. string.sub(parsed[1], 2) .. ") " .. recipeText;
  end

  if hasRecipe(recipeText) then
    lsPrint(5, 265, 0, 0.7, 0.7, 0xffffffff, "Recipe already in " .. materials[materialIndex].file);
  else
    lsPrint(80, 265, 0, 0.7, 0.7, 0xffffffff, "recipe to " .. materials[materialIndex].file)
    if ButtonText(5, 265, 0, 100, 0x80ff80ff, "Save", 0.7, 0.7) then
      saveRecipe(recipeText);
    end
  end
end

function displaySuggestedTreatment()
  srReadScreen();
  if not srFindImage("processComplete.png") then
    lsPrint(5, 225, 5, 0.7, 0.7, 0xffffff, "Processing");
    return;
  end

  if goalsRemaining() == 0 then
    lsPrint(5, 225, 5, 0.7, 0.7, 0xffffff, "Done");
    displayRecipe();
    return;
  end

  local priority = nil;
  for i = 1, #materials[materialIndex].priorities do
    local index = materials[materialIndex].priorities[i];
    local data  = materials[materialIndex].attributes[index];
    if shouldTreat(data) then
      priority = index;
      break;
    end
  end

  local suggestions = {};
  for treatmentIndex, treatment in pairs(materials[materialIndex].treatments) do
    local score         = 0;
    local time          = getTreatmentTime(priority, treatment);
    local priorityScore = getScore(priority, treatment, time);
    if priorityScore > 0 then
      for index, attribute in pairs(materials[materialIndex].attributes) do
        local multiplier = 1;
        if index == priority then
          multiplier = 1.25;
        elseif attribute.goal == attribute.attribute then
          multiplier = 1;
        end
        score = score + getScore(index, treatment, time) * multiplier;
      end

      score = math.max(1, score);
    end

    insertSuggestion(suggestions, treatmentIndex, score, time);
  end

  local y = 215;
  lsPrint(5, y, 5, 0.7, 0.7, 0xffffff, "Suggested Treatments (Pick One):");
  y = y + 25;
  for i = 1, 3 do
    local suggestion = suggestions[i];
    if suggestion ~= nil then
      local treatment = materials[materialIndex].treatments[suggestion.treatmentIndex];
      lsPrint(5, y, 5, 0.7, 0.7, suggestionData[i].color, suggestionData[i].name .. ":");
      if ButtonText(55, y, 5, 200, suggestionData[i].color, treatment.name, 0.7, 0.7) then
        if applyTreatment(treatment.name, suggestion.time) then
          treatment.used = treatment.used + math.ceil(suggestion.time / 10);
          table.insert(recipeData, {
            treatment = treatment.name,
            time      = suggestion.time
          });
        end
        return;
      end
      lsPrint(205, y, 5, 0.7, 0.7, suggestionData[i].color, " for " .. suggestion.time .. "s");
      y = y + 25;
    end
  end
end

function displayUsage()
  while true do
    local y = 5;
    lsPrint(5, y, 5, 0.7, 0.7, 0xffffffff, "Materials used:");
    y = y + 40;

    for index, data in pairs(materials[materialIndex].treatments) do
      lsPrint(5, y, 5, 0.7, 0.7, 0xffffffff, data.name .. ": " .. data.used);
      y = y + 20;
    end

    checkBreak();
    lsDoFrame();
    lsSleep(50);
    if lsButtonText(lsScreenX - 105, lsScreenY - 30, 0, 100, 0xffffffff, "Done") then
      break;
    end
  end
end

function applyTreatment(name, time)
  name = string.format(materials[materialIndex].treatmentMenuItem, name);

  clickWithError(materials[materialIndex].treatmentMenu);
  lsSleep(200);
  clickWithError(name);
  lsSleep(200);
  srKeyEvent(time);
  srKeyEvent(string.char(13));  -- Send Enter Key to close the window
  lsSleep(100);

  srReadScreen();
  return not srFindImage("ok.png");
end

function clickWithError(text)
    srReadScreen();
    foundText = findText(text);
    if not foundText then
      error('Unable to find the text "' .. text .. '" on the screen.');
    end
    clickText(foundText);
end

function doit()
  askForWindow(
    "Treat Yo' Self\n\n" ..
    "v1.0 by Kavad\n\n" ..
    "A dynamic wood and metal treatment macro\n\n" ..
    "Press shift over your ATITD window to start"
  );

  displayBuildingSelection();

  for index, data in pairs(materials[materialIndex].attributes) do
    data.goal = 0;
  end

  for index, data in pairs(materials[materialIndex].treatments) do
    data.used = 0;
  end

  displayGoals();

  while true do
    calcPos();

    lsPrint(5, 5, 5, 0.7, 0.7, 0xffffff, "Monitoring window for changes!");
    printProperty(25, "Name", "Value", "Attribute", "Goal");

    for index, data in pairs(materials[materialIndex].attributes) do
      data.value = calcValue(index);
      for attribute, attributeData in pairs(data.attributes) do
        if data.value == attributeData.target then
          data.attribute = attribute;
          break;
        elseif data.value < attributeData.max and data.value > attributeData.min then
          data.attribute = attribute;
          break;
        else
          data.attribute = nil;
        end
      end
    end

    displayProperties();

    displaySuggestedTreatment();

    if lsButtonText(5, lsScreenY - 30, 0, 100, 0xffff80ff, "Goals") then
      displayGoals();
    end
    if lsButtonText(lsScreenX - 105, lsScreenY - 30, 0, 100, 0xff8080ff, "Stop") then
      break;
    end
    checkBreak();
    lsDoFrame();
    lsSleep(50);
  end

  displayUsage();
end
