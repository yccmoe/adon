local AFFL_Quest = false			--임무추적장 자동 접힘
local AFFL_LossOfControl = true 	--행동 불능창 이동
local AFFL_AltInvite = true			--Alt 누르고 Click 시 자동초대
local AFFL_BattleMap = 1.2			--BattleMap Scale
local bSet = false;

local function AFFL_FixFrameSize()

	if bSet then
		return;
	end

	bSet = true;

	if AFFL_Quest and UnitLevel("player") == 120 then
		LoadAddOn("Blizzard_ObjectiveTracker")
		ObjectiveTracker_Collapse();
	end


	if AFFL_LossOfControl then
		local framecontrol = _G["LossOfControlFrame"];
		framecontrol:SetPoint("CENTER", 200, 0)

        LoadAddOn("asMOD");

        if asMOD_setupFrame then
            asMOD_setupFrame (framecontrol, "LossOfControlFrame");
        end

	end
	
	if AFFL_BattleMap then
		if not BattlefieldMapFrame then
			 LoadAddOn("Blizzard_BattlefieldMap")
		end
		BattlefieldMapFrame:SetScale(AFFL_BattleMap)

        LoadAddOn("asMOD");

        if asMOD_setupFrame then
            asMOD_setupFrame (BattlefieldMapFrame, "Blizzard_BattlefieldMap");
        end
	end

end

if AFFL_AltInvite then
	hooksecurefunc("SetItemRef", function(link)
    	local name = link and link:match("^player:([^:]+).*$")
	    if not name then return end
    	if IsAltKeyDown() then
        	InviteUnit(name); 
			ChatFrame1EditBox:Hide();
		end
end)
end

AFFL_FixFrameSize();
