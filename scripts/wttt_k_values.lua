-- treated boards  v1.0 by Dunagain
-- helper for finding the k-values, can be used as a basis for a fully automated k-values finder

--  v1.0.1 by Cegaiel
-- Tweaked some values to work accurately on T8; along with some scaling and GUI tweaks.
-- See: https://www.atitd.org/wiki/tale6/Wood_Treatment_Guide for more info and understanding what this macro does.
-- Basically, every Wood Treatment Tanks are slightly different than others (K values).  One recipe might work on one tank, but not another.
-- This macro helps determine what your tank values are, to help figure out recipes later on.

-- v1.0.2 by Rhaom
-- Apparently many values aren't really valid anymore since Tale 8. Bonemeal and Charcoal added T8.
-- Rhaom did a lot of math and testing to get it super accuratate now. Should be working nice now ~Ceg
--

posTank = {};
posFlexibility = {} ;
posCuttability = {} ;
posFlammability = {} ;
posWaterResist = {} ;
posInsectTox = {} ;
posHumanTox = {} ;
posDarkness  = {} ;
posGlossiness = {} ;

flexibility = 0;
cuttability = 0;
flammability = 0;
waterResist = 0;
insectTox = 0;
humanTox = 0;
darkness = 0;
glossiness = 0;

trace = "" ;

blueColors = { 	0X010130FF, 0x0706FDFF, 0x0707FEFF,
				0x0706FEFF, 0x0606FDFF, 0x0605D4FF,
				0x0505D4FF, 0x0605D5FF, 0x040382FF,
				0x030382FF, 0x040383FF, 0x807FFEFF,
				0x7FFFFEFF, 0X2F2EFDFF, 0X2E2EFDFF,
				0xD0D0FFFF, 0x7F7FFEFF, 0x77FEFFFF,
			  0x76FEFFFF } ;

treatedWater = {} ;

dofile("common.inc");

askText = singleLine([[
  Treated Boards v1.0.2 by Dunagain -- Tweaked by Rhaom and Cegaiel for T8
  Helps you making treated boards with a wood treatment tank
]]);

function isRigid()
	return flexibility < 11 ;
end

function isPliable()
	return flexibility > 60 ;
end

function isHard()
	return cuttability < 11 ;
end

function isSoft()
	return cuttability > 60 ;
end

function isFireproof()
	return flammability < 11 ;
end

function isVolatile()
	return flammability > 60 ;
end

function isRotproof()
	return waterResist > 60 ;
end

function isTermiteProne()
	return insectTox < 11 ;
end

function isTermiteResistant()
	return insectTox > 60 ;
end

function isNonToxic()
	return humanTox < 11 ;
end

function isWhite()
	return darkness < 11 ;
end

function isBlonde()
	return (darkness > 10) and (darkness < 26) ;
end

function isBlack()
	return darkness > 60 ;
end

function isGlossy()
	return glossiness > 60 ;
end

function attributes()
	local result = "";
	if isRigid() then result = result .. "* Rigid\n" end;
	if isPliable() then result = result .. "* Pliable\n" end;
	if isHard() then result = result .. "* Hard\n" end;
	if isSoft() then result = result .. "* Soft\n" end;
	if isFireproof() then result = result .. "* Fireproof\n" end;
	if isVolatile() then result = result .. "* Volatile\n" end;
	if isRotproof() then result = result .. "* Rotproof\n" end;
	if isTermiteProne() then result = result .. "* Termite-Prone\n" end;
	if isTermiteResistant() then result = result .. "* Termite-Resistant\n" end;
	if isNonToxic() then result = result .. "* Non-Toxic\n" end;
	if isWhite() then result = result .. "* White\n" end;
	if isBlonde() then result = result .. "* Blonde\n" end;
	if isBlack() then result = result .. "* Black\n" end;
	if isGlossy() then result = result .. "* Glossy" end;
	return result;
end


function matchPixel(pixel)
local match = false;
	for k,v in pairs(blueColors)
	do
		local d = v - pixel ;
		if (d % 4294967296 ==  0)
		then
			match = true  ;
		end
	end
	return match;
end

function calcParam(xpos, ypos)
local result = 0;
	local pixel = srReadPixelFromBuffer(xpos, ypos) ;

	while (matchPixel(pixel) == true)
	do
		result = result + 1 ;
		xpos = xpos + 1;
		pixel = srReadPixelFromBuffer(xpos, ypos) ;
	end
	return result;
end

function calcFlexibility()
	return calcParam(posFlexibility[1], posFlexibility[2]);
end

function calcCuttability()
	return calcParam(posCuttability[1], posCuttability[2]);
end

function calcFlammability()
	return calcParam(posFlammability[1], posFlammability[2]);
end

function calcWaterResist()
	return calcParam(posWaterResist[1], posWaterResist[2]);
end

function calcInsectTox()
	return calcParam(posInsectTox[1], posInsectTox[2]);
end

function calcHumanTox()
	return calcParam(posHumanTox[1], posHumanTox[2]);
end

function calcDarkness()
	return calcParam(posDarkness[1], posDarkness[2]);
end

function calcGlossiness()
	return calcParam(posGlossiness[1], posGlossiness[2]);
end

function calcPos()
    srReadScreen();
	posTank = findImage("ThisIs.png");
      while not posTank do
        checkBreak();
        srReadScreen();
	  posTank = findImage("ThisIs.png");
        sleepWithStatus(250,"Could not find Wood Treatment Tank window ..." ..
				"\n\nIs it pinned and 'This is' showing?",nil, 0.7);
      end
				if label then
					posFlexibility = { posTank[0] + 104 , posTank[1] + 210  } ;
					posCuttability = { posTank[0] + 104 , posTank[1] + 226  } ;
					posFlammability = { posTank[0] + 104 , posTank[1] + 242  } ;
					posWaterResist = { posTank[0] + 104 , posTank[1] + 258  } ;
					posInsectTox = { posTank[0] + 104 , posTank[1] + 274  } ;
					posHumanTox = { posTank[0] + 104 , posTank[1] + 290  } ;
					posDarkness  = { posTank[0] + 104 , posTank[1] + 306  } ;
					posGlossiness = { posTank[0] + 104 , posTank[1] + 322  } ;
				else
					posFlexibility = { posTank[0] + 104 , posTank[1] + 209  } ;
					posCuttability = { posTank[0] + 104 , posTank[1] + 225  } ;
					posFlammability = { posTank[0] + 104 , posTank[1] + 241  } ;
					posWaterResist = { posTank[0] + 104 , posTank[1] + 257  } ;
					posInsectTox = { posTank[0] + 104 , posTank[1] + 273  } ;
					posHumanTox = { posTank[0] + 104 , posTank[1] + 289  } ;
					posDarkness  = { posTank[0] + 104 , posTank[1] + 305  } ;
					posGlossiness = { posTank[0] + 104 , posTank[1] + 321  } ;
				end
end

function doit()
	local done = false

	local finished = false;
	local num_seconds
	local estimation = 0
	local start_time = lsGetTimer();

	askForWindow("Wood Treatment Tank - K Values v1.0.2 by Dunagain -- Tweaked by Rhaom and Cegaiel for T8." ..
	"\n\nPin your Wood Treatment Tank window.\n\nPin the Treat... window so it won't interfere with the reading" ..
	" of values. The macro does NOT click on the menu, you just pin it for convenience." ..
	"\n\nThen press shift to start the K-Values lookup.") ;
	calcPos() ;


	while not finished
	do
		local startFlexibility = calcFlexibility();
		local startCuttability = calcCuttability();
		local startFlammability = calcFlammability();
		local startWaterResist = calcWaterResist();
		local startInsectTox = calcInsectTox();
		local startHumanTox = calcHumanTox();
		local startDarkness = calcDarkness();
		local startGlossiness = calcGlossiness();

		local suggestFlex = false;
		local suggestCut = false;
		local suggestFlam = false;
		local suggestWater = false;
		local suggestInsect = false;
		local suggestHuman = false;
		local suggestDark = false;
		local suggestGloss = false;

		local suggest = "From this position, I suggest that you try to:\n ";
		local suggestion = "" ;

		if (startFlexibility < 11) then
			suggestion = suggestion .. "\n- Raise Flexibility with Bonemeal to 72 or with Saltpeter to 64" ;
		else
			if (startFlexibility > 60) then
				suggestion = suggestion .. "\n- Lower Flexibility with Lime to 0 or Lead to 8" ;
			end
		end
		if (startCuttability < 11) then
			suggestion = suggestion .. "\n- Raise Cuttability with Saltpeter to 72 or with Potash to 64" ;
		else
			if (startCuttability > 60) then
				suggestion = suggestion .. "\n- Lower Cuttability with Charcoal to 0 or Lead to 8" ;
			end
		end
		if (startFlammability < 11) then
			suggestion = suggestion .. "\n- Raise Flammability with Petroleum to 72 or with Sulfur to 64" ;
		else
			if (startFlammability > 60) then
				suggestion = suggestion .. "\n- Lower Flammability with Ash to 0 or Lime to 8" ;
			end
		end
		if (startWaterResist < 11) then
			suggestion = suggestion .. "\n- Raise Water Resist with Beeswax to 72 or with Petroleum to 64" ;
		else
			if (startWaterResist > 60) then
				suggestion = suggestion .. "\n- Lower Water Resist with Water to 0 or Potash to 8" ;
			end
		end
		if (startInsectTox < 11) then
			suggestion = suggestion .. "\n- Raise InsectTox with Lead to 72 or with Petroleum to 64" ;
		else
			if (startInsectTox > 60) then
				suggestion = suggestion .. "\n- Lower InsectTox with Water to 0 or Lime to 8" ;
			end
		end
		if (startHumanTox < 11) then
			suggestion = suggestion .. "\n- Raise HumanTox with Sulfur to 72 or with Lead to 64" ;
		else
			if (startHumanTox > 60) then
				suggestion = suggestion .. "\n- Lower HumanTox with Bonemeal to 0 or Saltpeter to 8" ;
			end
		end
		if (startDarkness < 11) then
			suggestion = suggestion .. "\n- Raise Darkness with Charcoal to 72 or with Lead to 64" ;
		else
			if (startDarkness > 60) then
				suggestion = suggestion .. "\n- Lower Darkness with Lime to 0 or Potash to 8" ;
			end
		end
		if (startGlossiness < 11) then
			suggestion = suggestion .. "\n- Raise Glossiness with Beeswax to 72" ;
		else
			if (startGlossiness > 60) then
				suggestion = suggestion .. "\n- Lower Glossiness with Ash to 0 or Potash to 8" ;
			end
		end

		if string.len(suggestion) == 0 then
		  suggestion = "\nNo suggestion available in this state!";
		end

		done = false;
		while not done
		do
			lsPrintWrapped(10, 10, 5, lsScreenX-15, 0.7, 0.7, 0xFFFFFFFF,
				"Press start before treating the boards! (Read the Wood Treatment Guide on wiki, the part about the K-Values" ..
				", if you don't know what to do).\n\n\n" .. suggest .. suggestion) ;

					label = CheckBox(10, 80, 5, 0xffff40ff, " Wood Treatment Tank has been labeled", label, 0.65, 0.65);

			checkBreak();
			lsDoFrame();
			lsSleep(25);
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, 0x80ff80ff, "Start") then
				done = true;
			end
		end
		done = false
		start_time = lsGetTimer();


		while not done
		do
			calcPos() ;
			flexibility = calcFlexibility();
			cuttability = calcCuttability();
			flammability = calcFlammability();
			waterResist = calcWaterResist();
			insectTox = calcInsectTox();
			humanTox = calcHumanTox();
			darkness = calcDarkness();
			glossiness = calcGlossiness();

			lsPrintWrapped(10, 10, 5, lsScreenX-15, 0.8, 0.8, 0xFF0000ff,
				"DO NOT click the tank window after you start processing " ..
				"as the 'Last Added' line will break the monitoring!") ;

			lsPrintWrapped(10, 75, 5, lsScreenX-15, 0.8, 0.8, 0xFFFFFFFF,
				"Monitoring window for real-time changes!\n\n" ..
				"Flexibility: " .. tostring(flexibility) .. "\n" ..
				"Cuttability: " .. tostring(cuttability) .. "\n" ..
				"Flammability: " .. tostring(flammability)  .. "\n" ..
				"Water Resist: " .. tostring(waterResist)  .. "\n" ..
				"Insect Toxicity: " .. tostring(insectTox)  .. "\n" ..
				"Human Toxicity: " .. tostring(humanTox) .. "\n" ..
				"Darkness: " .. tostring(darkness) .. "\n" ..
				"Glossiness: " .. tostring(glossiness) .. "\n\n" ..
			 attributes() .. "\n\n" .. trace) ;
			checkBreak();
			lsDoFrame();
			lsSleep(25);
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, 0xff8080ff, "Stop") then
				done = true;
			end
		end
		estimation = math.floor((lsGetTimer() - start_time) / 1000);
		num_seconds = promptNumber("How many seconds? [" .. estimation .. "]" , estimation);
		done = false
		local kvalue = "" ;
		local endFlexibility = flexibility;
		local endCuttability = cuttability;
		local endFlammability = flammability;
		local endWaterResist = waterResist;
		local endInsectTox = insectTox;
		local endHumanTox = humanTox;
		local endDarkness = darkness;
		local endGlossiness = glossiness;
		while not done
		do

			lsPrintWrapped(10, 25, 5, lsScreenX-15, 0.8, 0.8, 0xFFFFFFFF,
				"Select the property that you have been watching:"
			 ) ;
			if ButtonText(10, lsScreenY - 270, 0, 200, 0xFFFFFFff, "Flexibility") then
				kvalue = "Formula: (" .. math.abs(endFlexibility) .. " - " .. math.abs(startFlexibility) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endFlexibility - startFlexibility)*2 / (2 * num_seconds))
        done = true;
			end
			if ButtonText(10, lsScreenY - 240, 0, 200, 0xFFFFFFff, "Cuttability") then
				kvalue = "Formula: (" .. math.abs(endCuttability) .. " - " .. math.abs(startCuttability) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endCuttability - startCuttability)*2 / (2 * num_seconds))
				done = true;
			end
			if ButtonText(10, lsScreenY - 210, 0, 200, 0xFFFFFFff, "Flammability") then
				kvalue = "Formula: (" .. math.abs(endFlammability) .. " - " .. math.abs(startFlammability) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endFlammability - startFlammability)*2 / (2 * num_seconds))
				done = true;
			end
			if ButtonText(10, lsScreenY - 180, 0, 200, 0xFFFFFFff, "Water Resist") then
				kvalue = "Formula: (" .. math.abs(endWaterResist) .. " - " .. math.abs(startWaterResist) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endWaterResist - startWaterResist)*2 / (2 * num_seconds))
				done = true;
			end
			if ButtonText(10, lsScreenY - 150, 0, 200, 0xFFFFFFff, "Insect Toxicity") then
				kvalue = "Formula: (" .. math.abs(endInsectTox) .. " - " .. math.abs(startInsectTox) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endInsectTox - startInsectTox)*2 / (2 * num_seconds))
				done = true;
			end
			if ButtonText(10, lsScreenY - 120, 0, 200, 0xFFFFFFff, "Human Toxicity") then
				kvalue = "Formula: (" .. math.abs(endHumanTox) .. " - " .. math.abs(startHumanTox) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endHumanTox - startHumanTox)*2 / (2 * num_seconds))
				done = true;
			end
			if ButtonText(10, lsScreenY - 90, 0, 200, 0xFFFFFFff, "Darkness") then
				kvalue = "Formula: (" .. math.abs(endDarkness) .. " - " .. math.abs(startDarkness) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endDarkness - startDarkness)*2 / (2 * num_seconds))
				done = true;
			end
			if ButtonText(10, lsScreenY - 60, 0, 200, 0xFFFFFFff, "Glossiness") then
				kvalue = "Formula: (" .. math.abs(endGlossiness) .. " - " .. math.abs(startGlossiness) .. ") " ..
				"* 2 / (2 * " .. num_seconds .. ")\nValue: " ..
				tostring((endGlossiness - startGlossiness)*2 / (2 * num_seconds))
				done = true;
			end
			checkBreak();
			lsDoFrame();
			lsSleep(25);
		end
		done = false
		while not done
		do
			lsPrintWrapped(10, 25, 5, lsScreenX-15, 0.8, 0.8, 0xFFFFFFFF,
				kvalue
			 ) ;
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, 0xFFFFFFff, "Again") then
				done = true;
			end
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				finished = true;
				done = true;
			end
			checkBreak();
			lsDoFrame();
			lsSleep(25);
		end
	end

end
