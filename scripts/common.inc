-- common.inc
--
-- Common utility functions useful for most macros
--  A lot of this is ATITD specific and should be split out into truly common
--  code.

-- Time to wait between iterations when polling for state change.
tick_delay = 10;

-- Time to wait between independent clicks
click_delay = 50;

-- Whether to allow the user to pause the macro
allow_pause = true;

-- Error message to appear in statusScreen() calls
error_status = "";

-- Standard message to print when the user aborts the macro.
quit_message = "Macro aborted by user";


-------------------------------------------------------------------------------
-- singleLine(message)
--
-- Useful for embedding long text messages in code.
--
-- Converts a multi-line text blob into a single line. Whitespace at
-- the beginning and end is removed. Any newline followed by
-- whitespace is replaced by a single space.
--
-- message -- Blob of text to convert
-------------------------------------------------------------------------------

function singleLine(message)
  if not message then
    error("Incorrect number of arguments for singleLine()");
  end
  local str = string.gsub(message, "^%s+", "");
  str = string.gsub(message, "%s+$", "");
  return string.gsub(str, "\n%s*", " ");
end

-------------------------------------------------------------------------------
-- makePoint(x, y)
--
-- Make a table representing a single point.
--
-- x, y -- Position which becomes result[0], result[1]
-------------------------------------------------------------------------------

function makePoint(x, y)
  if x == nil or y == nil then
    print(debug.traceback());
    error("Incorrect number of arguments for makePoint()");
  end
  local result = {};
  result[0] = x;
  result[1] = y;
  return result;
end

-------------------------------------------------------------------------------
-- makeBox(x, y, width, height)
--
-- Make a table representing a box which bounds a rectangular region.
--
-- x, y -- Position of upper-left corner of the box
-- width, height -- Size of box
-------------------------------------------------------------------------------

function makeBox(x, y, width, height)
  if not x or not y or not width or not height then
    error("Incorrect number of arguments for makeBox()");
  end
  return
    {
      x = x,
      y = y,
      width = width,
      height = height,
      left = x,
      top = y,
      right = x + width,
      bottom = y + height
    };
end

-------------------------------------------------------------------------------
-- csplit(str, sep)
-- (DEPRECATED - USE EXPLODE()
-- Splits str into an array using sep as a single character seperator.
-- From: http://lua-users.org/wiki/SplitJoin
--
-- str -- string to be separated
-- sep -- single character
-------------------------------------------------------------------------------

function csplit(str,sep)
  local ret={}
  local n=1
  for w in str:gmatch("([^"..sep.."]*)") do
    ret[n]=ret[n] or w -- only set once (so the blank after a string is ignored)
    if w=="" then n=n+1 end -- step forwards on a blank but not a string
  end
  return ret
end

function explode(d,p)
   local t, ll
   t={}
   ll=0
   if(#p == 1) then
      return {p}
   end
   while true do
      l = string.find(p, d, ll, true) -- find the next d in the string
      if l ~= nil then -- if "not not" found then..
         table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
         ll = l + 1 -- save just after where we found it for searching next time.
      else
         table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
         break -- Break at end, as it should be, according to the lua manual.
      end
   end
   return t
end



dofile("common_fix.inc");
dofile("common_ui.inc");
dofile("common_wait.inc");
dofile("common_click.inc");
dofile("common_find.inc");
dofile("common_window.inc");
dofile("common_text.inc");
dofile("common_gps.inc");
