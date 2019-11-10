-------------------------------------------------------------------------------
-- findAllTextRegions
--
-- Finds all regions on the screen completely surrounded by 4 black lines.
-- Intentionally does not find regions where a corner is covered up.
--
-- Returns an array of region objects on success, nil if no regions are found.
-- DEPRECATED. Use findText or findAllText instead.
-------------------------------------------------------------------------------
function findAllTextRegions()
  lsPrintln("findAllTextRegions is deprecated. Do not call this anymore");
  local xyWindowSize = srGetWindowSize();
  local y = 0;
  local buttons = {};
  local pos = srFindFirstTextRegion();
  if not pos then
    return nil;
  end
  --trim off the outside edges of the window
  while 1 do
    buttons[#buttons+1] = pos;
    pos = srFindNextTextRegion(pos[0] + 1, pos[1]);
    if not pos then
      break;
    end
  end
  local i;
  for i = 1, #buttons do
    buttons[i][0] = buttons[i][0] + 1;
    buttons[i][1] = buttons[i][1] + 1;
    buttons[i][2] = buttons[i][2] - 30;
    buttons[i][3] = buttons[i][3] - 2;
  end
  return buttons;
end

-------------------------------------------------------------------------------
-- stripRegion(region)
--
-- Strips a region of all background color.  Recommended to call only from
-- Library functions.
-- region - region to be stripped
--
-- always returns nil
-------------------------------------------------------------------------------

function stripRegion(region)
  if region then
    srStripRegion(region[0], region[1], region[2], region[3]);
  end
end

-------------------------------------------------------------------------------
-- parseRegion(region)
--
-- parses a region for text.
-- region - region to be parsed
--
-- returns an array of parse objects, one per line of text in the region
-------------------------------------------------------------------------------

function parseRegion(region)
  if region then
    return parseText(region[0], region[1], region[2], region[3]);
  end
end

-------------------------------------------------------------------------------
-- getChatText()
--
-- Reads the chat screen and finds all the text on it.
--
-- returns a list of parse objects for all the chat on the screen.  Chats that
-- span multiple lines are combined into a single parse object, delineated by
-- lines that start with [time]
-------------------------------------------------------------------------------

function getChatText()
  local creg = findChatRegionReplacement();
  while not creg do
    srReadScreen();
    creg = findChatRegionReplacement();
    sleepWithStatus(100,"Can\'t find \'Main\' Chat Tab.\n\nTry moving the chat window so that all four borders are visible.\n\nAlso make sure Automato or no other windows are partially covering the chat region.", nil, 0.7, "Searching for Main Chat");
  end
  -- The below line is a hack introduced for T7 to handle the fact that
  -- there isn't as much of a buffer below chat as there was in T6 and prior.
  creg[3] = creg[3] + 1;
  stripRegion(creg);
  local p = parseRegion(creg);
  local count = 1;
  local first = nil;
  local p2 = {};
  if p then
    --search through lines until we get to the first section that starts with a [time]
    for i = 1, #p do
      if string.match(p[i][2], "%d?h?%d+m]") then
        if first == nil then
          count = i;
        else
          count = count + 1;
        end
        p2[count] = p[i];
        first = 1;
      else
        if first ~= nil then
          p2[count][2] = p2[count][2] .. " " .. p[i][2];
          -- p[i] = nil;
        else
          p2[count] = p[i];
          count = i + 1;
        end
      end
    end
  end
  return p2;
end

-------------------------------------------------------------------------------
-- getAllText()
--
-- finds all the text on the screen.  May need deprecation.
--
-- returns an array of parse objects of every item on the screen.
-- Generally only useful for debug
-------------------------------------------------------------------------------

function getAllText()
  local r = findAllTextRegions();
  local p;
  if r then
    local i;
    local retText = {};
    local count = 1;
    for i = 1, #r do
      stripRegion(r[i]);
      p = parseRegion(r[i]);
      local numP;
      if p then
        for numP = 1, #p do
          retText[count] = p[numP];
          count = count + 1;
        end
      end
    end
    if count == 1 then
      return nil;
    else
      return retText;
    end
  end
end

-------------------------------------------------------------------------------
-- findRegionWithText(text, isExact)
--
-- Searches for the desired text
-- text - text we're looking for
-- isExact (optional) - true if we want to return true only if the line contains
-- the exact text specified
--
-- returns the first region object containing the desired text
-- DEPRECATED. use findText() instead.
-------------------------------------------------------------------------------

function findRegionWithText(text, isExact)
  lsPrintln("findRegionWithText IS DEPRECATED! use findText() instead");
  f = findAllTextRegions();
  local i;
  if f then
    for i = 1, #f do
      if findTextInRegion(f[i], text, isExact) then
        return f[i];
      end
    end
  end
  return nil;
end

-------------------------------------------------------------------------------
-- parseText (x, y, w, h)
--
-- wrapper for srParseTextRegion so that it returns data in an array of parses
-- instead of a 1-dimensional array of parses.  Call parseRegion instead of this.
--
-- returns an array of parse objects
-------------------------------------------------------------------------------

function parseText(x, y, w, h)
  local table = srParseTextRegion(x, y, w, h);
  if table == nil then
    return nil;
  end
  local found = (#table +1)/ 3;
  local newTable = {};
  for i = 1, found, 1 do
    newTable[i] = {};
    newTable[i][0] = table[(i-1)*3];
    newTable[i][1] = table[(i-1)*3+1];
    newTable[i][2] = table[(i-1)*3+2];
  end
  return newTable;
end


-------------------------------------------------------------------------------
-- getInventoryText()
--
-- Returns the table of parses for all text in the inventory region.
-------------------------------------------------------------------------------
function getInventoryText()
  local inventoryRegion = srFindInvRegion()
  if inventoryRegion then
    stripRegion(inventoryRegion);
    local table = parseRegion(inventoryRegion);

    return table
  end

  return nil
end
