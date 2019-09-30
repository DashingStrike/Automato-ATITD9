  srReadScreen();
  size = srGetWindowSize()
  x = size[0];
  y = size[1];
  centerX = x/2;
  centerY = y/2;

  clockUpperLeftX = centerX-110;
  clockUpperLeftY = 15;
  clockWidth = (centerX + 125) - clockUpperLeftX;
  clockHeight = 50;


  neutral = srFindImage("faction_neutral.png", 2000);
  hyksos = srFindImage("faction_hyksos.png", 2000);
  kush = srFindImage("faction_kush.png", 2000);
  meshwesh = srFindImage("faction_meshwesh.png", 2000);
 

  if neutral then
    faction = "Neutral";
    srSetWindowInvertColorRange(0x68640c, 0xb09f32); -- Not Valid, placeholder

  elseif hyksos then
    faction = "Hyksos";
    srSetWindowInvertColorRange(0x68640c, 0xe0dec2);
    --srSetWindowInvertColorRange(0x000000, 0xFeFeFe);
    srSetWindowInvertColorRange(0x68640c, 0xC0B129);

  elseif kush then
    faction = "Kush";
    srSetWindowInvertColorRange(0x68640c, 0xb09f32); -- Not Valid, placeholder

  elseif meshwesh then
    faction = "Meshwesh";
    srSetWindowInvertColorRange(0x68640c, 0xb09f32); -- Not Valid, placeholder

  else
    error("Could not detect faction");
  end


