dofile("common.inc");

local file = nil;

function doit()
  askForWindow([[
Blessed Moss
v1.0 by Kavad

This program will bless an aqueduct tower,
keep track of changes to moss attributes,
and log those changes to a file.

Hover over the ATITD window and press shift.
]]);

  srReadScreen();

  local coords = findCoords();
  while not coords do
    coords = findCoords();

    sleepWithStatus(250, "Looking for coords");
    checkBreak();
  end

  local date = getTime("datetime2");
  while not date do
    date = getTime("datetime2");

    sleepWithStatus(250, "Looking for date");
    checkBreak();
  end

  file = "moss_" .. coords[0] .. "_" .. coords[1] .. "_" .. date .. ".txt";

  waitAndClickText("This is a Aqueduct");

  local previous = getMossAttributes();
  writeLine("Starting Attributes: " .. getMossString(previous));

  local tally = 0;
  while true do
    waitAndClickText("Bless this Aqueduct");
    sleepWithStatus(10000, "Giving attributes a chance to update");
    waitAndClickText("This is a Aqueduct");
    tally = tally + 1;

    lsSleep(100);
    srReadScreen();

    local current = getMossAttributes();
    local changes = getAttributeChange(current, previous);
    writeLine("Blessing: " .. tally);
    if #changes.added > 0 then
      writeLine("  Added: " .. getMossString(changes.added));
    end
    if #changes.removed > 0 then
      writeLine("  Removed: " .. getMossString(changes.removed));
    end

    previous = current;
    sleepWithStatus(80000, "Blessed " .. tally .. " times");
  end
end

function writeLine(line)
  logfile = io.open(file, "a+");
  logfile:write(line .. "\n");
  logfile:close();
end

function getMossString(attributes)
  local names = {};
  for _, attribute in pairs(attributes) do
    table.insert(names, attribute);
  end

  return table.concat(names, ", ");
end

function getAttributeChange(current, previous)
  local diff = {
    added = {},
    removed = {}
  };

  if previous == nil then
    return diff;
  end

  for _, attribute in pairs(current) do
    if not previous[attribute] then
      table.insert(diff.added, attribute);
    end
  end

  for _, attribute in pairs(previous) do
    if not current[attribute] then
      table.insert(diff.removed, attribute);
    end
  end

  return diff;
end

function getMossAttributes()
  local mossParse = findText("Some .+ moss grows here.", nil, REGEX);
  if not mossParse then
    return nil;
  end

  local mossString = string.match(mossParse[2], "Some (.+) moss grows here");

  local attributes = explode(", ", mossString);
  local keyed = {};
  for _, attribute in pairs(attributes) do
    if attribute ~= "common" then
      attribute = string.gsub(attribute, "^%s+", "")
      keyed[attribute] = attribute;
    end
  end

  return keyed;
end

function waitAndClickText(text)
  clickText(waitForText(
    text,
    nil,
    "Waiting to click text '" .. text .. "'"
  ));
end
