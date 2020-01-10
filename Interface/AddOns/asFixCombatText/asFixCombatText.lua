﻿-- X, Y 좌표 위치
local ASCT_X_POSITION = 250
local ASCT_Y_POSITION = 610
local ASCT_STAGGERED = false -- 데미지 안내가 좌우로 퍼지게 하려면 true
local ASCT_DEFAULT_SHOW_HEAL = nil --Heal 보이게 하려면 1
local DAMAGE_COLOR = {1, 0.1, 0.1};
local SPELL_DAMAGE_COLOR = {0.79, 0.3, 0.85};
local DAMAGE_SHIELD_COLOR = {1, 0.3, 0.3};
local SPLIT_DAMAGE_COLOR = {1, 1, 1}

local function init_combattext()
	local bShowHeal = ASCT_DEFAULT_SHOW_HEAL

	LoadAddOn("Blizzard_CombatText")
	SetCVar("floatingCombatTextCombatState" , 1)

		
  	--	if CombatText_UpdateDisplayedMessages then
		CombatTextFont:SetFont("Fonts\\2002.ttf",18,"OUTLINE")
		COMBAT_TEXT_HEIGHT = 18;
		COMBAT_TEXT_CRIT_MAXHEIGHT = 24;
		COMBAT_TEXT_CRIT_MINHEIGHT = 18;
		COMBAT_TEXT_STAGGER_RANGE = 5;

		local role = nil

		--[[
		if GetSpecialization() ~= nil then

			role = GetSpecializationRole(GetSpecialization())
		end
	

		if role ~= nil and role == "TANK" then
			bShowHeal = nil	
			ChatFrame1:AddMessage("[ACT]방어특성이라 치유량 표시를 중지합니다.");
		end
		--]]
		--

		COMBAT_TEXT_TYPE_INFO["DAMAGE_SHIELD"] = {r = DAMAGE_SHIELD_COLOR[1], g = DAMAGE_SHIELD_COLOR[2], b = DAMAGE_SHIELD_COLOR[3], show = 1};
		COMBAT_TEXT_TYPE_INFO["SPLIT_DAMAGE"] = {r = SPLIT_DAMAGE_COLOR[1], g = SPLIT_DAMAGE_COLOR[2], b = SPLIT_DAMAGE_COLOR[3], show = 1};
		COMBAT_TEXT_TYPE_INFO["DAMAGE_CRIT"] = {r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], show = 1};
		COMBAT_TEXT_TYPE_INFO["DAMAGE"] = {r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], isStaggered = ASCT_STAGGERED, show = 1};

		COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE_CRIT"] = {r = SPELL_DAMAGE_COLOR[1], g = SPELL_DAMAGE_COLOR[2], b = SPELL_DAMAGE_COLOR[3], show = 1};
		COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = {r = SPELL_DAMAGE_COLOR[1], g = SPELL_DAMAGE_COLOR[2], b = SPELL_DAMAGE_COLOR[3], show = 1};

		COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"] = {r = 1, g = 0.1, b = 0.1, show = 1};
		COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"] = {r = 0.1, g = 1, b = 0.1, show = 1};


	
	
		COMBAT_TEXT_TYPE_INFO["HEAL_CRIT"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["HEAL"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_ABSORB"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["HEAL_CRIT_ABSORB"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["HEAL_ABSORB"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_CRIT"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		COMBAT_TEXT_TYPE_INFO["ABSORB_ADDED"] = {r = 0.1, g = 1, b = 0.1, show = bShowHeal};
		
	
		hooksecurefunc("CombatText_UpdateDisplayedMessages", ASCT_UpdateDisplayedMessages);
		ASCT_UpdateDisplayedMessages()

--	end
	return;
end 

function ASCT_UpdateDisplayedMessages()
 -- Update scrolldirection
  if ( COMBAT_TEXT_FLOAT_MODE == "1" ) then
    COMBAT_TEXT_SCROLL_FUNCTION = CombatText_StandardScroll;
    COMBAT_TEXT_LOCATIONS = {
      startX = ASCT_X_POSITION,
      startY = ASCT_Y_POSITION * COMBAT_TEXT_Y_SCALE,
      endX = ASCT_X_POSITION,
      endY = (ASCT_Y_POSITION + 225) * COMBAT_TEXT_Y_SCALE
    };

  elseif ( COMBAT_TEXT_FLOAT_MODE == "2" ) then
    COMBAT_TEXT_SCROLL_FUNCTION = CombatText_StandardScroll;
    COMBAT_TEXT_LOCATIONS = {
      startX = ASCT_X_POSITION,
      startY = (ASCT_Y_POSITION + 225) * COMBAT_TEXT_Y_SCALE,
      endX = ASCT_X_POSITION,
      endY =  ASCT_Y_POSITION * COMBAT_TEXT_Y_SCALE
    };
  else
    COMBAT_TEXT_SCROLL_FUNCTION = CombatText_FountainScroll;
    COMBAT_TEXT_LOCATIONS = {
      startX = ASCT_X_POSITION,
      startY = ASCT_Y_POSITION * COMBAT_TEXT_Y_SCALE,
      endX = ASCT_X_POSITION,
      endY = (ASCT_Y_POSITION + 225) * COMBAT_TEXT_Y_SCALE
    };
  end
  CombatText_ClearAnimationList();
end
init_combattext();

